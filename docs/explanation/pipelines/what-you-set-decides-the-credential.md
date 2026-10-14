# docs/explanation/pipelines/what-you-set-decides-the-credential.md

`What you set decides the credential, and each wrong setup stops with its own message`

```text
What you set decides the credential, and each wrong setup stops with its own message.

1  ExposeAccessToken: true    the step flag that maps the pipeline token in
2  does not match ado.yml     the message when the collection is not the configured org
3  $env:AZURE_DEVOPS_PAT      a PAT set locally or in CI, used next
4  az login, Connect-AzCli    the az CLI session, used last
5  Not logged in to az CLI    the message when there is no session
6  set to the wrong context   the message when the session is in another tenant
7  No ADO token available     the message when the session yields no token
8  Authorization header       what a working setup gives the REST call

Supports ADR-PIPE-AUTH#1, #2, #5 and #6 (operations lens).
```

Anyone who runs an Azure DevOps REST function in cats, from a pipeline or a terminal, gets its credential from one ladder. The first thing
you have set is used, from the top down. When that setup is wrong you see its own message, and cats does not quietly try the next one: to
switch credentials, unset the one above.

![What you set decides the credential](../../.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.md). Each failure
carries a verbatim fragment of its message; the full messages are quoted below.

## Walkthrough

1. **ExposeAccessToken: true.** In a pipeline, a step built on `pipelines/steps/invoke-automation.yaml` with `ExposeAccessToken: true` maps
   `SYSTEM_ACCESSTOKEN` into that step, in every Mode, and the step log shows the line "ExposeAccessToken: true". A step without the flag
   never sees the token, so the YAML itself shows which steps have API access.
2. **does not match ado.yml.** If the pipeline's collection is not the organization in `ado.yml`, the call stops with "Pipeline collection
   '&lt;uri&gt;' does not match ado.yml organization '&lt;org&gt;' — refusing the agent token for a different org."
3. **$env:AZURE_DEVOPS_PAT.** Outside a pipeline, or with the token not exposed, a PAT you have set locally or in CI is used. Nothing checks
   it up front: a rejected PAT shows up as the REST call's own error.
4. **az login · Connect-AzCli.** With neither set, your az CLI session is used. Log in with `az login --tenant <ado.yml tenant>`, or with
   `Connect-AzCli`.
5. **Not logged in to az CLI.** With no session, you see "Not logged in to az CLI. Run: az login --tenant &lt;tenant&gt;".
6. **set to the wrong context.** With a session in another tenant, you see "az CLI is set to the wrong context. Expected
   tenant=&lt;tenant&gt;; got sub=&lt;subscription&gt; tenant=&lt;tenant&gt;. Run: az login --tenant &lt;tenant&gt;".
7. **No ADO token available.** When the session yields no token, you see "No ADO token available. Set $env:AZURE_DEVOPS_PAT, or run
   Connect-AzCli with an Entra ID account."
8. **Authorization header.** Whichever setup is used, a working one gives the REST call its header, and the call goes ahead.

## Why it holds

- The first configured credential is used, and a configured one that fails stops the call rather than dropping to the next
  (ADR-PIPE-AUTH#1).
- The pipeline token and the az CLI session must prove they belong to the organization and tenant in `ado.yml` (ADR-PIPE-AUTH#2).
- When nothing yields a token, the message names the two fixes (ADR-PIPE-AUTH#5).
- The step template, not the function, decides whether a step gets the token, so the pipeline YAML is the audit trail (ADR-PIPE-AUTH#6).

## Where the code and the ADR differ

- The ADR's step-template sample shows only the `PowerShell@2` task, while `invoke-automation.yaml` maps the token in all three Modes
  (`PowerShell@2`, `AzureCLI@2` and `AzurePowerShell@5`).
- The template's header comment says no credentials leak to environment variables in any mode, yet `ExposeAccessToken` maps
  `SYSTEM_ACCESSTOKEN` as an environment variable, as ADR-PIPE-AUTH#6 requires.

## See also

- [Dual authentication](../../adr/pipelines/dual-authentication.md) — the decision this article explains.
- The other lenses on the same precedence: [meta](configured-credential-proves-its-org.md),
  [architecture](one-header-function-owns-precedence.md), [implementation](three-guarded-early-returns.md) and
  [governance](which-auth-rungs-have-a-gate.md).
- [The pipelines explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
