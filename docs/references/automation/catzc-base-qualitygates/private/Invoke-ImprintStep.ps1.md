---
catzc:
  immutable:
    with_body_sha: "0c10b07d3fd4"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-ImprintStep.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: invoke-imprint-step-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Invoke-ImprintStep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `switch -CaseSensitive ($Step) {`, written with `#`.

```text
Each case first returns for an empty list, so a run with no files still proves the step has its adapter, and an empty list
never reaches a command whose default is the whole repository.
```

## comment:2

Above `$moved = @(Export-Comments -Path $File -RepositoryRoot $root -DryRun:$DryRun)`, written with `#`.

```text
The step writes a file and its comment page, so the page is a companion of the file, not a second subject of the step.
The paths stay absolute: the link scope resolves a relative -Path against the current location, which is not the root.
```
