# One function owns the credential precedence, and ado.yml anchors every proof

```text
One function owns the credential precedence, and ado.yml anchors every proof.

1  pipeline yaml           the usual start: a pipeline runs a catzc command as a step
2  invoke-automation.yaml  the step template every pipeline step goes through; it maps the pipeline token in
3  Developer shell         the other start: a developer runs the same command locally
4  an ADO API function     the command's call to the Azure DevOps REST API
5  Invoke-AdoRestMethod    the one caller of the header function
6  Pipeline token          the first source, proved against the ado.yml organization
7  PAT                     the second source, bound to the org only by the ADR
8  az CLI                  the last source, proved against the ado.yml tenant
9  Catzc.Azure.Cli         the module whose Assert-AzCliConnected checks the session
10 ado.yml                 the config every proof is checked against

Supports ADR-ADO-AUTH-FIXEDCREDENTIALORDER, ADR-ADO-AUTH-PROVETARGET, ADR-ADO-AUTH-SEPARATETOKENFUNCTION
and ADR-ADO-AUTH-TEMPLATESMAPSYSTEMTOKEN (architecture lens).
```

Cats calls the Azure DevOps REST API from several modules, but only one function, `Get-AdoAuthorizationHeader`, decides which credential a
call uses. Most calls start in a pipeline, as a step run through the `invoke-automation.yaml` template; the rest start in a developer's
shell. Either way the call reaches the header function through one wrapper, and the API functions never touch a credential themselves.
Around the header function sit the parts its proofs rest on: the step template that supplies the pipeline token, the az CLI module, and
`ado.yml`, which every proof is checked against.

```yml drawio
description:
  The two ways an Azure DevOps call starts, a pipeline step through invoke-automation.yaml or a developer's shell, both reaching one header
  function whose three credentials each rest on a proof anchored in ado.yml.
about:
  rules:
    - ADR-ADO-AUTH-FIXEDCREDENTIALORDER
    - ADR-ADO-AUTH-PROVETARGET
    - ADR-ADO-AUTH-SEPARATETOKENFUNCTION
    - ADR-ADO-AUTH-TEMPLATESMAPSYSTEMTOKEN
  lens: architecture
content:
  title: One function owns the credential precedence, and ado.yml anchors every proof
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-entry, label: ENTRY }
    - { id: band-call, label: CALL PATH }
    - { id: band-anchor, label: WHAT A PROOF RESTS ON }
  groups:
    - { id: grp-header, label: Get-AdoAuthorizationHeader, in: band-call }
  glyphs:
    - { id: g-developer, kind: actor, label: Developer shell, in: band-entry }
    - { id: g-pipeline-yaml, kind: runner, label: pipeline yaml, in: band-entry }
    - { id: g-template, kind: runner, label: invoke-automation.yaml, in: band-entry }
    - { id: g-api, kind: code, label: an ADO API function, in: band-call }
    - { id: g-invoke, kind: code, label: Invoke-AdoRestMethod, in: band-call }
    - { id: g-pipeline, kind: gate, label: Pipeline token, in: grp-header }
    - { id: g-pat, kind: gate, label: PAT, in: grp-header }
    - { id: g-azcli, kind: gate, label: az CLI, in: grp-header }
    - { id: g-ado-yml, kind: file, label: ado.yml, in: band-anchor }
    - { id: g-cli-module, kind: code, label: Catzc.Azure.Cli, in: band-anchor }
  edges:
    - { from: g-developer, to: g-api, kind: flow, label: "" }
    - { from: g-pipeline-yaml, to: g-template, kind: flow, label: calls }
    - { from: g-template, to: g-api, kind: flow, label: calls }
    - { from: g-api, to: g-invoke, kind: flow, label: calls }
    - { from: g-invoke, to: grp-header, kind: flow, label: "" }
    - { from: g-pipeline, to: g-template, kind: flow, label: feeds }
    - { from: g-pipeline, to: g-ado-yml, kind: flow, label: "" }
    - { from: g-pat, to: g-ado-yml, kind: record, label: "" }
    - { from: g-azcli, to: g-ado-yml, kind: flow, label: "" }
    - { from: g-azcli, to: g-cli-module, kind: flow, label: calls }
  markers:
    - { at: g-pipeline-yaml, number: 1 }
    - { at: g-template, number: 2 }
    - { at: g-developer, number: 3 }
    - { at: g-api, number: 4 }
    - { at: g-invoke, number: 5 }
    - { at: g-pipeline, number: 6 }
    - { at: g-pat, number: 7 }
    - { at: g-azcli, number: 8 }
    - { at: g-cli-module, number: 9 }
    - { at: g-ado-yml, number: 10 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-entry: { x: 20, y: 84, w: 300, h: 520 }
  band-call: { x: 340, y: 84, w: 600, h: 520 }
  band-anchor: { x: 960, y: 84, w: 320, h: 520 }
  g-developer: { x: 110, y: 126, w: 120, h: 56 }
  g-pipeline-yaml: { x: 50, y: 420, w: 240, h: 44 }
  g-template: { x: 50, y: 200, w: 240, h: 200 }
  g-api: { x: 470, y: 126, w: 340, h: 100 }
  g-invoke: { x: 470, y: 250, w: 340, h: 44 }
  grp-header: { x: 380, y: 310, w: 520, h: 276 }
  g-pipeline: { x: 480, y: 352, w: 320, h: 60 }
  g-pat: { x: 480, y: 432, w: 320, h: 60 }
  g-azcli: { x: 480, y: 512, w: 320, h: 60 }
  g-ado-yml: { x: 1040, y: 352, w: 160, h: 180 }
  g-cli-module: { x: 1000, y: 552, w: 240, h: 44 }
```

![One header function owns the precedence](.assets/one-header-function-owns-precedence.drawio.png)

## Walkthrough

1. **pipeline yaml.** Most calls start here. A pipeline (`ci-pwsh`, `ci-infrastructure`, `cd-shared`, `cd-customer` and the `deploy-unit`
   stage) runs a catzc command as a step.
2. **invoke-automation.yaml.** Every such step goes through this template, which runs the command in `Invoke-AdoScript.ps1` in one of three
   modes (plain PowerShell, az CLI or Azure PowerShell). When the step sets `ExposeAccessToken`, the template maps `SYSTEM_ACCESSTOKEN` into
   it; that mapping is the only reason the pipeline token exists.
3. **Developer shell.** The other start: a developer runs the same command in a local session, where no pipeline token exists.
4. **an ADO API function.** The command reaches the REST API through one of the API functions: `New-AdoPullRequest`, `Register-AdoPipeline`
   and `Get-AdoPipelineDefinitions` in `Catzc.Azure.DevOps`, and `Get-AdoBuildValidations`, `Register-AdoBuildValidation`,
   `Unregister-AdoBuildValidation` and the private `Resolve-AdoBuildValidationContext` in `Catzc.Azure.DevOps.BuildValidation`.
5. **Invoke-AdoRestMethod.** Every API function calls through `Invoke-AdoRestMethod`, the only caller of the header function.
6. **Pipeline token.** The header function's first source is the agent token. It is guarded by `Test-IsRunningInPipeline` from
   `Catzc.Base.Repository`, uses the token the step template mapped in, and is proved against the `ado.yml` `organization`.
7. **PAT.** The second source is an operator-set environment variable. It has no runtime proof; the record binds it to the org because API
   addresses are built from the `ado.yml` `organization`, which no code checks against the header.
8. **az CLI.** The last source is used when neither of the first two is configured. It is proved against the `ado.yml` `tenant`.
9. **Catzc.Azure.Cli.** The source for the az CLI rests on that module's `Assert-AzCliConnected`, which checks the session against the
   tenant.
10. **ado.yml.** The config is the proof anchor: `organization` for the pipeline token and the PAT, `tenant` for the az CLI.
    `Get-Config -Config ado` loads it as the typed `AdoConfig` record, which requires both keys.

## Why it holds

- The precedence is fixed, top to bottom, and a source that fails raises its own error (ADR-ADO-AUTH-FIXEDCREDENTIALORDER).
- Each source proves it targets the configured organization or tenant before it returns a header (ADR-ADO-AUTH-PROVETARGET).
- Token acquisition lives in one separate function, and API-calling functions never inline it (ADR-ADO-AUTH-SEPARATETOKENFUNCTION).
- The step template maps the system token, and functions read only the mapped `$env:SYSTEM_ACCESSTOKEN`
  (ADR-ADO-AUTH-TEMPLATESMAPSYSTEMTOKEN).

## Where the code and the decision record differ

The record says a PAT is bound to the configured org by construction. The API functions default `-Organization` from `ado.yml` but accept
any value, and nothing checks it against the header's source.

## See also

- [Dual authentication](../../drs/ado/dual-authentication.md) — the decision this article explains.
- The other lenses on the same precedence: [meta](configured-credential-proves-its-org.md),
  [implementation](three-guarded-early-returns.md), [operations](what-you-set-decides-the-credential.md) and
  [governance](which-auth-rungs-have-a-gate.md).
- [The ado explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
