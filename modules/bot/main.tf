resource "aws_iam_role" "lambda_exec" {
  name = "asg_status_updater_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "asg_permissions" {
  name = "asg_describe"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ec2:DescribeInstances",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:SetDesiredCapacity"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "basic_exec" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

data "archive_file" "python_zip" {
  type        = "zip"
  source_dir = "${path.module}/python"
  output_path = "${path.module}/python.zip"
}

resource "aws_lambda_layer_version" "layer" {
  layer_name = "requirements_lambda_layerz"
  filename = "${path.module}/python.zip"
  compatible_architectures = ["x86_64"]
  compatible_runtimes = ["python3.10"]
}

resource "aws_lambda_function" "asg_status_updater" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "asg_status_updater"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "update.lambda_handler"
  runtime          = var.runtime
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 10

  environment {
    variables = {
      ASG_NAME        = var.asg_name
      ASG_HUMAN_NAME  = var.asg_human_name
      BOT_TOKEN       = var.bot_token
      CHANNEL_ID      = var.channel_id
      MESSAGE_ID      = var.message_id
      DISCORD_PUBLIC_KEY = var.discord_public_key
      HOST_NAME       = var.host_name
    }
  }
}

resource "aws_lambda_function" "discord_buttons" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "discord_buttons"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "buttons.lambda_handler"
  runtime          = var.runtime
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  layers           = [aws_lambda_layer_version.layer.arn]
  timeout          = 10

  environment {
    variables = {
      ASG_NAME        = var.asg_name
      ASG_HUMAN_NAME  = var.asg_human_name
      BOT_TOKEN       = var.bot_token
      CHANNEL_ID      = var.channel_id
      MESSAGE_ID      = var.message_id
      DISCORD_PUBLIC_KEY = var.discord_public_key
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_minute" {
  name                = "run_every_minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_minute.name
  target_id = "asg_updater"
  arn       = aws_lambda_function.asg_status_updater.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asg_status_updater.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_minute.arn
}

resource "aws_apigatewayv2_api" "discord" {
  name          = "discord_interaction_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.discord.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.discord_buttons.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "discord" {
  api_id    = aws_apigatewayv2_api.discord.id
  route_key = "POST /interactions"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.discord.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "allow_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.discord_buttons.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.discord.execution_arn}/*/*"
}
