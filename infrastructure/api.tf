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
  deployment_id = aws_apigatewayv2_deployment.api_deployment.id
}

resource "aws_apigatewayv2_deployment" "api_deployment" {
  api_id      = aws_apigatewayv2_api.api.id
  description = "Auth API deployment"

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(
      jsonencode([
        file("api_gateway.tf"),
      ])
    )
  }
}

# AUTHORIZER
resource "aws_apigatewayv2_authorizer" "authorizer" {
  api_id           = aws_apigatewayv2_api.api.id
  authorizer_type  = "REQUEST"
  authorizer_uri   = aws_lambda_function.authorizer_lambda.invoke_arn
  identity_sources = ["route.request.header.Auth"]
  name             = "authorizer"
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
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /login"
  target    = "integrations/${aws_apigatewayv2_integration.login_integration.id}"
}

resource "aws_lambda_permission" "apigateway_lambda_permission" {
  function_name = aws_lambda_function.login_lambda.arn
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
