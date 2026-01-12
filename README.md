# Infraestrutura Multi-Ambiente: Backend & Data Processing

Este repositório contém o código Terraform para provisionar uma infraestrutura robusta, preparada para processamento em larga escala e aplicações distribuídas.

## Estrutura do Projeto

Todo o código Terraform está localizado dentro do diretório `/infrastructure`.

```text
.
├── infrastructure/
│   ├── main.tf            # Chamada dos módulos
│   ├── providers.tf       # Configuração AWS/LocalStack
│   ├── terraform.tfvars   # VARIÁVEIS SENSÍVEIS (Você deve criar)
│   ├── modules/           # Rede, Compute, Frontend, Worker
│   └── ...
└── docker-compose.yml     # LocalStack Pro

```

---

## Como Rodar Localmente (LocalStack Pro)

## 1. Configuração do LocalStack Pro (Obrigatório)

Para ativar os serviços como EKS e RDS, você precisa do seu `LOCALSTACK_AUTH_TOKEN`.

Execute no terminal antes de subir o Docker:

```bash
export LOCALSTACK_AUTH_TOKEN="seu_token_aqui"

```

### 2. Preparação do Sistema (Linux)

O LocalStack Pro utiliza o domínio `localhost.localstack.cloud` para gerenciar o tráfego do Kubernetes (OIDC). Você precisa mapear esse DNS no seu sistema.

No terminal, execute:

```bash
echo "127.0.0.1 localhost.localstack.cloud" | sudo tee -a /etc/hosts

```

### 3. Configuração das Variáveis

Entre na pasta `infrastructure/` e crie o arquivo `terraform.tfvars`. **Este passo é obrigatório** para que o Terraform conheça seus parâmetros:

```bash
cd infrastructure/
touch terraform.tfvars

```

Cole o conteúdo abaixo (ajustando conforme necessário):

```hcl
aws_region    = "us-east-1"
vpc_cidr      = "10.0.0.0/16"
domain_name   = "meuapp.local"
db_password   = "SuaSenhaForteAqui" # Não use aspas simples

```

### 4. Iniciando o LocalStack

Garanta que seu `docker-compose.yml` inclua o mapeamento do socket do Docker e as portas do EKS. Na raiz do projeto:

```bash
docker-compose up -d

```

### 5. Deploy da Infraestrutura

Com o LocalStack rodando, aplique o Terraform:

```bash
cd infrastructure/
terraform init
terraform apply --auto-approve

```

---

## Como Rodar em Ambiente Real (AWS)

Para migrar para a nuvem real, siga estes passos:

1. **Ajuste o `providers.tf`:** Comente ou remova o bloco `endpoints { ... }` e as flags `skip_*`. O Terraform passará a falar com os servidores reais da Amazon.
2. **Atualize o `terraform.tfvars`:** * Mude o `domain_name` para um domínio real (ex: `meuapp.com`).
* Certifique-se de que a `db_password` segue as políticas de complexidade do AWS RDS.


3. **Deploy:** 
```bash
export AWS_PROFILE=seu-perfil-aws
terraform apply
```
