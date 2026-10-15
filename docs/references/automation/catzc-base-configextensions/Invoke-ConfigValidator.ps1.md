---
catzc:
  derived:
    path: docs/references/automation/catzc-base-configextensions/Invoke-ConfigValidator.ps1.md
    kind: comment-page
    body_sha: "9a167d821909"
    adrs: []
---

# automation/Catzc.Base.ConfigExtensions/Invoke-ConfigValidator.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The PowerShell extension point for config validation. Core configs validate through a C# config type
registered in configs.yml (Get-Config); a config whose owner cannot ship a C# type validates here instead,
with a PowerShell function that receives the parsed dictionary and throws on a violation.

The validator is found by convention, Assert-<TitleCase(name)>Config (so 'widget-parts' is
Assert-WidgetPartsConfig), or named with -Validator. It is resolved and run inside the owning module
(`& (Get-Module $Module) { … }`), so a private validator works and the result is the same whichever module
calls. With the conventional name and no such function, nothing runs and nothing is returned; a -Validator
that does not exist throws.
```
