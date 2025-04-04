module "qa-www-aecrimecentral-com-fastly" {
  source = "./modules/fastly/vcl_service"

  service_name = "qa.aecrimecentral.com"

  domains = [
    "qa.aecrimecentral.com"
  ]

  default_s3_logging = {}

  backends = {
    svodroadblock_web_aetnd_com = {
      address     = "qa-web-ingress.aetnd.io"
      share_key   = "eQIILoA8gBTP1rSgrLxXf804"
      healthcheck = "svodroadblock-HC"
    }
    webcenter_web_aetnd_com = {
      # address     = "qa-web-webcenter-ingress.aetnd.io"
      address     = "qa-web-webcenter-ingress.enbe6dnfq3zkdriy-us-west-2.aetnd.io"
      share_key   = "NQ3oqOFHLkN5siVsLbPhuy6m"
      healthcheck = "webcenter-HC"
    }
    webpay_commerce_aetnd_com = {
      address     = "qa-commerce-ingress.aetnd.io"
      share_key   = "ZztAU6PkYsjSzbLPJm6qbz7W"
      healthcheck = "webpay-HC"
    }
  }

  healthchecks = {
    "svodroadblock-HC" = {
      host = "qa-svodroadblock.web.aetnd.com"
    }
    "webcenter-HC" = {
      host = "qa-webcenter.web.aetnd.com"
    }
    "webpay-HC" = {
      host = "qa-webpay.commerce.aetnd.com"
    }
  }

  snippets = {
    aetn_check_shield_recv            = { type = "init", priority = 10 }
    aetn_stale_deliver                = { type = "init", priority = 15 }
    aetn_stale_fetch                  = { type = "init", priority = 15 }
    aetn_cache_fetch                  = { type = "init", priority = 20 }
    aetn_error                        = { type = "init", priority = 20 }
    aetn_shield                       = { type = "init", priority = 20 }
    aetn_debug_fetch                  = { type = "init", priority = 21 }
    aetn_set_env_recv                 = { type = "init", priority = 25 }
    aetn_stale_error                  = { type = "init", priority = 25 }
    aetn_device_recv                  = { type = "init", priority = 30 }
    aetn_gzip_fetch                   = { type = "init", priority = 30 }
    aetn_geo_recv                     = { type = "init", priority = 35 }
    aetn_deliver                      = { type = "init", priority = 50 }
    aetn_monitoring_check_recv        = { type = "init", priority = 55 }
    aetn_token_auth                   = { type = "init", priority = 60 }
    aetn_corp_ip                      = { type = "init", priority = 100 }
    eu_whitelist_ip                   = { type = "init", priority = 100 }
    aetn_404_s3_fetch                 = { type = "init", priority = 100 }
    aetn_acl                          = { type = "init", priority = 100 }
    aetn_geoblock_europe              = { type = "init", priority = 100 }
    aetn_geoblock_usacanada           = { type = "init", priority = 100 }
    aetn_geoblock_usa                 = { type = "init", priority = 100 }
    aetn_https_rewrite                = { type = "init", priority = 100 }
    aetn_service_cache_fetch          = { type = "init", priority = 100 }
    aetn_sign_s3                      = { type = "init", priority = 100 }
    fastly_devicedetect               = { type = "init", priority = 100 }
    logs-kibana                       = { type = "init", priority = 100 }
    eu_whitelist_useragents           = { type = "init", priority = 100 }
    aetn_eu_redirects                 = { type = "init", priority = 100 }
    aetn_service_eu_redirects         = { type = "init", priority = 100 }
    aetn_assets_proxypass             = { type = "init", priority = 100 }
    aetn_player_proxypass             = { type = "init", priority = 100 }
    backend_qa_assets_watch_aetnd_com = { type = "init", priority = 100 }
    backend_qa_player_watch_aetnd_com = { type = "init", priority = 100 }
    aetn_default_backend              = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aecrimecentral-com/aetn_default_backend.vcl") }
    aetn_service_cache_fetch          = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aecrimecentral-com/aetn_service_cache_fetch.vcl") }
    aetn_service_eu_redirects         = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aecrimecentral-com/aetn_service_eu_redirects.vcl") }
    aetn_services_proxypass           = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aecrimecentral-com/aetn_services_proxypass.vcl") }
    aetn_services_recv                = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aecrimecentral-com/aetn_services_recv.vcl") }
    aetn_services_rewrites            = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aecrimecentral-com/aetn_services_rewrites.vcl") }
    aetn_webpay_proxypass             = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aecrimecentral-com/aetn_webpay_proxypass.vcl") }
    redirects                         = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aecrimecentral-com/redirects.vcl") }
    vcl_error                         = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aecrimecentral-com/vcl_error.vcl") }
  }

  vcls = {
    main = {
      main    = true
      content = file("${path.module}/fastly/www-aecrimecentral-com/default_sigsci.vcl")
    }
  }

  use_common_snippets         = false
  use_default_vcl             = false
  use_aetn_dictionary         = true
  use_dummy_shielding_backend = true

  sigsci_enabled   = true
  sigsci_site_name = "test_qa"
  sigsci_backends  = ["F_svodroadblock_web_aetnd_com", "F_webcenter_web_aetnd_com", "F_webpay_commerce_aetnd_com"]

  tags = {
    "aetnd:service_name" = "qa-web-svodroadblock"
  }
}
