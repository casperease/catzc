# The PAT proof and the empty-token assert have no gate

```text
The PAT proof and the empty-token assert have no gate, and neither do #4 and #7.

1  Header function         #1 checked by the throw tests; #4 and #7 have no gate
2  Pipeline token          #3 and #2, checked by two L0 tests
3  PAT                     one L0 test for the Basic header; the #2 org binding has no gate
4  az CLI                  #2 checked by two L0 tests; the #5 empty-token assert has none
5  invoke-automation.yaml  #6, checked by a step in the AzureAuthTests job

Supports ADR-ADO-AUTH-FIXEDCREDENTIALPRECEDENCE, ADR-ADO-AUTH-PROVETARGET, ADR-ADO-AUTH-EXPLICITDETECTION, ADR-ADO-AUTH-SEPARATETOKENFUNCTION, ADR-ADO-AUTH-ASSERTWHENNOTOKEN, ADR-ADO-AUTH-TEMPLATESMAPSYSTEMTOKEN and ADR-FLOW-CD-PIPELINE-NOSTOREDTOKENS (governance lens).
```

ADR-ADO-AUTH has six rules and ADR-FLOW-CD-PIPELINE-NOSTOREDTOKENS adds the seventh, and tests check only some of them. The L0 tests of
`Get-AdoAuthorizationHeader` cover the pipeline and az CLI proofs, and one CI step checks that the token mapping works. The PAT's binding to
the org, the empty-token assert, the one-function rule and the no-caching rule have no gate at all.

![Which auth rungs have a gate](.assets/which-auth-rungs-have-a-gate/diagram.drawio.png)

## Walkthrough

1. **The header function's own rules.** #1 governs the whole ladder: a fixed order, and no fallback when the source it picks fails. The two
   throw tests check that a failing pipeline rung and a failing az CLI rung raise. #4 (callers use the header function) and #7 (no token
   caching) are conventions the code follows today, but no test or analyzer rule checks them.
2. **Pipeline token.** Governed by #3 (explicit pipeline detection) and #2 (collection equals org). Two L0 tests check it: "uses
   SYSTEM_ACCESSTOKEN when the collection matches the configured org" and "throws when the pipeline collection does not match the configured
   org".
3. **PAT.** One L0 test, "uses AZURE_DEVOPS_PAT with Basic auth", checks the Basic header. The #2 binding to the org, by building API
   addresses from `ado.yml`, has no gate.
4. **az CLI.** Two L0 tests check the #2 tenant proof: "asserts the session is in ado.yml's tenant, then returns a Bearer token" and
   "propagates the assertion failure when the session is in the wrong tenant". The #5 empty-token assert runs in the code, but no test
   covers it.
5. **invoke-automation.yaml.** #6, the token mapping in the step template, is checked by the step "ExposeAccessToken: token available" in
   the `AzureAuthTests` job of `.ado/pipelines/ci-automation.yaml`. It asserts only that the token is non-empty when `ExposeAccessToken` is
   true.

No analyzer rule cites ADR-ADO-AUTH. The analyzer rule `Measure-NoRawPipelineDetection` forbids raw reads of the pipeline variables outside
`Test-IsRunningInPipeline`, which supports #3, but it is mapped to ADR-FLOW-CD-DETECT-NODIRECTVARIABLECHECK.

## Why it holds

- The credential is chosen in a fixed order with no fallback on failure (ADR-ADO-AUTH-FIXEDCREDENTIALPRECEDENCE).
- Each source proves its org or tenant before it returns a header (ADR-ADO-AUTH-PROVETARGET).
- Pipeline detection goes through `Test-IsRunningInPipeline` (ADR-ADO-AUTH-EXPLICITDETECTION).
- API functions call the header function and never inline token logic (ADR-ADO-AUTH-SEPARATETOKENFUNCTION).
- An empty az CLI result raises an actionable error (ADR-ADO-AUTH-ASSERTWHENNOTOKEN).
- The step template maps the system token when `ExposeAccessToken` is set (ADR-ADO-AUTH-TEMPLATESMAPSYSTEMTOKEN).
- Tokens are never kept beyond the request (ADR-FLOW-CD-PIPELINE-NOSTOREDTOKENS).

## Where the code and the ADR differ

- ADR-ADO-AUTH-SEPARATETOKENFUNCTION, ADR-ADO-AUTH-ASSERTWHENNOTOKEN and ADR-FLOW-CD-PIPELINE-NOSTOREDTOKENS have no gate: no test and no
  analyzer rule.
- The PAT half of ADR-ADO-AUTH-PROVETARGET holds only by default, because every API function accepts an `-Organization` override.

## See also

- [Dual authentication](../../adr/ado/dual-authentication.md) — the decision this article explains.
- The other lenses on the same precedence: [meta](configured-credential-proves-its-org.md),
  [architecture](one-header-function-owns-precedence.md), [implementation](three-guarded-early-returns.md) and
  [operations](what-you-set-decides-the-credential.md).
- [The ado explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
