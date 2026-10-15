---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ContentExemptPath.ps1.md
    kind: comment-page
    body_sha: "0de92b9cba8f"
    adrs:
      - ADR-REPO-CONTRACT#6
      - ADR-REPO-ROOTCFG#1
---

# automation/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one predicate the tools that rewrite or check tracked-file content (the link tools, the Markdown-title tools)
ask before they touch a file. A path is exempt when .gitattributes puts it in one of four classes:
linguist-vendored (third-party code, kept as shipped), linguist-generated (files the automation writes, aligned at
their authored input instead), catzc-fixture (test fixture trees, data on purpose), and catzc-contract (contract
assets under contracts/<unit>/<version>/, whose bytes are what a contract check compares —
[ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)). The classes are declared
in the authored .gitattributes that Build-RootConfig renders to the root
([ADR-REPO-ROOTCFG#1](/docs/adr/repository/generated-root-configs.md#rule-adr-repo-rootcfg1)), never in a list of a
tool's own; this function only names which classes mean "leave as written".
```
