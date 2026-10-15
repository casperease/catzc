---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Change.ps1.md
    kind: comment-page
    body_sha: "87fe9ee57721"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/Test-Change.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The check a person (or an agent) runs before handing work over: instead of the whole suite and every repository-wide
quality gate, only what the change touches
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35): a quality gate over its declared
scope — here, the changed files).

  what changed  -Path, by default the working tree's changes against HEAD (Get-GitChangedPath: staged, unstaged,
                untracked, deleted; a rename as both paths);
  tests         the test files that cover the changed files by convention (Get-ChangeTestFile: a changed test file,
                the test file of a changed function, the test file of a changed C# type), run as one test run through
                Invoke-TestFile — never a bare Invoke-Pester; each failed test is one issue;
  checks        the quality gates each changed file's language names in languages.yml (`checks`, Get-ChangeCheckPlan) —
                configuration, not code ([ADR-PRIN-CONFIG](/docs/adr/principles/configure-not-program.md)). A gate
                with a [string[]] -Path is given the changed files and every issue it finds counts; any other gate
                runs whole and an issue counts only when it names a changed file (the rest are counted as
                unattributed, not reported). A gate that throws (a tool missing) is one issue.

Gates run from the repository root with repo-relative, '/'-separated paths. Ends with Write-QualityGateReport: the
report lands in out/test-change/, and the gate throws once listing every issue (or returns the result with -PassThru).
-DryRun only plans: it returns the changed paths, the test files, and the checks, and runs nothing.
```

## comment:2

Section `.PARAMETER WholeModule` of the comment-based help.

```text
Run every test file of each module a change touches (automation/<Module>/tests/), not only the test files that
cover the changed files.
```

## comment:3

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return the gate result { Subject; IssueCount; Issues; ReportPath; Changed; Tests; Checks; Unattributed } instead of
throwing on issues.
```
