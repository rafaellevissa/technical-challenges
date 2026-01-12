resource "aws_iam_role" "batch_service_role" {
  name = "batch-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "batch.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "batch_service_role_attach" {
  role       = aws_iam_role.batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_s3_bucket" "worker_data" {
  bucket        = "app-worker-jobs-data-prod"
  force_destroy = true
}

resource "aws_batch_compute_environment" "fargate" {
  compute_environment_name = "worker-fargate-env"
  type                     = "MANAGED"
  
  service_role = aws_iam_role.batch_service_role.arn

  compute_resources {
    type      = "FARGATE"
    max_vcpus = 4
    subnets   = var.private_subnets
    security_group_ids = [aws_security_group.worker_sg.id]
  }

  depends_on = [aws_iam_role_policy_attachment.batch_service_role_attach]
}

resource "aws_batch_job_queue" "main" {
  name     = "worker-job-queue"
  state    = "ENABLED"
  priority = 1
  
  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.fargate.arn
  }
}

resource "aws_batch_job_definition" "job" {
  name = "s3-processor"
  type = "container"
  
  container_properties = jsonencode({
    image = "${var.ecr_repository_url}:latest"
    
    executionRoleArn = aws_iam_role.batch_exec_role.arn
    jobRoleArn       = aws_iam_role.batch_exec_role.arn

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    resourceRequirements = [
      { type = "VCPU", value = "0.25" },
      { type = "MEMORY", value = "512" }
    ]
    
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.batch_logs.name
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "s3-processor"
      }
    }
  })
}

resource "aws_iam_role" "sfn_role" {
  name = "step-functions-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "states.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "sfn_batch_policy" {
  name = "sfn-batch-policy"
  role = aws_iam_role.sfn_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["batch:SubmitJob", "batch:DescribeJobs", "batch:TerminateJob"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["events:PutTargets", "events:PutRule", "events:DescribeRule"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_sfn_state_machine" "pipeline" {
  name     = "WorkerOrchestration"
  role_arn = aws_iam_role.sfn_role.arn
  
  definition = jsonencode({
    StartAt = "BatchJob",
    States = {
      BatchJob = {
        Type = "Task",
        Resource = "arn:aws:states:::batch:submitJob.sync",
        Parameters = {
          JobDefinition = aws_batch_job_definition.job.arn,
          JobName       = "WorkerTask",
          JobQueue      = aws_batch_job_queue.main.arn
        },
        End = true
      }
    }
  })
}

resource "aws_security_group" "worker_sg" {
  name   = "worker-batch-sg"
  vpc_id = var.vpc_id
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "batch_exec_role" {
  name = "batch-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = ["ecs-tasks.amazonaws.com", "batch.amazonaws.com"] }
    }]
  })
}

resource "aws_cloudwatch_log_group" "batch_logs" {
  name              = "/aws/batch/job"
  retention_in_days = 1
}
