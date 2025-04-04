module "design-prod-watchae-s3" {
  source        = "./modules/s3/modules/s3"
  account_id    = "433624884903"
  region        = "us-east-1"
  bucket        = "design-prod-watchae"
  force_destroy = true
  owner = {
    display_name = "devops"
  }
  lifecycle_rule = [{
    enabled = true
    filter = {
      prefix = ""
    }
    id = "tf-s3-lifecycle-20190125145614752800000001"
    noncurrent_version_transition = [{
      noncurrent_days = 7
      storage_class   = "GLACIER"
      storage_classs  = false
    }]
  }]
  logging = {
    target_bucket = "logs-s3-433624884903-us-east-1"
    target_prefix = "design-prod-watchae/"
  }
  request_payer   = "BucketOwner"
  attach_policies = true
  bucket_policies = file("./policies/design-prod-watchae.yaml")
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name                         = "design-prod-watchae"
    "Application ID"             = "AWS"
    Role                         = "infra"
    "aetn:dataConsumer"          = "fastly"
    "aetn:dataOrigin"            = "EC2"
    "aetn:env"                   = "prod"
    "aetn:hostnames"             = "design-prod-watchae"
    "aetn:s3securitytemplate"    = "webhosting-publishing-cf"
    "Line of Business - Primary" = "digital"
    env                          = "prod"
    Environment                  = "prod"
    group                        = "watch"
    Security                     = "internal"
    Automation                   = "terraform"
    hostnames                    = "design-prod-watchae"
  }
  versioning = {
    status = true
  }
}

//ultradns
resource "ultradns_record" "cname-cdn-design-watch-aetnd-com" {
  zone_name   = "aetnd.com"
  record_type = "CNAME"
  owner_name  = "cdn-design.watch.aetnd.com."
  record_data = [
    "http2.aenet.map.fastly.net.",
  ]
  ttl = 86400
}