variable "region" {
  default = "us-east-2"
}

variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "profile" {
  default = "default"
}

variable "env" {
  default = "dev"
}

variable "s3_glow_front_bucket_name" {
  default = {
    dev  = "testdevglowfrontbucketname"
    stg  = "teststgglowfrontbucketname"
    prod = "testprodglowfrontbucketname"
  }
}

variable "s3_glow_front_bucket_origin_id" {
  default = {
    dev  = "testdevglowfrontbucketoriginid"
    stg  = "teststgglowfrontbucketoriginid"
    prod = "testprodglowfrontbucketoriginid"
  }
}


# variable "s3_glow_front_bucket_name_dev" {
#   default = "testdevglowfrontbucketname"
# }

# variable "s3_glow_front_bucket_name_stg" {
#   default = "teststgglowfrontbucketname"
# }

# variable "s3_glow_front_bucket_name_prod" {
#   default = "testprodglowfrontbucketname"
# }

# variable "s3_glow_front_bucket_origin_id_dev" {
#   default = "testdevglowfrontbucketoriginid"
# }

# variable "s3_glow_front_bucket_origin_id_stg" {
#   default = "teststgglowfrontbucketoriginid"
# }

# variable "s3_glow_front_bucket_origin_id_prod" {
#   default = "testprodglowfrontbucketoriginid"
# }
