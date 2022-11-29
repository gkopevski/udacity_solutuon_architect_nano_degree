# TODO: Define the variable for aws_region
variable "aws_region" {
  description = "AWS Region"
  default = "us-east-1"
}

variable "function_name" {
  default = "greetlambda"
}

variable "lambda_handler" {
  default = "greet_lambda.lambda_handler"
}

variable "python_version" {
  default = "python3.9"
}

variable "code_lambda" {
  default = "greet_lambda.zip"
}

