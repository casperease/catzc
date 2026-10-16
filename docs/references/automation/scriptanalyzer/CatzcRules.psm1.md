---
catzc:
  immutable:
    with_body_sha: "675d40d989f6"
    repo_status: locked
    path: docs/references/automation/scriptanalyzer/CatzcRules.psm1.md
    folder: docs/references/automation/scriptanalyzer
    name: catzc-rules-psm1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/.scriptanalyzer/CatzcRules.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:measures = $null`, written with `#`.

```text
The check modules' Measure-* functions, loaded on the first root block (see Measure-CatzcRules); declared at load so
the guard reads it strict-clean.
```

## comment:2

Above `function Measure-CatzcRules {`, written with `#`.

```text
.SYNOPSIS
    The one custom PSScriptAnalyzer rule the settings load: runs every repository check once per file.
.DESCRIPTION
    One entry rule acting only on the root block, so each check runs once per file instead of once per script block.
    [comment:2](/docs/references/automation/scriptanalyzer/CatzcRules.psm1.md#comment2)
.PARAMETER ScriptBlockAst
    The script block the engine hands the rule; only a file's root block (no parent) is acted on.
```

## comment:3

Above `if ($null -eq $script:measures) {`, written with `#`.

```text
Each check module loads nested in this one, so its Measure-* functions are visible here but not exported to the
engine. A module may export more than one check.
```
