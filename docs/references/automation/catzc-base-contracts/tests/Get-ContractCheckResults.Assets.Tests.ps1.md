---
catzc:
  immutable:
    with_body_sha: "52bb0a59caa2"
    path: docs/references/automation/catzc-base-contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1.md
    folder: docs/references/automation/catzc-base-contracts/tests
    name: get-contract-check-results-assets-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-CONTRACT#{3,4}
---

# automation/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeDiscovery {`, written with `#`.

```text
One test per binding contract asset, generated at discovery, so Test-Automation proves every contract with no
hand-written test ([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)). The set is
the one Test-Contracts checks on a devbox: every asset of each unit's draft, 0.0.0, and the provided assets of every
released version folder still in the tree, since released folders are the pin record; the depended-on assets of a
released folder follow their platform and are not checked
([ADR-REPO-CONTRACT#3](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract3)). Each test checks its asset by
its kind and fails with the asset's findings. A tree with no assets discovers no test here. It reads only the
repository's files, so its answer cannot differ between the run modes (source-only).
```
