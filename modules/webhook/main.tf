resource "aws_iam_role" "lambda_exec_role" {
  name = "asg_lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "asg_webhook_lambda" {
  function_name = "asg-webhook-listener"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = 10

  environment {
    variables = {
      WEBHOOK_URL  = var.webhook_url
    }
  }
}

resource "aws_sns_topic" "asg_notifications" {
  name = "asg-events-topic"
}

resource "aws_autoscaling_notification" "asg_notify" {
  group_names = var.asg_names

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]

  topic_arn = aws_sns_topic.asg_notifications.arn
}

resource "aws_sns_topic_subscription" "lambda_sub" {
  topic_arn = aws_sns_topic.asg_notifications.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.asg_webhook_lambda.arn
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asg_webhook_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.asg_notifications.arn
}
