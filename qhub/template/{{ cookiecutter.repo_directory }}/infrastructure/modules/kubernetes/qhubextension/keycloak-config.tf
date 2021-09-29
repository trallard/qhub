
resource "keycloak_openid_client" "keycloak_ext_client" {
  count         = var.oauth2client ? 1 : 0
  realm_id      = var.qhub-realm-id
  client_id     = "${var.name}-client"
  client_secret = var.keycloak-client-password

  name    = "FastAPI Client"
  enabled = true

  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true

  valid_redirect_uris = [
    "https://${var.external-url}/${var.urlslug}/oauth_callback"
  ]

  login_theme = "keycloak"
}

resource "keycloak_openid_group_membership_protocol_mapper" "group_membership_mapper" {
  count = var.oauth2client ? 1 : 0

  realm_id  = var.qhub-realm-id
  client_id = keycloak_openid_client.keycloak_ext_client[count.index].id
  name      = "group-membership-mapper"

  claim_name = "groups"

  add_to_id_token     = false
  add_to_access_token = false
  add_to_userinfo     = true

  full_path = false
}

