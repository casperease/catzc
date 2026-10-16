---
catzc:
  immutable:
    with_body_sha: fd17e6621bd1
    path: docs/references/automation/catzc-base-qualitygates/private/Get-AutomationSourceFiles.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-automation-source-files-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Get-AutomationSourceFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($script in Get-ChildPath $testsPath -File -Filter '*.Tests.ps1'...`, written with `#`.

```text
-Recurse so nested test code (tests/types/*.Tests.ps1) is covered too. Only *.Tests.ps1 is
matched, and tests/assets/ holds no test files, so this picks up real test code only.
```

## comment:2

Above `$analyzerRoot = Join-Path $automationRoot '.scriptanalyzer'`, written with `#`.

```text
Dot-prefixed folders are skipped by the module loop above because they are not modules, but .internal and
.scriptanalyzer still hold authored PowerShell the repo runs — the loader, the bootstrap, the shared
library modules and their tests, and the custom analyzer rules with their tests. These meet the same bar,
so they are enumerated explicitly below. (.vendor is third-party and .compiled is build output — both
stay excluded.)
```

## comment:3

Above `$internalRoot = Join-Path $automationRoot '.internal'`, written with `#`.

```text
.internal holds the shared code the bootstrap and the Catzc modules both call (the loader, the bootstrap,
and the shared library modules) plus their tests. It is authored PowerShell the repo ships and runs, so it
meets the same bar as .scriptanalyzer above.
```

## comment:4

Above `$importerPath = Join-Path $root 'importer.ps1'`, written with `#`.

```text
Authored files outside the module tree that still ship and run with it meet the same bar: the root
importer.ps1 and the analyzer config under .internal/assets. The analyzer config is the ONE authored
.psd1 (committed, not a generated manifest); generated module manifests (automation/**/*.psd1) are
gitignored build output and are deliberately absent.
```
