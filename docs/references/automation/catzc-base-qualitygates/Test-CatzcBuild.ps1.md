---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-CatzcBuild.ps1.md
    kind: comment-page
    body_sha: cae0b3f07500
    adrs:
      - ADR-AUTO-TEST#30
      - ADR-AUTO-TEST#31
      - ADR-AUTO-TEST#33
      - ADR-DSGN-RUNMODE#6
---

# automation/Catzc.Base.QualityGates/Test-CatzcBuild.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The second of the two test runs over one body of tests
([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30),
[ADR-DSGN-RUNMODE#6](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode6)). It builds the
selected modules with Build-Modules (vendor policy 'full', so Pester and PSScriptAnalyzer ship with the build)
into a fresh temporary destination, then runs the Test-Automation harness unchanged in shape — discovery,
the tier/category tag checks, sharding, rows, reports — with one seam swapped: each shard worker dot-sources
the build's Import-Catzc.ps1 -RepositoryRoot <repo> instead of the repository importer, so every test runs
against the merged, built modules while out/ and the test fixtures keep resolving in the repository.

Test files come from the source tree, limited to the tests/ folders of the modules the selection resolves to
(the dependency closure Build-Modules computes). Tests tagged 'source-only'
([ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31)) are excluded
and counted and listed — on the console and in excluded-tests.csv in the run directory — never silently.
Reports go to <out>/test-catzc-build/, so the two test runs' reports never overwrite each other. The build is
deleted when the run ends.

The harness's own module is always built too (each worker reaches its configuration builder and row reducer
through that module's scope), but its tests run only when the selection includes it.

Test-CatzcBuild operates on the source tree — it builds from it and reads its tests — so it runs in source
mode only (Assert-SourceTree).
```

## comment:2

Section `.PARAMETER Module` of the comment-based help.

```text
Modules to build and test (combinable with -ModuleProfile; closure-expanded by Build-Modules). Neither ->
the default bundle's profile (exporter.yml default_bundle).
```

## comment:3

Section `.PARAMETER MaxLevel` of the comment-based help.

```text
Maximum test tier (alias: -Level). Defaults to 3, as in Test-Automation: L0-L3 when the run owns the
working folder, L0-L2 in a snapshot, which skips L3 and says so
([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)). 4 adds the opt-in L4 tier.
```

## comment:4

Section `.PARAMETER PassThru` of the comment-based help.

```text
Returns the run summary object (as Test-Automation's, plus ExcludedTests — the 'source-only' rows — and
Build — the Build-Modules result).
```

## comment:5

Above `$harnessModule = $MyInvocation.MyCommand.Module.Name`.

```text
The harness's own module rides in every build: workers reach its configuration builder and row reducer
through its module scope. Its tests still run only when the selection includes it.
The build names the resolved modules explicitly (closure-expanded again, so the harness's dependencies
come along).
```
