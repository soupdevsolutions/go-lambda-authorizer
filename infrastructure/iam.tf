# LOGIN LAMBDA ROLE/POLICIES
resource "aws_iam_role" "login" {
  assume_role_policy = data.aws_iam_policy_document.login_assume_policy.json
}

data "aws_iam_policy_document" "login_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "login_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*"
    ]
  }
}

resource "aws_iam_policy" "login_policy" {
  name   = "login_policy"
  policy = data.aws_iam_policy_document.login_policy_document.json
}

resource "aws_iam_role_policy_attachment" "login_policy_attachment" {
  role       = aws_iam_role.login.name
  policy_arn = aws_iam_policy.login_policy.arn
}

# AUTHORIZER LAMBDA ROLE/POLICIES
resource "aws_iam_role" "authorizer" {
  assume_role_policy = data.aws_iam_policy_document.authorizer_assume_policy.json
}

data "aws_iam_policy_document" "authorizer_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "authorizer_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*"
    ]
  }
}

resource "aws_iam_policy" "authorizer_policy" {
  name   = "authorizer_policy"
  policy = data.aws_iam_policy_document.authorizer_policy_document.json
}

resource "aws_iam_role_policy_attachment" "authorizer_policy_attachment" {
  role       = aws_iam_role.authorizer.name
  policy_arn = aws_iam_policy.authorizer_policy.arn
}