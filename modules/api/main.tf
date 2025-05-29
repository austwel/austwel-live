resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_asg_api_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "asg_scaling_policy" {
  name = "asg_scaling_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:DescribeAutoScalingGroups"
        ],
        Resource = "*"
      }
    ]
  })
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/scale_asg.py"
  output_path = "${path.module}/lambda/scale_asg.zip"
}

resource "aws_lambda_function" "scale_asg" {
  for_each      = toset(var.asg_names)

  function_name = "scale-${each.key}"
  handler       = "scale_asg.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      ASG_NAME = each.key
    }
  }
}

resource "aws_api_gateway_rest_api" "asg_api" {
  name        = "asg-api"
  description = "API to toggle ASG capacity"
}

resource "aws_api_gateway_resource" "scale_resource" {
  for_each    = toset(var.asg_names)
  rest_api_id = aws_api_gateway_rest_api.asg_api.id
  parent_id   = aws_api_gateway_rest_api.asg_api.root_resource_id
  path_part   = "scale-${each.key}"
}

resource "aws_api_gateway_method" "post_method" {
  for_each      = aws_api_gateway_resource.scale_resource
  rest_api_id   = aws_api_gateway_rest_api.asg_api.id
  resource_id   = each.value.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  for_each    = aws_api_gateway_resource.scale_resource

  rest_api_id = aws_api_gateway_rest_api.asg_api.id
  resource_id = each.value.id
  http_method = aws_api_gateway_method.post_method[each.key].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.scale_asg[each.key].invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  for_each      = aws_lambda_function.scale_asg

  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.asg_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.asg_api.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage_prod" {
  stage_name = "prod"
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id = aws_api_gateway_rest_api.asg_api.id
}