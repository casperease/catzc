# docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md

`automation/Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
Two steps per file, the same two VS Code's Format Document and save apply:

  1. Invoke-Formatter with the repository's one analyzer settings file — brace placement, indentation, whitespace,
     and hashtable alignment (the codeFormatting settings in vscode-settings.yml mirror the same rules);
  2. the .editorconfig rules Invoke-Formatter does not read — LF line endings, no trailing whitespace, one final
     newline ([ADR-REPO-FORMAT#3](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format3)).

A file is written back as UTF-8 without a BOM only when the result differs, compared case-sensitively so a
casing-only change counts. The vendored analyzer and its settings ship in the code tree, so both resolve from
the code root ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1));
the first use in a session imports the analyzer, which takes seconds and is announced.
```

## comment:2

Above `Write-Message 'Loading PSScriptAnalyzer (first use this session)...'`.

```text
First use this session pays the vendored-module import (several seconds) — announce it
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```
