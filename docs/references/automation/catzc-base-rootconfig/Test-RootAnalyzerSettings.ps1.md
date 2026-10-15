---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/Test-RootAnalyzerSettings.ps1.md
    kind: reference
    body_sha: d4aee6dbdb15
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the consumer
contract of the root PSScriptAnalyzerSettings.psd1 ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)):
PSScriptAnalyzer requires a literal-hashtable settings file at the path it is given. The target is a copyAsLink
entry of rootconfig.yml, so content equality with its source holds by construction (Test-RootConfigFiles checks
the link); what remains is that a consumer opening the ROOT path can follow the link and parse a non-empty
settings hashtable. It collects an issue when the file is missing (re-run the importer, which materialises it on
every load), does not parse as a data file, or holds no settings.

When the entry is not opted in, the root file is not managed and the gate checks nothing (Checked = $false).
```
