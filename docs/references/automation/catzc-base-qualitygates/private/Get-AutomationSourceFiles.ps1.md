---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md
    kind: reference
    body_sha: ff465103bda4
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-AutomationSourceFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One source of truth for "what the quality gates analyze", so Test-ScriptAnalyzer and the L2 analyzer test
cannot drift apart. Formatting covers every tracked PowerShell file instead (Format-Code). Covers every authored PowerShell file the repository ships
or runs: each module's root *.ps1 (non-test), private/*.ps1, tests/**/*.Tests.ps1; the .internal
shared modules (the loader, the bootstrap, the shared libraries, the TestKit fixture library) and their
tests/**/*.Tests.ps1; the custom analyzer rules (.scriptanalyzer/*.psm1) and their tests/**/*.Tests.ps1;
the root importer.ps1; and
authored .psd1 config (PSScriptAnalyzerSettings.psd1). The .vendor (third-party) and .compiled (build
output) folders and generated module manifests are excluded — build output made canonical by its
generator, not hand-authored.

The set is the per-function files of the catzc source tree, so it needs the source mode and throws in build
mode (Assert-SourceTree); every path below is a repository path by design.
```

## comment:2

Above `Get-ChildItem -Path $testsPath -Filter '*.Tests.ps1' -File -Recurse |`.

```text
-Recurse so nested test code (tests/types/*.Tests.ps1) is covered too. Only *.Tests.ps1 is
matched, and tests/assets/ holds no test files, so this picks up real test code only.
```

## comment:3

Above `$analyzerRoot = Join-Path $automationRoot '.scriptanalyzer'`.

```text
Dot-prefixed folders are skipped by the module loop above because they are not modules, but .internal and
.scriptanalyzer still hold authored PowerShell the repo runs — the loader, the bootstrap, the shared
library modules and their tests, and the custom analyzer rules with their tests. These meet the same bar,
so they are enumerated explicitly below. (.vendor is third-party and .compiled is build output — both
stay excluded.)
```

## comment:4

Above `$internalRoot = Join-Path $automationRoot '.internal'`.

```text
.internal holds the shared code the bootstrap and the Catzc modules both call (the loader, the bootstrap,
and the shared library modules) plus their tests. It is authored PowerShell the repo ships and runs, so it
meets the same bar as .scriptanalyzer above.
```

## comment:5

Above `$importerPath = Join-Path $root 'importer.ps1'`.

```text
Authored files outside the module tree that still ship and run with it meet the same bar: the root
importer.ps1 and the analyzer config under .internal/assets. The analyzer config is the ONE authored
.psd1 (committed, not a generated manifest); generated module manifests (automation/**/*.psd1) are
gitignored build output and are deliberately absent.
```
