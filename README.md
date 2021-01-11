# monorepo-container-build-example

This is an example of a container build environment for Monorepo using AWS CodeBuild.

## Requirements

- AWS Account
- Terraform

## Usage

### Prepare before running Terraform

Register the Registry URI of Amazon ECR in AWS Systems Manager Parameter Store.

```sh
$ aws --region ap-northeast-1 ssm put-parameter --name "/ecr/registry_uri" --type "String" --value "[aws_account_id].dkr.ecr.ap-northeast-1.amazonaws.com"
```

[aws_account_id] is Specify your AWS account ID.

### Run Terraform

```sh
$ cd terraform
$ terraform init
$ terraform apply
```

### Run CodeBuild

```sh
$ aws codebuild start-build --project-name container-build
```

There should be container images named `monorepo-app1` and `monorepo-app2` in the ECR.
