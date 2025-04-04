resource "datadog_synthetics_test" "dev-watch-cropper-synthetics-5zpw4xaex" {
  assertion {
    operator = "is"
    target   = "200"
    type     = "statusCode"
  }

  assertion {
    operator = "lessThan"
    target   = "5000"
    type     = "responseTime"
  }

  locations = ["aws:us-east-1"]
  message   = "@pagerduty-${datadog_integration_pagerduty_service_object.dev-watch-cropper-service.service_name}"
  name      = "dev-cropper.watch.aetnd.com/cdn.watch.aetnd.com/sites/3/2016/12/watch-nicole-and-jionnis-shore-flip-logo.jpg?w=500"

  options_list {
    accept_self_signed              = "false"
    allow_insecure                  = "false"
    check_certificate_revocation    = "false"
    disable_cors                    = "false"
    disable_csp                     = "false"
    follow_redirects                = "false"
    ignore_server_certificate_error = "false"
    initial_navigation_timeout      = "0"
    min_failure_duration            = "3600"
    min_location_failed             = "1"

    monitor_options {
      renotify_interval = "0"
    }

    retry {
      count    = "1"
      interval = "1000"
    }

    tick_every = "3600"
  }

  request_definition {
    method                  = "GET"
    no_saving_response_body = "false"
    number_of_packets       = "0"
    should_track_hops       = "false"
    timeout                 = "0"
    url                     = "https://dev-cropper.watch.aetnd.com/cdn.watch.aetnd.com/sites/3/2016/12/watch-nicole-and-jionnis-shore-flip-logo.jpg?w=500"
  }

  request_headers = {
    app-token = "origin-a98162f2ee9f668a17b9e82eae5adb5b4f850a3e"
  }

  status  = "live"
  subtype = "http"
  tags    = ["dev_aetn-watch-cropper_cropper-watch-aetnd-com", "team:backend-services", "watch", "terraform"]
  type    = "api"
}

resource "datadog_synthetics_test" "dev-watch-cropper-synthetics-tmwmjezhr" {
  assertion {
    operator = "is"
    target   = "200"
    type     = "statusCode"
  }

  assertion {
    operator = "lessThan"
    target   = "5000"
    type     = "responseTime"
  }

  locations = ["aws:us-east-1"]
  message   = "@pagerduty-${datadog_integration_pagerduty_service_object.dev-watch-cropper-service.service_name}"
  name      = "origin: dev-cropper.watch.aetnd.com/cdn.watch.aetnd.com/sites/3/2016/12/watch-nicole-and-jionnis-shore-flip-logo.jpg?w=500"

  options_list {
    accept_self_signed              = "false"
    allow_insecure                  = "false"
    check_certificate_revocation    = "false"
    disable_cors                    = "false"
    disable_csp                     = "false"
    follow_redirects                = "false"
    ignore_server_certificate_error = "false"
    initial_navigation_timeout      = "0"
    min_failure_duration            = "3600"
    min_location_failed             = "1"

    monitor_options {
      renotify_interval = "0"
    }

    retry {
      count    = "1"
      interval = "1000"
    }

    tick_every = "3600"
  }

  request_definition {
    method                  = "GET"
    no_saving_response_body = "false"
    number_of_packets       = "0"
    should_track_hops       = "false"
    timeout                 = "0"
    url                     = "https://dev-cropper.watch.aetnd.com/cdn.watch.aetnd.com/sites/3/2016/12/watch-nicole-and-jionnis-shore-flip-logo.jpg?w=500"
  }

  request_headers = {
    origin-token = "origin-a98162f2ee9f668a17b9e82eae5adb5b4f850a3e"
  }

  status  = "live"
  subtype = "http"
  tags    = ["dev_aetn-watch-cropper_cropper-watch-aetnd-com", "push-v2", "team:backend-services", "watch", "terraform"]
  type    = "api"
}
