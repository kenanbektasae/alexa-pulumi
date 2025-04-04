module "prod-www-aetv-com-fastly" {
  source = "./modules/fastly/vcl_service"

  service_name = "www.aetv.com"

  domains = [
    "aetv.com",
    "beardyourself.aetv.com",
    "community.aetv.com",
    "damien.aetv.com",
    "duckdynastyrevival.com",
    "duckdynastytherevival.com",
    "preview.aetv.com",
    "robertsonfamily.aetv.com",
    "shop.aetv.com",
    "www.aetv.com",
    "www.duckdynastyrevival.com",
    "www.duckdynastytherevival.com",
    "www.lookevencloser.com",
  ]

  backends = {
    webcenter_web_aetnd_com = {
      address     = "prod-web-webcenter-ingress.aetnd.io"
      share_key   = "dhf9Z4X0F76Mt2Xy7jid55cA"
      healthcheck = "webcenter-HC"
    }
    ua_cic_aetnd_com = {
      address     = "prod-cic-ingress.aetnd.io"
      share_key   = "sFyM370Ae6mtjs3JaCmFJ7oL"
      healthcheck = "cic-HC"
    }
  }

  healthchecks = {
    "webcenter-HC" = {
      host    = "loki.editorial.aetnd.com"
      initial = 2
    }
    "cic-HC" = {
      host    = "ua.cic.aetnd.com"
      initial = 2
    }
  }

  default_s3_logging      = {}
  default_datadog_logging = {}
  service_name_tag        = "prod-web-webcenter-service"

  snippets = {
    aetn_check_shield_recv              = { type = "init", priority = 10 }
    aetn_stale_deliver                  = { type = "init", priority = 15 }
    aetn_stale_fetch                    = { type = "init", priority = 15 }
    aetn_cache_fetch                    = { type = "init", priority = 20 }
    aetn_error                          = { type = "init", priority = 20 }
    aetn_shield                         = { type = "init", priority = 20 }
    aetn_debug_fetch                    = { type = "init", priority = 21 }
    aetn_corp_ip                        = { type = "init", priority = 25 }
    aetn_set_env_recv                   = { type = "init", priority = 25 }
    aetn_stale_error                    = { type = "init", priority = 25 }
    aetn_device_recv                    = { type = "init", priority = 30 }
    aetn_gzip_fetch                     = { type = "init", priority = 30 }
    aetn_geo_recv                       = { type = "init", priority = 35 }
    aetn_deliver                        = { type = "init", priority = 50 }
    aetn_monitoring_check_recv          = { type = "init", priority = 55 }
    aetn_token_auth                     = { type = "init", priority = 60 }
    aetn_eu_redirects                   = { type = "init", priority = 100 }
    eu_whitelist_ip                     = { type = "init", priority = 100 }
    eu_whitelist_useragents             = { type = "init", priority = 100 }
    aetn_404_s3_fetch                   = { type = "init", priority = 100 }
    aetn_acl                            = { type = "init", priority = 100 }
    aetn_geoblock_europe                = { type = "init", priority = 100 }
    aetn_geoblock_usacanada             = { type = "init", priority = 100 }
    aetn_geoblock_usa                   = { type = "init", priority = 100 }
    aetn_https_rewrite                  = { type = "init", priority = 100 }
    aetn_service_cache_fetch            = { type = "init", priority = 100 }
    aetn_sign_s3                        = { type = "init", priority = 100 }
    fastly_devicedetect                 = { type = "init", priority = 100 }
    logs-kibana                         = { type = "init", priority = 100 }
    aetn_cic_proxypass                  = { type = "init", priority = 100 }
    aetn_assets_proxypass               = { type = "init", priority = 100 }
    aetn_player_proxypass               = { type = "init", priority = 100 }
    backend_prod_assets_watch_aetnd_com = { type = "init", priority = 100 }
    backend_prod_player_watch_aetnd_com = { type = "init", priority = 100 }
    aetn_service_eu_redirects           = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aetv-com/aetn_service_eu_redirects.vcl") }
    aetn_services_rewrites              = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aetv-com/aetn_services_rewrites.vcl") }
    aetn_services_proxypass             = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aetv-com/aetn_services_proxypass.vcl") }
    aetn_services_recv                  = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aetv-com/aetn_services_recv.vcl") }
    aetn_default_backend                = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aetv-com/aetn_default_backend.vcl") }
    redirects                           = { type = "init", priority = 100, content = file("${path.module}/fastly/www-aetv-com/redirects.vcl") }
  }

  vcls = {
    main = {
      main    = true
      content = file("${path.module}/fastly/www-aetv-com/default_sigsci.vcl")
    }
  }

  use_common_snippets         = false
  use_default_vcl             = false
  use_aetn_dictionary         = true
  use_dummy_shielding_backend = true

  sigsci_enabled   = true
  sigsci_site_name = "test_prod"
  sigsci_backends  = ["F_webcenter_web_aetnd_com", "F_ua_cic_aetnd_com"]

  tags = {
    "aetnd:service_name" = "prod-web-webcenter"
  }
}
