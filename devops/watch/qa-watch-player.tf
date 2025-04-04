resource "ultradns_record" "cname-qa-player-watch-aetnd-com" {
  zone_name   = "aetnd.com"
  record_type = "CNAME"
  owner_name  = "qa-player.watch.aetnd.com."
  record_data = [
    "http2.aenet.map.fastly.net.",
  ]
  ttl = 86400
}

resource "ultradns_record" "cname-qa-player-aetv-com" {
  zone_name   = "aetv.com"
  record_type = "CNAME"
  owner_name  = "qa-player.aetv.com."
  record_data = [
    "http2.aenet.map.fastly.net.",
  ]
  ttl = 86400
}

resource "ultradns_record" "cname-qa-player-fyi-tv" {
  zone_name   = "fyi.tv"
  record_type = "CNAME"
  owner_name  = "qa-player.fyi.tv."
  record_data = [
    "http2.aenet.map.fastly.net.",
  ]
  ttl = 86400
}

resource "ultradns_record" "cname-qa-player-history-com" {
  zone_name   = "history.com"
  record_type = "CNAME"
  owner_name  = "qa-player.history.com."
  record_data = [
    "http2.aenet.map.fastly.net.",
  ]
  ttl = 86400
}

resource "ultradns_record" "cname-qa-player-mylifetime-com" {
  zone_name   = "mylifetime.com"
  record_type = "CNAME"
  owner_name  = "qa-player.mylifetime.com."
  record_data = [
    "http2.aenet.map.fastly.net.",
  ]
  ttl = 86400
}

resource "pagerduty_escalation_policy" "qa-watch-player-escalation-policy" {
  name      = "qa-watch-player-escalation-policy"
  num_loops = 3
  rule {
    escalation_delay_in_minutes = 15
    target {
      id   = data.pagerduty_user.default-user.id
      type = "user_reference"
    }
  }
  lifecycle {
    ignore_changes = [
      num_loops, rule, teams,
    ]
  }
}

resource "pagerduty_service" "qa-watch-player-service" {
  name              = "qa-watch-player-service"
  escalation_policy = pagerduty_escalation_policy.qa-watch-player-escalation-policy.id
  alert_creation    = "create_alerts_and_incidents"
  incident_urgency_rule {
    type    = "constant"
    urgency = "low"
  }
  lifecycle {
    ignore_changes = [
      acknowledgement_timeout, alert_grouping_parameters,
      auto_pause_notifications_parameters, auto_resolve_timeout, response_play,
      incident_urgency_rule, scheduled_actions, support_hours
    ]
  }
}

resource "pagerduty_service_integration" "qa-watch-player-integration-cloudwatch" {
  name    = data.pagerduty_vendor.cloudwatch.name
  vendor  = data.pagerduty_vendor.cloudwatch.id
  service = pagerduty_service.qa-watch-player-service.id
}

resource "pagerduty_service_integration" "qa-watch-player-integration-datadog" {
  name    = pagerduty_service.qa-watch-player-service.name
  service = pagerduty_service.qa-watch-player-service.id
  vendor  = data.pagerduty_vendor.datadog.id
}

resource "datadog_integration_pagerduty_service_object" "qa-watch-player-service" {
  # when creating the integration object for the first time, the service
  # objects have to be created *after* the integration
  depends_on   = [datadog_integration_pagerduty.pagerduty]
  service_name = pagerduty_service.qa-watch-player-service.name
  service_key  = pagerduty_service_integration.qa-watch-player-integration-datadog.integration_key
}

resource "aws_cloudformation_stack" "qa-watch-player-alert" {
  provider          = aws.us-east-1
  name              = "qa-watch-player-alert"
  capabilities      = ["CAPABILITY_IAM"]
  disable_rollback  = false
  notification_arns = []
  template_body     = file("${path.module}/templates/alert.yaml")
  parameters = {
    Email         = null
    HttpEndpoint  = null
    HttpsEndpoint = "https://events.pagerduty.com/integration/${pagerduty_service_integration.qa-watch-player-integration-cloudwatch.integration_key}/enqueue"
    FallbackEmail = "DevSecOps@aenetworks.com"
  }
  tags = {
    Name                         = "qa-watch-player-alert"
    "Application ID"             = "AWS"
    Role                         = "infra"
    "aetnd:application"          = "watch-player"
    "aetnd:env"                  = "qa"
    "Line of Business - Primary" = "digital"
    env                          = "qa"
    Environment                  = "qa"
    group                        = "watch"
    Security                     = "internal"
    Automation                   = "terraform"
  }
}

resource "aws_cloudformation_stack" "qa-watch-player-iam" {
  provider          = aws.us-east-1
  name              = "qa-watch-player-iam"
  capabilities      = ["CAPABILITY_IAM"]
  disable_rollback  = false
  notification_arns = []
  template_body     = file("${path.module}/templates/iam-watch-player.yaml")
  parameters = {
    Environment = "qa"
  }
  tags = {
    Name                         = "qa-watch-player-iam"
    "Application ID"             = "AWS"
    Role                         = "infra"
    "aetnd:application"          = "watch-player"
    "aetnd:env"                  = "qa"
    "Line of Business - Primary" = "digital"
    env                          = "qa"
    Environment                  = "qa"
    group                        = "watch"
    Security                     = "internal"
    Automation                   = "terraform"
  }
}

resource "aws_cloudformation_stack" "qa-watch-player-pipeline" {
  provider          = aws.us-east-1
  name              = "qa-watch-player-pipeline"
  capabilities      = ["CAPABILITY_IAM"]
  disable_rollback  = false
  notification_arns = []
  template_body     = file("${path.module}/templates/devops-code-pipeline.yaml")
  parameters = {
    ParentS3ArtifactBucketStack = "s3-artifacts-codebuild"
    ParentAlertStack            = null
    ParentVPCStack              = null
    ParentClientStack1          = null
    ParentClientStack2          = null
    ParentClientStack3          = null
    SubnetsReach                = "Private"
    CodeCommitRepo              = null
    CodeCommitBranch            = "master"
    GitHubConnectionArn         = "arn:aws:codestar-connections:us-east-1:433624884903:connection/b2a3e0ae-1341-4371-bcf3-31fddfd4e1f7"
    GitHubOwner                 = "aenetworks"
    GitHubRepo                  = "aetn.watch.player"
    GitHubBranch                = "master"
    SourceBucketName            = null
    SourceObjectKey             = null
    ValidationFunction1         = null
    ValidationFunction2         = null
    ValidationFunction3         = null
    CodeBuildServicePolicies    = aws_cloudformation_stack.qa-watch-player-iam.outputs.PolicyArn
    CodeBuildEnvironment1Key    = "PUSH_TOKEN"
    CodeBuildEnvironment1Type   = "SECRETS_MANAGER"
    CodeBuildEnvironment1Value  = "/codebuild/github/push_token_qa"
    CodeBuildEnvironment2Key    = "AETN_ENV"
    CodeBuildEnvironment2Type   = "PLAINTEXT"
    CodeBuildEnvironment2Value  = "qa"
    CodeBuildEnvironment3Key    = null
    CodeBuildEnvironment3Type   = "PLAINTEXT"
    CodeBuildEnvironment3Value  = null
    CodeBuildEnvironment        = "LINUX_CONTAINER"
    CodeBuildImageName          = "aws/codebuild/standard:7.0"
    CodeBuildComputeType        = "BUILD_GENERAL1_SMALL"
    CodeBuildBuildSpec          = "buildspec.yaml"
    CodeBuildTimeoutInMinutes   = "60"
    LogsRetentionInDays         = "1"
  }
  tags = {
    Name                         = "qa-watch-player-pipeline"
    "Application ID"             = "AWS"
    Role                         = "infra"
    "aetnd:application"          = "watch-player"
    "aetnd:env"                  = "qa"
    "Line of Business - Primary" = "digital"
    env                          = "qa"
    Environment                  = "qa"
    group                        = "watch"
    Security                     = "internal"
    Automation                   = "terraform"
  }
}
