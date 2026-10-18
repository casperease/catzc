# automation/Catzc.Base.QualityGates/Test-Change.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate over what changed: runs the tests and the checks of the changed files, and reports only their issues.

### description

The check a person (or an agent) runs before handing work over: instead of the whole suite and every repository-wide quality gate, only what
the change touches ([ADR-AUTO-TEST#35](../../../adr/automation/test-automation.md#rule-adr-auto-test35): a quality gate over its declared
scope — here, the changed files).

```text
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
```

Gates run from the repository root with repo-relative, '/'-separated paths. Ends with Write-QualityGateReport: the report lands in
out/test-change/, and the gate throws once listing every issue (or returns the result with -PassThru). -DryRun only plans: it returns the
changed paths, the test files, and the checks, and runs nothing.

### parameter `Path`

The changed repo-relative, '/'-separated paths. Default: the working tree's changes (Get-GitChangedPath).

### parameter `WholeModule`

Run every test file of each module a change touches (`automation/<Module>/tests/`), not only the test files that cover the changed files.

### parameter `DryRun`

Plan only: return { Path; Tests; Checks } and run nothing.

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-change).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Changed; Tests; Checks; Unattributed } instead of throwing on issues.

### outputs

`[pscustomobject]` With -PassThru or -DryRun only.

### example 1

```powershell
Test-Change
```

### example 2

```powershell
Test-Change -DryRun
```

### example 3

```powershell
(Test-Change 'automation/Catzc.Base.Files/Get-GitChangedPath.ps1' -PassThru).Issues
```
