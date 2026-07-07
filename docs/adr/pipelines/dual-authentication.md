# ADR: Dual authentication — pipeline system token vs. local Az token

## Rules: ADR-AUTH

### Rule ADR-AUTH:1

Select the credential by which one is configured, in fixed precedence (in-pipeline token → PAT → az CLI), with no fallback on auth failure —
a selected source's failure raises its own error rather than degrading to the next.

- [Pattern](#pattern)
- [Decision](#decision)

### Rule ADR-AUTH:2

Each source must prove it targets the configured org/tenant before returning a header (assert `SYSTEM_COLLECTIONURI`, build PAT URLs from
`Organization`, assert the az session tenant), so a present credential never resolves to a different org by accident.

- [Pattern](#pattern)

### Rule ADR-AUTH:3

Make pipeline detection explicit: use `Test-IsRunningInPipeline` to gate the in-pipeline token source.

- [Pattern](#pattern)

### Rule ADR-AUTH:4

Keep token acquisition in a separate function. API-calling functions never inline token logic — they call `Get-AdoAuthorizationHeader`,
which encapsulates the precedence.

- [Why this matters](#why-this-matters)
- [Pattern](#pattern)

### Rule ADR-AUTH:5

Assert when the last source yields nothing: if the az CLI path produces no token, surface the actionable causes (set
`$env:AZURE_DEVOPS_PAT`, or `Connect-AzCli` with an Entra ID account).

- [Pattern](#pattern)

### Rule ADR-AUTH:6

Step templates map the system token: `invoke-automation.yaml` maps `SYSTEM_ACCESSTOKEN: $(System.AccessToken)` when `ExposeAccessToken` is
set. Functions read the mapped `$env:SYSTEM_ACCESSTOKEN`, never `System.AccessToken` directly.

- [Step template integration](#step-template-integration)

### Rule ADR-AUTH:7

Never store tokens in variables beyond the request. Acquire the token, build the header, make the call — do not cache tokens in `$script:`
variables or pass them between functions.

- [Pattern](#pattern)

## Context

Automation code that calls Azure DevOps REST APIs (environments, approvals, wikis) needs a bearer (or Basic) `Authorization` header. The
credential that is available depends on where the code runs and how the operator has configured it:

- **In a pipeline:** ADO injects `System.AccessToken` — a short-lived OAuth token scoped to the pipeline's identity. It is available as
  `$env:SYSTEM_ACCESSTOKEN` when the step template maps it explicitly.

- **With a PAT:** An operator (locally or in CI) may set `$env:AZURE_DEVOPS_PAT` — a Personal Access Token used as HTTP Basic auth.

- **On a developer machine:** The developer is authenticated via `az login` (`Connect-AzCli`). Tokens are obtained at runtime via
  `az account get-access-token`.

These are fundamentally different credential flows. Code that assumes one will break in the other context. The wrong abstraction here — a
single "get me a token" function that tries all of them and _guesses_ which one the operator meant, or falls back to another source when the
first fails to authenticate — leads to silent auth failures that manifest as opaque 401s, or worse, a token aimed at the wrong organization.

### Why this matters

A function calling the ADO REST API must include an `Authorization` header. If the function hardcodes `$env:SYSTEM_ACCESSTOKEN`, it fails
locally. If it hardcodes `az account get-access-token`, it fails in the pipeline (the Az CLI may not be installed, or the agent identity may
not have the right scope), and ignores an operator-supplied PAT.

The dual-auth pattern makes credential selection explicit and deterministic, and proves every credential is aimed at the _configured_
organization/tenant (`ado.yml`) before a header is returned.

## Decision

`Get-AdoAuthorizationHeader` selects a credential by a fixed precedence over **which credential is configured** (its availability), not by
trial-and-error. The order is deterministic; there is no guessing about _intent_, and there is **no fallback to another source when an auth
attempt fails** — a configured-but-failing credential surfaces its own error rather than silently degrading to the next source. Each source
is proven to target the `ado.yml` organization/tenant before a header is returned, so a present credential never resolves to "some other org
by accident."

### Pattern

The precedence (highest first), each with its own org/tenant proof:

1. **In-pipeline agent token** — when `Test-IsRunningInPipeline` is true _and_ `$env:SYSTEM_ACCESSTOKEN` is set: assert
   `$env:SYSTEM_COLLECTIONURI` matches `ado.yml` `Organization` (the agent token is scoped to the org the pipeline runs in — prove that is
   the configured org), then return `Bearer <SYSTEM_ACCESSTOKEN>`.
2. **PAT** — when `$env:AZURE_DEVOPS_PAT` is set: return Basic auth. A PAT carries no ambient org signal, so it is bound to the configured
   org by construction — every API URL is built from `ado.yml` `Organization`.
3. **az CLI** — otherwise: `Assert-AzCliConnected -TenantId (Get-Config -Config ado).tenant` proves the az session is in the Entra directory
   backing the org, then `az account get-access-token --resource $ResourceUrl` returns a `Bearer` token.

```powershell
function Get-AdoAuthorizationHeader {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        # Azure AD resource for az CLI token requests; defaults to the Azure DevOps resource ID.
        [string] $ResourceUrl = '499b84ac-1321-427f-aa17-267ca6975798'
    )

    if ((Test-IsRunningInPipeline) -and $env:SYSTEM_ACCESSTOKEN) {
        $collectionUri = "$env:SYSTEM_COLLECTIONURI".TrimEnd('/')
        $org = "$((Get-Config -Config ado).organization)".TrimEnd('/')
        if ($collectionUri -and $collectionUri -ne $org) {
            throw "Pipeline collection '$collectionUri' does not match ado.yml Organization '$org' — refusing the agent token for a different org."
        }
        return @{ 'Authorization' = "Bearer $env:SYSTEM_ACCESSTOKEN" }
    }

    if ($env:AZURE_DEVOPS_PAT) {
        $base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$env:AZURE_DEVOPS_PAT"))
        return @{ 'Authorization' = "Basic $base64" }
    }

    # Prove the az session is in the Entra directory backing the org before minting a token.
    Assert-AzCliConnected -TenantId (Get-Config -Config ado).tenant

    $result = Invoke-Executable "az account get-access-token --resource $ResourceUrl --query accessToken -o tsv" -PassThru -NoAssert -Silent
    Assert-NotNullOrWhitespace $result.Output -ErrorText (
        'No ADO token available. Set $env:AZURE_DEVOPS_PAT, or run Connect-AzCli with an Entra ID account.'
    )

    @{ 'Authorization' = "Bearer $($result.Output)" }
}
```

The resource URL `499b84ac-1321-427f-aa17-267ca6975798` is Azure DevOps's well-known resource ID, exposed via the `-ResourceUrl` parameter.
**Azure Resource Manager access does not exist yet.** When an ARM-calling path is added, mirror this function with resource
`https://management.azure.com/` (and the same per-source org/tenant proof) rather than overloading the ADO header function.

### Step template integration

```yaml
# invoke-automation.yaml (with auth)
parameters:
  - name: RunCommand
    type: string
  - name: ExposeAccessToken
    type: boolean
    default: false

steps:
  - task: PowerShell@2
    inputs:
      targetType: inline
      script: |
        . './pipelines/Invoke-AdoScript.ps1' -Command '${{ parameters.RunCommand }}' -ExposeAccessToken:$${{ parameters.ExposeAccessToken }}
      pwsh: true
    ${{ if parameters.ExposeAccessToken }}:
      env:
        SYSTEM_ACCESSTOKEN: $(System.AccessToken)
```

The token is only mapped when `ExposeAccessToken` is true. This makes it visible in the YAML which steps have ADO API access — a useful
security audit trail.

## Consequences

- Credential selection is deterministic. The in-pipeline agent token wins when present; otherwise a configured PAT; otherwise the az CLI
  session. No ambiguity, and no silent fallback when a selected source fails to authenticate.
- Every returned header is proven to target the `ado.yml` organization/tenant, so a present credential cannot resolve to a different org by
  accident.
- Auth failures produce clear error messages naming the specific missing credential.
- Functions are portable — they run in both contexts without modification.
- The step template controls token visibility, making it auditable which pipeline steps have API access.
- No token caching or refresh logic — tokens are acquired fresh per call, matching their short-lived nature.

## Dora explains:

DORA's research links explicit security controls and clear error handling to both high delivery performance and low change failure rates.
This ADR's discipline of deterministic credential selection with mandatory org/tenant proof prevents silent auth failures and audit gaps
that compromise both security and deployment reliability.

- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — explicit org/tenant verification prevents credentials from
  targeting the wrong organization.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — deterministic auth without fallback enables reliable pipeline
  execution.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — clear error messages surface the specific
  missing credential.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
