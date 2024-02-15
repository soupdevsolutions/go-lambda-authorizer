# LOGIN
resource "aws_lambda_function" "login_lambda" {
  function_name = "Login"

  filename         = "data/lambdas/login.zip"
  source_code_hash = filebase64sha256("data/lambdas/login.zip")

  handler = "Handle"
  runtime = "provided.al2"

  role = aws_iam_role.login.arn
}

# GET DATA
resource "aws_lambda_function" "get_data_lambda" {
  function_name = "GetData"

  filename         = "data/lambdas/get_data.zip"
  source_code_hash = filebase64sha256("data/lambdas/get_data.zip")

  handler = "Handle"
  runtime = "provided.al2"

  role = aws_iam_role.get_data.arn
}

# AUTHORIZER
resource "aws_lambda_function" "authorizer_lambda" {
  function_name = "Authorizer"

  filename         = "data/lambdas/authorizer.zip"
  source_code_hash = filebase64sha256("data/lambdas/authorizer.zip")

  handler = "Handle"
  runtime = "provided.al2"

  role = aws_iam_role.authorizer.arn
}
