module "dev-www-history-com-fastly" {
  source = "./modules/fastly/vcl_service"

  service_name = "dev.history.com"

  domains = [
    "dev.history.com",
    "dev-auth.history.com",
    "dev-military.history.com",
    "dev-now.history.com",
    "dev-preview.history.com",
    "dev-roots.history.com",
    "dev-shop.history.com",
    "dev.historyenespanol.com",
    "dev.jp.history.com",
  ]

  default_s3_logging      = {}
  default_datadog_logging = {}
  service_name_tag        = "dev-web-webcenter-service"

  backends = {
    loki_editorial_aetnd_io = {
      address     = "dev-editorial-ingress.aetnd.io"
      share_key   = "gV7k0HRhh0mcNyFegGeLqVqA"
      healthcheck = "editorial-HC"
    }
    ua_cic_aetnd_com = {
      address     = "dev-cic-ingress.aetnd.io"
      share_key   = "achHUiIX4HCZ0oGe3nwT5NnF"
      healthcheck = "cic-HC"
    }
    webcenter_web_aetnd_com = {
      address     = "dev-web-webcenter-ingress.aetnd.io"
      share_key   = "t9IAw0ZNTn3yOHemBO4MKtj3"
      healthcheck = "webcenter-HC"
    }
    activate_editorial_aenetworks_cloud = {
      address   = "dev-editorial-history.aenetworks.cloud"
      share_key = "FQ5TN2PBXSDZYhR6rRo0nir9"
    }
  }

  healthchecks = {
    "cic-HC" = {
      host = "dev-ua.cic.aetnd.com"
    }
    "editorial-HC" = {
      host = "dev-loki.editorial.aetnd.com"
    }
    "webcenter-HC" = {
      host = "dev-webcenter.web.aetnd.com"
    }
  }

  snippets = {
    activate                               = { type = "init", priority = 1, content = file("${path.module}/fastly/www-history-com/activate.vcl") }
    loki                                   = { type = "init", priority = 5, content = file("${path.module}/fastly/www-history-com/loki.vcl") }
    aetn_check_shield_recv                 = { type = "init", priority = 10 }
    aetn_stale_deliver                     = { type = "init", priority = 15 }
    aetn_stale_fetch                       = { type = "init", priority = 15 }
    aetn_cache_fetch                       = { type = "init", priority = 20, content = file("${path.module}/fastly/www-history-com/aetn_cache_fetch.vcl") }
    aetn_error                             = { type = "init", priority = 20 }
    aetn_shield                            = { type = "init", priority = 20 }
    aetn_debug_fetch                       = { type = "init", priority = 21 }
    aetn_set_env_recv                      = { type = "init", priority = 25 }
    aetn_stale_error                       = { type = "init", priority = 25 }
    aetn_device_recv                       = { type = "init", priority = 30 }
    aetn_gzip_fetch                        = { type = "init", priority = 30 }
    aetn_geo_recv                          = { type = "init", priority = 35 }
    aetn_deliver                           = { type = "init", priority = 50 }
    aetn_monitoring_check_recv             = { type = "init", priority = 55 }
    aetn_token_auth                        = { type = "init", priority = 60 }
    eu_whitelist_ip                        = { type = "init", priority = 100 }
    aetn_404_s3_fetch                      = { type = "init", priority = 100 }
    aetn_acl                               = { type = "init", priority = 100 }
    aetn_geoblock_europe                   = { type = "init", priority = 100 }
    aetn_geoblock_usacanada                = { type = "init", priority = 100 }
    aetn_geoblock_usa                      = { type = "init", priority = 100 }
    aetn_https_rewrite                     = { type = "init", priority = 100 }
    aetn_service_cache_fetch               = { type = "init", priority = 100 }
    aetn_sign_s3                           = { type = "init", priority = 100 }
    fastly_devicedetect                    = { type = "init", priority = 100 }
    logs-kibana                            = { type = "init", priority = 100 }
    eu_whitelist_useragents                = { type = "init", priority = 100 }
    aetn_eu_redirects                      = { type = "init", priority = 100 }
    aetn_corp_ip                           = { type = "init", priority = 100 }
    aetn_assets_proxypass                  = { type = "init", priority = 100 }
    aetn_cic_proxypass                     = { type = "init", priority = 100 }
    backend_dev_assets_watch_aetnd_com     = { type = "init", priority = 100 }
    backend_dev_editorials_watch_aetnd_com = { type = "init", priority = 100 }
    history-backends                       = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/history-backends.vcl") }
    customer_token                         = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/customer_token.vcl") }
    aetn_editorials_proxypass              = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/aetn_editorials_proxypass.vcl") }
    aetn_services_recv                     = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/aetn_services_recv.vcl") }
    aetn_default_backend                   = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/aetn_default_backend.vcl") }
    aetn_service_eu_redirects              = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/aetn_service_eu_redirects.vcl") }
    aetn_services_proxypass                = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/aetn_services_proxypass.vcl") }
    aetn_services_rewrites                 = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/aetn_services_rewrites.vcl") }
    baseauth                               = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/aetn_baseauth.vcl") }
    redirects                              = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/redirects.vcl") }
    redirects-activate                     = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/redirects-activate.vcl") }
    redirects-arena1                       = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/redirects-arena-1.vcl") }
    redirects-arena2                       = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/redirects-arena-2.vcl") }
    vcl_error                              = { type = "init", priority = 100, content = file("${path.module}/fastly/www-history-com/vcl_error.vcl") }
  }

  vcls = {
    main = {
      main    = true
      content = file("${path.module}/fastly/www-history-com/default_sigsci.vcl")
    }
  }

  extra_dictionary_items = {
    "aetn" = {
      "vercel-protection-bypass" = local.root_outputs.vercel_protection_bypass
    }
  }

  use_common_snippets         = false
  use_default_vcl             = false
  use_aetn_dictionary         = true
  use_dummy_shielding_backend = true

  sigsci_enabled   = true
  sigsci_site_name = "test_dev"
  sigsci_backends  = ["F_loki_editorial_aetnd_io", "F_ua_cic_aetnd_com", "F_webcenter_web_aetnd_com", "F_activate_editorial_aenetworks_cloud"]
  tags = {
    "aetnd:service_name" = "dev-web-webcenter"
  }
}
