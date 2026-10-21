# pwsh/Catzc.Azure.DevOps/Get-AdoAuthorizationHeader.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `Assert-AzCliConnected -TenantId (Get-Config -Config ado).tenant`, written with `#`.

```text
Prove the az session is in the Entra directory that backs the org before minting a token.
(tenant is a required, validated key — the AdoConfig type guarantees it on load.)
```

## comment:2

Above `if ((Test-IsRunningInPipeline) -and $env:SYSTEM_ACCESSTOKEN) {`, written with `#`.

```text
Every caller takes its header here
([ADR-ADO-AUTH-SEPARATETOKENFUNCTION](/docs/drs/ado/dual-authentication.md#rule-adr-ado-auth-separatetokenfunction)), the sources in a fixed order ([ADR-ADO-AUTH-FIXEDCREDENTIALPRECEDENCE](/docs/drs/ado/dual-authentication.md#rule-adr-ado-auth-fixedcredentialprecedence)).
The pipeline is detected explicitly
([ADR-ADO-AUTH-EXPLICITDETECTION](/docs/drs/ado/dual-authentication.md#rule-adr-ado-auth-explicitdetection)); its
token is the mapped one
([ADR-ADO-AUTH-TEMPLATESMAPSYSTEMTOKEN](/docs/drs/ado/dual-authentication.md#rule-adr-ado-auth-templatesmapsystemtoken)).
```

## comment:3

Above `$collectionUri = "$env:SYSTEM_COLLECTIONURI".TrimEnd('/')`, written with `#`.

```text
The agent token is scoped to the org the pipeline runs in — prove that is the configured org
([ADR-ADO-AUTH-PROVETARGET](/docs/drs/ado/dual-authentication.md#rule-adr-ado-auth-provetarget)).
```

## comment:4

Above `$result = Invoke-AzCli "account get-access-token --resource $ResourceUrl...`, written with `#`.

```text
The last source yields a token or says how to get one
([ADR-ADO-AUTH-ASSERTWHENNOTOKEN](/docs/drs/ado/dual-authentication.md#rule-adr-ado-auth-assertwhennotoken)).
```
