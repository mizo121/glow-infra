output "public_ip" {
  value = "${aws_cloudfront_distribution.frontend_cloudfront_distribution_test.domain_name}"
}
