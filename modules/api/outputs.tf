output "asg_api_endpoints" {
  description = "API Gateway endpoints to scale each ASG"
  value = {
    for asg in var.asg_names :
    asg => "https://${aws_api_gateway_rest_api.asg_api.id}.execute-api.${var.region}.amazonaws.com/prod/scale-${asg}"
  }
}

output "asg_api_url" {
  description = "Endpoint for the core api"
  value = "${aws_api_gateway_rest_api.asg_api.id}.execute-api.${var.region}.amazonaws.com"
}