---
catzc:
  immutable:
    with_body_sha: f816686869f1
    repo_status: locked
    path: docs/references/automation/catzc-azure/tests/Get-AzureCustomer.Tests.ps1.md
    folder: docs/references/automation/catzc-azure/tests
    name: get-azure-customer-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#19
---

# automation/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Redirect the 'customer' config to the fixture catalogue (acme/ac, globex/gx). Read-only resolver, so
the mock + cache reset run once
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)).
```
