local openidc = require("resty.openidc")

openidc.set_logging(nil, { DEBUG = ngx.INFO })

local opts = {
  discovery = os.getenv("DISCOVERY_URL"),
  introspection_endpoint = os.getenv("INTROSPECTION_ENDPOINT_URL"),
  client_id = "resource-server",
  client_secret = os.getenv("CLIENT_SECRET"),
  ssl_verify = "yes",
}

local res, err = nil
if opts.introspection_endpoint ~= nil then
  opts.introspection_interval = 0

  -- call introspect for OAuth 2.0 Bearer Access Token validation
  res, err = openidc.introspect(opts)

elseif opts.discovery ~= nil then
  opts.token_signing_alg_values_expected = { "RS256" }
  opts.accept_none_alg = false
  opts.accept_unsupported_alg = false

  -- verify JWT for OAuth 2.0 Bearer Access Token validation
  res, err = openidc.bearer_jwt_verify(opts)

else
  ngx.status = 500
  ngx.log(ngx.ERR, "need to configure DISCOVERY_URL or INTROSPECTION_ENDPOINT_URL")
  ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end
 
if err or not res then
  ngx.status = 401
  ngx.say(err and err or "no access_token provided")
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

if res.cnf == nil or res.cnf["x5t#S256"] == nil then
  ngx.status = 401
  ngx.say("no cnf.x5t#256 provided in access_token")
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- FAPIRW-5.2.2-5 Handling holder of key bound for access token
-- https://openid.net/specs/openid-financial-api-part-2-ID2.html#rfc.section.5.2.2
-- https://tools.ietf.org/html/rfc8705

local ssl = require "ngx.ssl"
local der_client_cert, err = ssl.cert_pem_to_der(ngx.var.ssl_client_raw_cert)
if not der_client_cert then
  ngx.log(ngx.ERR, "failed to convert client certificate from PEM to DER: ", err)
  ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

local resty_sha256 = require "resty.sha256"
local sha256 = resty_sha256:new()
sha256:update(der_client_cert)
local digest = sha256:final()

local b64 = require("ngx.base64")
local encoded = b64.encode_base64url(digest)

if encoded ~= res.cnf["x5t#S256"] then
  ngx.log(ngx.ERR, "unmatch request client certificate and cnf.x5t#256 in access_token: " .. encoded .. " != " .. res.cnf["x5t#S256"])
  ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- FAPI-R-6.2.1-11 Handling x-fapi-interaction-id
-- https://openid.net/specs/openid-financial-api-part-1-ID2.html#rfc.section.6.2.1
if ngx.var.http_x_fapi_interaction_id == nil then
  local uuid = require 'resty.jit-uuid'
  ngx.req.set_header("x-fapi-interaction-id", uuid())
end
ngx.header["x-fapi-interaction-id"] = ngx.var.http_x_fapi_interaction_id

