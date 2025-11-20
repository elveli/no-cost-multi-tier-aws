# -----------------------------
# Generate Lambda zip from embedded Python (proper API Gateway response)
# -----------------------------
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/no-cost-dummy_lambda.zip"

  source {
    filename = "lambda_function.py"
    content  = <<-EOF
      import json

      def handler(event, context):
          return {
              "statusCode": 200,
              "body": json.dumps("Hello from no-cost Lambda!")
          }
    EOF
  }
}


# -----------------------------
# IAM Role for Lambda Execution
# -----------------------------
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# -----------------------------
# Lambda Function
# -----------------------------
resource "aws_lambda_function" "no-cost-dummy_lambda" {
  function_name = "no-cost-dummy-lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.handler"
  runtime       = "python3.11"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = var.common_tags
}

# -----------------------------
# API Gateway
# -----------------------------
resource "aws_api_gateway_rest_api" "no-cost-dummy_api" {
  name        = "no-cost-dummy-api"
  description = "Zero-cost API Gateway for Lambda testing"
  tags        = var.common_tags
}

# Root resource
resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.no-cost-dummy_api.id
  parent_id   = aws_api_gateway_rest_api.no-cost-dummy_api.root_resource_id
  path_part   = "test"
}

# GET method
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.no-cost-dummy_api.id
  resource_id   = aws_api_gateway_resource.root_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integration with Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.no-cost-dummy_api.id
  resource_id             = aws_api_gateway_resource.root_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  #uri                     = aws_lambda_function.no-cost-dummy_lambda.invoke_arn
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.no-cost-dummy_lambda.arn}/invocations"

}

resource "aws_lambda_permission" "api_gw_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.no-cost-dummy_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.no-cost-dummy_api.execution_arn}/*/*"
}


# Deploy API (deployment itself)
resource "aws_api_gateway_deployment" "api_deploy" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.no-cost-dummy_api.id

  triggers = {
    redeploy = sha1(jsonencode(aws_api_gateway_rest_api.no-cost-dummy_api))
  }
}

# Create Stage separately
resource "aws_api_gateway_stage" "dev" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.no-cost-dummy_api.id
  deployment_id = aws_api_gateway_deployment.api_deploy.id
}