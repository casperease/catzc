---
catzc:
  immutable:
    with_body_sha: "217da252795b"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Test-TestInRunScope.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: test-test-in-run-scope-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Test-TestInRunScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Whether a discovered test is inside a test run's tier and category scope.

### description

A test is in scope when neither its tier nor its category — each resolved along its block chain (Get-TestBlockTag, nearest contributing
block wins) — is one of the run's exclude tags (Get-TestExcludeTag). The one scope check behind the work-list's scope filter
(Select-InScopeTestFiles) and the opt-out exclusion (Get-TestOptOutExclusion), so both agree on which tests a run would execute.

### parameter Test

A test from the run's discovery-only Pester result (Get-TestDiscovery).

### parameter ExcludeTag

The run's tier/category exclude tags.

### outputs

`[bool]`

## comment:1

Above `$level = Get-TestBlockTag -Test $Test -Valid...`, written with `#`.

```text
Get-TestBlockTag returns its matches as ONE array object (`, $ret`), so its result is used as-is, never
wrapped in @() — that would nest it and every count would read 1.
```
