# pwsh/Azure.DevOps/Get-AdoAuthorizationHeader.ps1

The one function that returns the Authorization header for Azure DevOps REST calls. Every caller takes its header here
([ADR-ADO-AUTH-SEPARATETOKENFUNCTION](../../../drs/ado/dual-authentication.md#rule-adr-ado-auth-separatetokenfunction)).

## help

### synopsis

Returns an Authorization header for Azure DevOps REST API calls.

### description

The sources of authentication, in priority order. Each is proven to target the configured org/tenant (ado.yml) before a header is returned —
a credential alone never establishes "the right thing".

1. Pipeline: $env:SYSTEM_ACCESSTOKEN — Bearer token, after asserting $env:SYSTEM_COLLECTIONURI matches ado.yml organization (the agent token
   is scoped to the org the pipeline runs in).
2. PAT: $env:AZURE_DEVOPS_PAT — Basic auth. A PAT carries no ambient org signal; it is used only against ado.yml organization (every API URL
   is built from it), so it is bound to the configured org by construction.
3. az CLI: asserts the session is in ado.yml's `tenant` (Assert-AzCliConnected), then runs az account get-access-token for the ADO resource
   — Bearer token.

Returns a hashtable suitable for splatting into Invoke-RestMethod -Headers.

### parameter `ResourceUrl`

The Azure AD resource URL for az CLI token requests. Defaults to the Azure DevOps resource ID (499b84ac-1321-427f-aa17-267ca6975798).

### example 1

```powershell
$headers = Get-AdoAuthorizationHeader
Invoke-RestMethod -Uri $url -Headers $headers
```

## Credential sources

The sources run in a fixed order, the first that applies winning
([ADR-ADO-AUTH-FIXEDCREDENTIALPRECEDENCE](../../../drs/ado/dual-authentication.md#rule-adr-ado-auth-fixedcredentialprecedence)):

1. The pipeline's system token, when the run is detected as a pipeline run
   ([ADR-ADO-AUTH-EXPLICITDETECTION](../../../drs/ado/dual-authentication.md#rule-adr-ado-auth-explicitdetection)) and `SYSTEM_ACCESSTOKEN`
   is set. The token is the one the templates map in
   ([ADR-ADO-AUTH-TEMPLATESMAPSYSTEMTOKEN](../../../drs/ado/dual-authentication.md#rule-adr-ado-auth-templatesmapsystemtoken)).
2. A personal access token from `AZURE_DEVOPS_PAT`.
3. An Entra token minted through `az account get-access-token` for the Azure DevOps resource.

## Proving the target

The agent token is scoped to the organization the pipeline runs in, so the function proves that organization is the configured one before it
returns the header, and refuses the token for a different organization
([ADR-ADO-AUTH-PROVETARGET](../../../drs/ado/dual-authentication.md#rule-adr-ado-auth-provetarget)). The az fallback proves the session
sits in the Entra directory that backs the organization (`tenant` in `ado.yml`, a required key the config type checks on load) before it
mints a token.

## When no token is found

The last source yields a token or says how to get one: with none available the function throws and names both fixes, `AZURE_DEVOPS_PAT` or
`Connect-AzCli`
([ADR-ADO-AUTH-ASSERTWHENNOTOKEN](../../../drs/ado/dual-authentication.md#rule-adr-ado-auth-assertwhennotoken)).
