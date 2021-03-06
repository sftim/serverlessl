resource "aws_lambda_function" "sign" {
  filename         = "../lambda/sign/deployment.zip"
  function_name    = "slsslSign-${var.ca_name}"
  role             = "${aws_iam_role.sign.arn}"
  handler          = "sign"
  source_code_hash = "${base64sha256(file("../lambda/sign/deployment.zip"))}"
  runtime          = "go1.x"

  environment {
    variables = {
      SLSSL_S3_BUCKET = "${aws_s3_bucket.private.bucket}"
      SLSSL_S3_PREFIX = "${var.ca_name}/"
    }
  }
}

resource "aws_lambda_function" "get_ca" {
  filename         = "../lambda/getCa/deployment.zip"
  function_name    = "slsslGetCa-${var.ca_name}"
  role             = "${aws_iam_role.get_ca.arn}"
  handler          = "get_ca"
  source_code_hash = "${base64sha256(file("../lambda/getCa/deployment.zip"))}"
  runtime          = "go1.x"

  environment {
    variables = {
      SLSSL_S3_BUCKET     = "${aws_s3_bucket.private.bucket}"
      SLSSL_S3_PREFIX     = "${var.ca_name}/"
      SLSSL_CA_COMMONNAME = "${var.ca_name}"
      SLSSL_CA_GROUP      = "${var.ca_name}"
      SLSSL_CA_COUNTRY    = "${var.ca_country}"
      SLSSL_CA_STATE      = "${var.ca_state}"
      SLSSL_CA_CITY       = "${var.ca_city}"
    }
  }
}
