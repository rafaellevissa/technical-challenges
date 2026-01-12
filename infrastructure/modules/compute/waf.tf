resource "aws_wafv2_web_acl" "rate_limit" {
  name        = "api-protection"
  scope       = "REGIONAL"
  
  default_action {
    allow {}
  }

  rule {
    name     = "IPRateLimit"
    priority = 1
    
    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFRateLimit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "api-protection-main"
    sampled_requests_enabled   = true
  }
}