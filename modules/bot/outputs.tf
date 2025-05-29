output "discord_webhook_url" {
  value = aws_apigatewayv2_api.discord.api_endpoint
}