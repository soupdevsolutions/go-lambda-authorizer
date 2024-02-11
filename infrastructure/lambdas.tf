# LOGIN
resource "aws_lambda_function" "login_lambda" {
  function_name = "Login"

  filename         = "data/lambdas/login.zip"
  source_code_hash = filebase64sha256("data/lambdas/login.zip")

  handler = "handler"
  runtime = "provided.al2"

  role = aws_iam_role.login.arn
}

# AUTHORIZER
resource "aws_lambda_function" "authorizer_lambda" {
  function_name = "Authorizer"

  filename         = "data/lambdas/authorizer.zip"
  source_code_hash = filebase64sha256("data/lambdas/authorizer.zip")

  handler = "handler"
  runtime = "provided.al2"

  role = aws_iam_role.authorizer.arn
}
