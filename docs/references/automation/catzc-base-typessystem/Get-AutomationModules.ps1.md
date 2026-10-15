---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Get-AutomationModules.ps1.md
    kind: comment-page
    body_sha: e887d8e5c3b8
    adrs:
      - ADR-PWSH-PESTER#9
    links: []
---

# automation/Catzc.Base.TypesSystem/Get-AutomationModules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Enumerates the code root (Get-CatzcModulesRoot) and returns each module folder name — the same set
Import-AllModules discovers and imports. The code root is <RepositoryRoot>/automation in source mode and the
built package in build mode
([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)); both hold one folder per module under the same name, so the
list describes the loaded modules in either mode. A non-dot directory is a module; dot-prefixed folders (.internal, .vendor,
.scriptanalyzer, .compiled) are infrastructure and are excluded (see conventional-folders).

This is the platform's single source of the automation-module name list: the module- and
function-dependency analysis validates its declarations against it, the cross-module C# type scan maps
references against it, and the `-Modules` ArgumentCompleter / ValidateScript on Test-Automation derive
their values from it — so the list is always the filesystem, never hand-maintained.

Names are returned sorted ordinally (culture-independent — see cross-platform).
```

## comment:2

Section `.PARAMETER AutomationRoot` of the comment-based help.

```text
Path to the automation directory. Defaults to the loaded code root (Get-CatzcModulesRoot); pass a
fixture tree to isolate a logic test from the real module set.
```

## comment:3

Above `$names = [System.Collections.Generic.List[string]]::new()`.

```text
[System.IO] (sorted ordinally) instead of Get-ChildItem -Directory — the cmdlet carries ~20ms of
per-call provider overhead the raw .NET enumeration avoids
([ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)); the ordinal sort is
culture-independent (cross-platform).
```
