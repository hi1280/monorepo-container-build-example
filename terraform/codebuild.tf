resource "aws_iam_role" "container_build" {
  name               = "container-build"
  assume_role_policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOS
}

resource "aws_iam_role_policy" "container_build" {
  role   = aws_iam_role.container_build.name
  policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ecr:*",
        "ssm:GetParameters"
      ]
    }
  ]
}
EOS
}


resource "aws_codebuild_project" "container_build" {
  name = "container-build"
  artifacts {
    type = "NO_ARTIFACTS"
  }
  cache {
    modes = [
      "LOCAL_DOCKER_LAYER_CACHE",
    ]
    type = "LOCAL"
  }
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    privileged_mode = true
    type            = "LINUX_CONTAINER"

  }
  source {
    type            = "GITHUB"
    location        = "https://github.com/hi1280/monorepo-container-build-example.git"
    git_clone_depth = 1
  }
  service_role  = aws_iam_role.container_build.arn
  build_timeout = 30
}

resource "aws_codebuild_webhook" "container_build" {
  project_name = aws_codebuild_project.container_build.name

  filter_group {
    filter {
      exclude_matched_pattern = false
      pattern                 = "PUSH, PULL_REQUEST_MERGED"
      type                    = "EVENT"
    }
    filter {
      exclude_matched_pattern = false
      pattern                 = "refs/heads/master"
      type                    = "HEAD_REF"
    }
  }
}