# OAuth SIG (OAuth : Special Interest Group)

Ex FAPI-SIG (Financial-grade API Security : Special Interest Group)

## Overview

FAPI-SIG is a group whose activity is mainly supporting [Financial-grade API (FAPI)](https://openid.net/wg/fapi/) and its related specifications to keycloak.

FAPI-SIG is open to everybody so that anyone can join it anytime. Nothing special need not to be done to join it. Who want to join it can only access to the communication channels shown below.  All of its activities and outputs are public so that anyone can access them.

FAPI-SIG mainly treats FAPI and its related specifications but not limited to. E.g., Ecosystems employing FAPI for their API Security like UK OpenBanking, Open Banking Brasil and Australia Consumer Data Right (CDR).

Since June 2023, FAPI-SIG is evolved into OAuth SIG. OAuth SIG will mainly treats OAuth/OIDC and its related security features like FAPI 2.0 to Keycloak.

## Scope

Supporting OAuth/OIDC and its related security features to Keycloak.

## Goals

Currently, proposed goals are as follows.

### Financial-grade API (FAPI) 2.0 related features

- [Financial-grade API (FAPI) 2.0 — Part 1: Baseline Security Profile](https://bitbucket.org/openid/fapi/src/master/FAPI_2_0_Baseline_Profile.md)

- [Financial-grade API (FAPI) 2.0 — Grant Management for OAuth 2.0](https://openid.net/specs/fapi-grant-management-01.html)

- [OAuth 2.0 Rich Authorization Requests (RAR)](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-rar)

- [OAuth 2.0 Demonstrating Proof-of-Possession at the Application Layer (DPoP)](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-dpop)

### Nation/Region/Market Specific Features

- EU : PSD2/eIDAS - QWAC Verification Extension

## Open Works

Currently, proposed open works are as follows.

- Integrating FAPI conformance tests run into keycloak’s CI/CD pipeline

- Implement security profiles for Apps run on mobile devices
  - [RFC 8252 OAuth 2.0 for Native Apps](https://tools.ietf.org/html/rfc8252)
  - [OAuth 2.0 for Browser-Based Apps](https://tools.ietf.org/html/draft-ietf-oauth-browser-based-apps-06)

- [FAPI-RW App2App](https://openid.net/2020/06/23/openid-foundation-announces-fapi-rw-app2app-certification-launched/)

## Results

FAPI related accomplishments by FAPI-SIG, other contributors and keycloak development team is as follows.​

### Common Security Features

#### keycloak 14
 - [Client Policies](https://www.keycloak.org/docs/latest/release_notes/index.html#client-policies-and-financial-grade-api-fapi-support)​

​
### Nation/Region/Market Specific Features

#### keycloak 15
 - [Brazil : Open Banking Brasil Financial-grade API Security Profile](https://www.keycloak.org/docs/latest/release_notes/index.html#financial-grade-api-fapi-improvements-fapi-ciba-and-open-banking-brasil) 
   
   mainly by keycloak development team.

### Standards​

#### keycloak 13

  - [Client Initiated Backchannel Authentication (CIBA) poll mode​](https://www.keycloak.org/docs/latest/release_notes/index.html#openid-connect-client-initiated-backchannel-authentication-ciba)

#### keycloak 14

  - [FAPI 1.0 Baseline Security Profile](https://www.keycloak.org/docs/latest/release_notes/index.html#client-policies-and-financial-grade-api-fapi-support)​
  - [FAPI 1.0 Advanced Security Profile​](https://www.keycloak.org/docs/latest/release_notes/index.html#client-policies-and-financial-grade-api-fapi-support)

#### keycloak 15

  - [Client Initiated Backchannel Authentication (CIBA) ping mode​](https://www.keycloak.org/docs/latest/release_notes/index.html#financial-grade-api-fapi-improvements-fapi-ciba-and-open-banking-brasil)

    mainly by keycloak development team.

  - [FAPI JWT Secured Authorization Response Mode for OAuth 2.0 (JARM)​](https://www.keycloak.org/docs/latest/release_notes/index.html#highlights)

    mainly by the contributor outside FAPI-SIG.

  - [FAPI Client Initiated Backchannel Authentication Profile (FAPI-CIBA)​](https://www.keycloak.org/docs/latest/release_notes/index.html#financial-grade-api-fapi-improvements-fapi-ciba-and-open-banking-brasil)

  - [RFC 9126 OAuth 2.0 Pushed Authorization Requests (PAR)](https://datatracker.ietf.org/doc/html/rfc9126)

#### keycloak 18

  - [OpenID Connect Logout 1.0 for Logout Profiles](https://www.keycloak.org/docs/latest/release_notes/index.html#openid-connect-logout-improvements)

    mainly by keycloak development team and the contributor outside FAPI-SIG.

#### keycloak 20

  - UK OpenBanking​ Security Profile

#### keycloak 23
  - [RFC 9207 OAuth 2.0 Authorization Server Issuer Identification](https://datatracker.ietf.org/doc/html/rfc9207)
  - [RFC 9449 OAuth 2.0 Demonstrating Proof of Possession (DPoP)](https://datatracker.ietf.org/doc/html/rfc9449)
  - [FAPI 2.0 Security Profile Second Implementer’s Draft](https://openid.net/specs/fapi-2_0-security-profile-ID2.html)
  - [FAPI 2.0 Message Signing First Implementer’s Draft](https://openid.bitbucket.io/fapi/fapi-2_0-message-signing.html)

### Automated Conformance Test Run Environment by this kc-fapi-sig repository

The current environment uses the following software version.
- Keycloak version : 23.0.2
- Conformance-suite version : release-v5.1.7

#### FAPI 1.0 Advanced (Final)​
  - Client Authentication Method : MTLS, private_key_jwt​
  - Signature Algorithm : PS256, ES256​
  - Request Object Method : plain, PAR​
  - Response Mode : plain, JARM​

Keycloak 15.0.2 have achieved [certification for all 8 conformance profiles of FAPI 1 Advanced Final (Generic)](https://openid.net/certification/#FAPI_OPs).


#### FAPI-CIBA (Implementer’s Draft)​
  - Client Authentication Method : MTLS, private_key_jwt​
  - Signature Algorithm : PS256, ES256​
  - Mode : Poll, Ping

Keycloak 15.0.2 have achieved [certification for all 4 conformance profiles of Financial-grade API Client Initiated Backchannel Authentication Profile (FAPI-CIBA)](https://openid.net/certification/#FAPI-CIBA_OPs).

#### Open Finance Brasil FAPI 1.0 (Open Banking Brasil FAPI 1.0 was renamed)
  - Client Authentication Method : MTLS, private_key_jwt​
  - Signature Algorithm : PS256
  - Request Object Method : plain, PAR​
  - Response Mode : plain, JARM​

Keycloak 15.0.2 have achieved [certification for 8 conformance profiles of Brazil Open Banking (Based on FAPI 1 Advanced Final)](https://openid.net/certification/#FAPI_OPs) except for DCR (Dynamic Client Registration).

#### Australia Consumer Data Right (CDR)
  - Client Authentication Method : private_key_jwt​
  - Signature Algorithm : PS256
  - Request Object Method : plain, PAR​
  - Response Mode : plain

Keycloak 15.0.2 have achieved [certification for all 2 conformance profiles of Australia CDR (Based on FAPI 1 Advanced Final)](https://openid.net/certification/#FAPI_OPs).

#### UK Open Banking
  - Client Authentication Method : MTLS, private_key_jwt​
  - Signature Algorithm : PS256
  - Request Object Method : plain, PAR​
  - Response Mode : plain

#### OpenID Connect: OpenID Providers
  - Basic OP
  - Implicit OP
  - Hybrid OP
  - Config OP
  - Dynamic OP
  - Form Post OP
  - 3rd Party-Init OP

Keycloak 18.0.0 have re-achieved [certification for 6 conformance profiles of Certified OpenID Providers](https://openid.net/certification/#OPs) except for 3rd Party-Init OP.

#### OpenID Connect: OpenID Providers for Logout Profile
  - Front-Channel OP
  - Back-Channel OP
  - Session OP
  - RP-Initiated OP

Keycloak 18.0.0 have achieved [certification for all 4 conformance profiles of Certified OpenID Providers for Logout Profiles](https://openid.net/certification/#OPs).

Note: Session OP and Front-Channel OP of OpenID Provider for Logout Profile conformance tests cannot be automated. These can be passed manually.

#### FAPI 2.0 Security Profile Second Implementer’s Draft
  - FAPI2SP MTLS + MTLS
    - Client Authentication Method : mtls
    - Sender Constrain : mtls
    - OpenID : plain_oauth
    - FAPI Profile : plain​
  - FAPI2SP private key + MTLS
    - Client Authentication Method : private_key_jwt
    - Sender Constrain : mtls
    - OpenID : plain_oauth
    - FAPI Profile : plain​
  - FAPI2SP OpenID Connect
    - Client Authentication Method : mtls
    - Sender Constrain : mtls
    - OpenID : openid
    - FAPI Profile : plain​

#### FAPI 2.0 Message Signing First Implementer’s Draft
  - FAPI2MS JAR
    - Client Authentication Method : mtls
    - Sender Constrain : mtls
    - OpenID : plain_oauth
    - FAPI Profile : plain​
    - FAPI Request Method : signed_non_repudiation
    - FAPI Response Mode : plain_response
  - FAPI2MS JARM
    - Client Authentication Method : mtls
    - Sender Constrain : mtls
    - OpenID : plain_oauth
    - FAPI Profile : plain​
    - FAPI Request Method : signed_non_repudiation
    - FAPI Response Mode : jarm

### Passed Conformance Tests per Keycloak version

To ensure that every keycloak version can pass conformance tests, we check if a new Keycloak version pass conformance tests that the older Keycloak version could pass whenever the new Keycloak version is released.

We tagged the environment for every keycloak verion:
|Tag|Keycloak version|Conformance-suite version|
|---|----------------|-------------------------|
|kc-15.0.2|15.0.2|release-v4.1.38|
|kc-17.0.0|17.0.0|release-v4.1.41|
|kc-17.0.1|17.0.1|release-v4.1.41|
|kc-18.0.0|18.0.0|release-v4.1.42|
|kc-18.0.2|18.0.2|release-v4.1.42|
|kc-19.0.1|19.0.1|release-v4.1.45|
|kc-19.0.2|19.0.2|release-v5.0.3|
|kc-20.0.0|20.0.0|release-v5.0.6|
|kc-20.0.1|20.0.1|release-v5.0.6|
|kc-20.0.2|20.0.2|release-v5.0.7|
|kc-20.0.3|20.0.3|release-v5.0.12|
|kc-20.0.5|20.0.5|release-v5.0.14|
|kc-21.0.0|21.0.0|release-v5.1.0|
|kc-21.0.1|21.0.1|release-v5.1.0|
|kc-21.0.2|21.0.2|release-v5.1.2|
|kc-21.1.0|21.1.0|release-v5.1.2|
|kc-21.1.1|21.1.1|release-v5.1.2|
|kc-21.1.2|21.1.2|release-v5.1.5|
|kc-22.0.0|22.0.0|release-v5.1.5|
|kc-22.0.1|22.0.1|release-v5.1.5|
|kc-22.0.2|22.0.2|release-v5.1.5|
|kc-22.0.3|22.0.3|release-v5.1.7|
|kc-22.0.4|22.0.4|release-v5.1.8|
|kc-22.0.5|22.0.5|release-v5.1.9|
|kc-23.0.0|23.0.0|release-v5.1.7(*)|
|kc-23.0.1|23.0.1|release-v5.1.7(*)|
|kc-23.0.2|23.0.2|release-v5.1.7(*)|

\* : [Issue-455](https://github.com/keycloak/kc-sig-fapi/issues/455)

|Keycloak version|FAPI 1.0 Advanced|FAPI-CIBA|Open Banking/Finance Brasil FAPI 1.0 (\*1,\*2)|Australia Consumer Data Right (CDR)|UK Open Banking|OpenID Connect OP (\*3)|OpenID Connect OP for Logout Profile|FAPI 2.0 Security Profile Implementer’s Draft|FAPI 2.0 Message Signing Implementer’s Draft|
|-|-|-|-|-|-|-|-|-|-|
|15.0.2|x|x|x|x|-|-|-|-|-|
|17.0.0|x|x|x|x|-|-|-|-|-|
|17.0.0-legacy|x|x|x|x|-|-|-|-|-|
|17.0.1|x|x|x|x|-|-|-|-|-|
|17.0.1-legacy|x|x|x|x|-|-|-|-|-|
|18.0.0|x|x|x|x|-|x|x|-|-|
|18.0.0-legacy|x|x|x|x|-|x|x|-|-|
|18.0.2|x|x|x|x|-|x|x|-|-|
|18.0.2-legacy|x|x|x|x|-|x|x|-|-|
|19.0.1|x|x|x|x|-|x|x|-|-|
|19.0.1-legacy|x|x|x|x|-|x|x|-|-|
|19.0.2|x|x|x|x|-|x|x|-|-|
|19.0.2-legacy|x|x|x|x|-|x|x|-|-|
|20.0.0|x|x|x|x|x|x|x|-|-|
|20.0.1|x|x|x|x|x|x|x|-|-|
|20.0.2|x|x|x|x|x|x|x|-|-|
|20.0.3|x|x|x|x|x|x|x|-|-|
|20.0.5|x|x|x|x|x|x|x|-|-|
|21.0.0|x|x|x|x|x|x|x|-|-|
|21.0.1|x|x|x|x|x|x|x|-|-|
|21.0.2|x|x|x|x|x|x|x|-|-|
|21.1.0|x|x|x|x|x|x|x|-|-|
|21.1.1|x|x|x|x|x|x|x|-|-|
|21.1.2|x|x|x|x|x|x|x|-|-|
|22.0.0|x|x|x|x|x|x|x|-|-|
|22.0.1|x|x|x|x|x|x|x|-|-|
|22.0.2|x|x|x|x|x|x|x|-|-|
|22.0.3|x|x|x|x|x|x|x|-|-|
|22.0.4|x|x|x|x|x|x|x|-|-|
|22.0.5|x|x|x|x|x|x|x|-|-|
|23.0.0|x|x|-(*4)|x|x|x|x|x|x|
|23.0.1|x|x|x|x|x|x|x|x|x|
|23.0.2|x|x|x|x|x|x|x|x|x|

Note: Keycloak legacy (wildfly) is no longer supported since [keycloak 20](https://www.keycloak.org/docs/latest/release_notes/index.html#wildfly-distribution-removed).

\*1 : Up to Implementer's Draft version 2, Open Banking Brazil Security Profile. From Implementer's Draft version 3, Open Finance Brazil Security Profile.

\*2 : Except for Dynamic Client Registration (DCR) conformance profile.

\*3 : Except for 3rd Party-Init OP conformance profile.

\*4 : [ISSUE-25022](https://github.com/keycloak/keycloak/issues/25022)

## Communication Channels

Not only OAuth SIG member but others can communicate with each other by the following ways.

- Slack : Cloud Native Computing Foundation (CNCF) slack's channel #keycloak-oauth-sig
- Mail : Google Group [keycloak developer mailing list](https://groups.google.com/forum/#!topic/keycloak-dev/Ck_1i5LHFrE)
- Chat : Zulip Chat stream ([#dev-sig-fapi](https://keycloak.zulipchat.com/#narrow/stream/248413-dev-sig-fapi))
- Meeting : Web meeting on a regular basis

## Automated Conformance Test Run Environment

Please see [conformance-tests-env](./conformance-tests-env/README.md).

## License

* [Apache License, Version 2.0](./LICENSE)

