output "lambda_function_name" {
  value = aws_lambda_function.asg_webhook_lambda.function_name
}

output "sns_topic_arn" {
  value = aws_sns_topic.asg_notifications.arn
}