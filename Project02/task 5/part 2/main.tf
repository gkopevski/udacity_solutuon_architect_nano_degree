# Resources used:
#     https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
#     https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/archive_file

provider "aws" {
  profile = "udacity"
  region  = var.aws_region
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
  {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  }
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = "greet_lambda.zip"
}

resource "aws_lambda_function" "greet_lambda" {
  function_name = var.function_name
  filename      = var.code_lambda
  handler       = var.lambda_handler
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = var.python_version
  source_code_hash = data.archive_file.lambda_archive.output_base64sha256
  environment {
    variables = {
      greeting = "Hello world Udacity"
    }
  }
  depends_on = [aws_iam_role_policy_attachment.lambda_logs]
}
