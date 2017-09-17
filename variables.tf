# API Gateway ID. e.g., ${var.aws_api_gateway_rest_api.<API>.id}
variable "rest_api_id" {}

# Resource ID, e.g., ${var.aws_api_gateway_resource.<RESOURCE>.id}
variable "resource_id" {}

# HTTP Method ID, e.g., ${var.aws_api_gateway_method.<METHOD>.id}
variable "http_method" {}

# Point to name of a lambda function attached to your account and region
variable "lambda_name" {}

# AWS Account ID
variable "account_id" {}

# AWS Region
variable "region" {}

# Velocity template used to capture params from request and send to lambda 
# more info: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
variable "integration_request_template" {
  default = "{}"
}

# Velocity template used to capture params sent to response from lambda (optional)
# more info: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html
variable "integration_response_template" {
  default = "#set($inputRoot = $input.path('$')){}"
}

# Request Parameters, A map of request query string parameters and headers that should be passed to the integration.
variable "request_parameters" {
  default = {}
}

# Name of model used for method request. e.g., `Empty`, `Error` or create a custom model and reference that by name
variable "request_model" {
  default = "Empty"
}

# Name of model used for method Response. e.g., `Empty`, `Error` or create a custom model and reference that by name
variable "response_model" {
  default = "Empty"
}

# Velocity template used to deliver errors to response. Assumes all responses uses the same error template.
variable "integration_error_template" {
  default = <<EOF
#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')) {
  "message" : "$errorMessageObj.message"
}
EOF
}

# Authorization used on request, e,g., "IAM_AM" | "NONE"
variable "authorization" {
  default = "NONE"
}
