---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md
    kind: comment-page
    body_sha: "613b30fc80f0"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestPaths.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Discovers every automation/<dir>/tests folder in a single .NET directory scan — one enumeration instead
of two Get-ChildItem passes, with no pipeline/object overhead (and fewer filesystem round trips on
network-backed repos, see effective-in-enterprises). A module's Go and Python test folders (<root>/tests/<module
in kebab case>/, Get-LanguageTestFolders) belong to that module and follow its tests folder; a module with only
such tests is included by them. A test folder that matches no catzc module throws, naming the folder. Module tests
come FOUNDATION-FIRST (Get-ModuleTestOrder — a topological sort of the declared dependency graph), so a broken
base module's failures surface before the dependents that cascade from it; dot-prefixed infrastructure
(.internal, .scriptanalyzer) follows, ordinally. Best-effort on the order: if the graph cannot be sorted (a
malformed or cyclic dependencies.yml, which its OWN tests then report), it falls back to the ordinal
order so the test run still proceeds rather than the runner crashing on the config it is testing.
```

## comment:2

Section `.PARAMETER Modules` of the comment-based help.

```text
Narrow to the named automation modules' tests folders and language test folders. Dot-prefixed infrastructure is
never a named module, so it is included only in the unfiltered case. Empty (the default) includes everything.
```

## comment:3

Above `foreach ($testFolder in @(Get-LanguageTestFolders)) {`.

```text
The language test folders (Go, then Python), each after its module's tests folder (Get-LanguageTestFolders
throws on an unmatched folder).
```
