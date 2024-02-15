# GENERIC RESOURCES
resource "aws_apigatewayv2_api" "api" {
  name          = "Auth API"
  description   = "Auth API"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id        = aws_apigatewayv2_api.api.id
  name          = "$default"
  auto_deploy   = true
}

# AUTHORIZER
resource "aws_apigatewayv2_authorizer" "authorizer" {
  api_id                            = aws_apigatewayv2_api.api.id
  authorizer_type                   = "REQUEST"
  authorizer_uri                    = aws_lambda_function.authorizer_lambda.invoke_arn
  identity_sources                  = ["$request.header.Authorization"]
  name                              = "authorizer"
  authorizer_payload_format_version = "2.0"
  enable_simple_responses = true
}

resource "aws_lambda_permission" "authorizer_lambda_permission" {
  function_name = aws_lambda_function.authorizer_lambda.arn
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# LOGIN
resource "aws_apigatewayv2_integration" "login_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  description        = "Login"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.login_lambda.invoke_arn

  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "login_route" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "POST /login"
  target             = "integrations/${aws_apigatewayv2_integration.login_integration.id}"
  authorization_type = "NONE"
}

resource "aws_lambda_permission" "login_lambda_permission" {
  function_name = aws_lambda_function.login_lambda.arn
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# GET DATA
resource "aws_apigatewayv2_integration" "get_data_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  description        = "Get Data"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.get_data_lambda.invoke_arn

  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "get_data_route" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "GET /data"
  target             = "integrations/${aws_apigatewayv2_integration.get_data_integration.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.authorizer.id
}

resource "aws_lambda_permission" "get_data__lambda_permission" {
  function_name = aws_lambda_function.get_data_lambda.arn
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
