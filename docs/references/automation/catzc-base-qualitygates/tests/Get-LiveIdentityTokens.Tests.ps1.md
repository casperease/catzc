---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-LiveIdentityTokens.Tests.ps1.md
    kind: comment-page
    body_sha: a1c0238073c0
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:declarations = @{`, written with `#`.

```text
Fixture configs through the Get-Config seam — the derivation must reflect exactly what the shipped
config declares, never a hand-kept list. The 'live' identities here are the fixture identities the
mocked config declares; the derivation logic is identical against the real config
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Two declaring modules (identity-tokens.yml), each naming only configs it owns.
```
