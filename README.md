# Terraform API Gateway Method Module

Terraform module for creating a serverless architecture in API Gateway. This module can be used to resource methods attached to your API Gateway resources to call lambda functions with a few variables exposed see [variables.tf](https://github.com/carrot//terraform-api-gateway-method-module/blob/master/variables.tf).

## Caveats

This module makes a few assumptions for simplicity:

1. You are resourcing API gateway to be used to access Lambda functions as part of a serverless API.
2. Your requests/responses are all in JSON
3. You only require one error response template across your entire API Gateway instance.

## Example Useage
```

# Create an API Gateway REST API

resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  name        = "MyDemoAPI"
  description = "This is my API for demonstration purposes"
}

# Create a resource

resource "aws_api_gateway_resource" "users" {
  rest_api_id = "${aws_api_gateway_rest_api.MyDemoAPI.id}"
  parent_id = "${aws_api_gateway_rest_api.MyDemoAPI.root_resource_id}"
  path_part = "users"
}

# Call the module to attach a method along with its request/response/integration templates
# This one creates a user.

module "UsersPost" {
  source  = "github.com/carrot/terraform-api-gateway-method-module"
  rest_api_id = "${aws_api_gateway_rest_api.<API_NAME>.id}"
  resource_id = "${aws_api_gateway_resource.users.id}"
  http_method = "POST"
  lambda_name = "create_user_lambda_funciton"
  account_id = "1234567890"
  region = "us-east-1"
  integration_request_template = "#set($inputRoot = $input.path('$')){}"
  request_model = "Empty"
  integration_response_template = "#set($inputRoot = $input.path('$')){}"
  response_model = "Empty"
  integration_error_template = "#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')) {\"message\" :\"$errorMessageObj.message\"}"
  authorization = "AWS_IAM"
}
```

Need CORS enabled? check out [https://github.com/carrot/terraform-api-gateway-cors-module](https://github.com/carrot/terraform-api-gateway-cors-module)

## More info
[Terraform - API Gateway](https://www.terraform.io/docs/providers/aws/r/api_gateway_rest_api.html)



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account_id | AWS Account ID | string | - | yes |
| authorization | Authorization used on request, e,g., "IAM_AM" | "NONE" | string | `NONE` | no |
| http_method | HTTP Method ID, e.g., ${var.aws_api_gateway_method.<METHOD>.id} | string | - | yes |
| integration_error_template | Velocity template used to deliver errors to response. Assumes all responses uses the same error template. | string | `#set ($errorMessageObj = $util.parseJson($input.path('$.errorMessage')) {   "message" : "$errorMessageObj.message" } ` | no |
| integration_request_template | Velocity template used to capture params from request and send to lambda more info: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html | string | `{}` | no |
| integration_response_template | Velocity template used to capture params sent to response from lambda (optional) more info: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html | string | `#set($inputRoot = $input.path('$')){}` | no |
| lambda_name | Point to name of a lambda function attached to your account and region | string | - | yes |
| region | AWS Region | string | - | yes |
| request_model | Name of model used for method request. e.g., `Empty`, `Error` or create a custom model and reference that by name | string | `Empty` | no |
| request_parameters | Request Parameters, A map of request query string parameters and headers that should be passed to the integration. | string | `<map>` | no |
| resource_id | Resource ID, e.g., ${var.aws_api_gateway_resource.<RESOURCE>.id} | string | - | yes |
| response_model | Name of model used for method Response. e.g., `Empty`, `Error` or create a custom model and reference that by name | string | `Empty` | no |
| rest_api_id | API Gateway ID. e.g., ${var.aws_api_gateway_rest_api.<API>.id} | string | - | yes |

