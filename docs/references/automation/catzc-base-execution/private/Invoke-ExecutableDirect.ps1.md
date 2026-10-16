---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/private/Invoke-ExecutableDirect.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "51fea29caf1c"
---

# automation/Catzc.Base.Execution/private/Invoke-ExecutableDirect.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Push-Location $WorkingDirectory`, written with `#`.

```text
Run directly — output flows straight to the console handle.
No pipes, no interception. Spinners, progress bars, \r overwrites all work.
Output WILL leak to the pipeline — callers must suppress if needed.
Child scope prevents $ErrorActionPreference = 'Continue' from leaking.
```
