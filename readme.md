# MWS - Infraestrutura de Banco de Dados
### MVP - Tech Challenge (Gestão de Oficina Mecânica)

Este repositório contém o código de **Infraestrutura como Código (IaC)** utilizando Terraform para o provisionamento do banco de dados relacional gerenciado (Amazon RDS) para o sistema MWS.

---

## Organização do Ecossistema (4 Repositórios)
Para atender aos requisitos de desacoplamento, segurança e responsabilidade única, o projeto está estruturado em 4 repositórios distintos:

| Componente | Repositório | Descrição do Componente |
| :--- | :--- | :--- |
| **MWS** | `mws` | Código-fonte dos microsserviços (PHP/Laravel), Dockerfiles e manifestos K8s. |
| **MWS-Serverless-Auth** | `mws-serverless-auth` | Função AWS Lambda para validação de CPF e geração de Token JWT. |
| **MWS-Infra-Kubernetes** | `mws-infra-Kubernetes` | Código Terraform para provisionamento do cluster Amazon EKS e API Gateway. |
| **MWS-Infra-Database (Este)** | `mws-infra-database` | Código Terraform para provisionamento do banco de dados Amazon RDS. |

---

## Arquitetura e Decisões Técnicas (IaC)
Este repositório implementa as diretrizes definidas na documentação arquitetural:

* **Amazon RDS (MySQL 8.0):** Em conformidade com a **RFC 001**, a escolha por um banco de dados relacional gerenciado garante consistência transacional (ACID) para o Core Domain de Ordens de Serviço, removendo a carga operacional de gerenciamento de backups e patches da equipe.
* **Isolamento de Rede:** O banco é provisionado em uma sub-rede privada dentro da VPC, sem IP público. O acesso é estritamente controlado via Security Groups atrelados aos Nodes do EKS e à função AWS Lambda.

---

## Pipeline de CI/CD e Governança
Este repositório utiliza automação via **GitHub Actions** para garantir que apenas código validado altere o estado do banco de dados.

Fluxo da Pipeline:
1. Pull Request / Push na branch main.
2. `terraform fmt -check`: Validação de estilo e formatação.
3. `terraform init & terraform validate`: Verificação de sintaxe e módulos.
4. `terraform plan`: Geração da previsão de mudanças na infraestrutura.
5. `terraform apply`: Deploy das alterações (apenas merge na main).

**Proteção de Branches:** A branch `main` possui bloqueio para commits diretos, exigindo **Pull Request (PR)** aprovado.

---

## Instruções de Execução

> **Nota de Contingência Arquitetural:** Devido à limitação/expiração dos créditos da conta de laboratório da AWS Academy durante o ciclo final de desenvolvimento, os bancos de dados foram emulados e instanciados internamente no cluster Kubernetes local (Docker Desktop) como fallback, garantindo a entrega do MVP funcional.

### Pré-requisitos
* Terraform CLI instalado.
* Acesso via AWS CLI configurado.

### Passos para Validação Local do Terraform
1. Clone o repositório.
2. Inicialize o diretório Terraform:
   ```bash
   terraform init
   ```
3. Visualize as alterações planejadas:
   ```bash
   terraform plan
   ```
4. Aplique a configuração (requer conta AWS ativa):
   ```bash
   terraform apply -auto-approve
   ```

---

### Documentação e APIs
[Acesse a Documentação no Notion](https://www.notion.so/TECH-CHALLENGE-338b36cb511a80cb9c12d5c70c5682c7?source=copy_link) <br>
[RFC 001 - Adoção de Banco de Dados Relacional Gerenciado (Amazon RDS MySQL)]([https://gustavo-5520387.postman.co/workspace/Gustavo's-Workspace~e01e23b1-b0c9-4148-8bea-f931ea6d3628/collection/45952571-cfa04a96-15fd-4662-b65d-0e6b27d75d80?action=share&creator=45952571](https://app.notion.com/p/RFC-001-Ado-o-de-Banco-de-Dados-Relacional-Gerenciado-Amazon-RDS-MySQL-3d5b36cb511a802c9012dcace75197c5?source=copy_link))

---

## Autor
- Gustavo Pirolo - Cientista da Computação & Junior Development Analyst
- Apelido do Servidor: Gustavo Pirolo - RM371637
