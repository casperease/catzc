---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/configs/identity-tokens.yml.md
    kind: reference
    body_sha: "2d514bd61cb9"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Azure.DevOps/configs/identity-tokens.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `tokens:`.

```text
The live production identity this module's config carries — the ADO project — which a hermetic logic test must
never name ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)). Read by
Get-LiveIdentityTokens with every other module's identity-tokens.yml; validated by the IdentityTokensConfig type.
```
