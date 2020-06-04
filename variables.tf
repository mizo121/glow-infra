variable "s3_glow_front_bucket_name" {
  default = {
    dev        = "test-dev-glow-front-bucket"
    staging    = "test-stg-glow-front-bucket"
    production = "test-prod-glow-front-bucket"
  }
}

variable "s3_glow_front_bucket_origin_id" {
  default = {
    dev        = "test-dev-glow-front-bucket-originid"
    staging    = "test-stg-glow-front-bucket-originid"
    production = "test-prod-glow-front-bucket-originid"
  }
}
