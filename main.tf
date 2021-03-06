terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mizo"

    workspaces {
      prefix = "my-app-"
    }
  }
}

provider "aws" {
  region      = "us-west-2"
  max_retries = 1
}
locals {
  bucket_name      = "${lookup(var.s3_glow_front_bucket_name, var.env)}"
  bucket_origin_id = "${lookup(var.s3_glow_front_bucket_origin_id, var.env)}"
  test             = "test"
}

## s3 bucket resource for frontend deployment

resource "aws_s3_bucket" "s3_bucket" {

  bucket = local.bucket_name
  acl    = "public-read"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"AddPerm",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${local.bucket_name}/*"]
  }]
}
POLICY
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

## cloudfront distribution resource

resource "aws_cloudfront_distribution" "frontend_cloudfront_distribution_test" {

  origin {
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    domain_name = aws_s3_bucket.s3_bucket.website_endpoint
    origin_id   = local.bucket_origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "allow-all"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.bucket_origin_id
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

## IAM user for circle ci react deployment

resource "aws_iam_user" "circleci_react" {
  name = "circleci_react"
}

data "aws_iam_policy_document" "policy_data" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [aws_s3_bucket.s3_bucket.arn]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "circleci-for-react"
  policy = data.aws_iam_policy_document.policy_data.json
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.circleci_react.name
  policy_arn = aws_iam_policy.policy.arn
}

