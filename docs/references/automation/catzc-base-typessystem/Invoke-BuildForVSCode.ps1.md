---
catzc:
  immutable:
    with_body_sha: "1bd5d0ba42ef"
    path: docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
    folder: docs/references/automation/catzc-base-typessystem
    name: invoke-build-for-vs-code-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above ``$result = Invoke-Executable "dotnet build `"$project`" --configuration...``, written with `#`.

```text
The stamp task's "stamped version …" line and any analyzer diagnostics stream through. A non-zero exit
(a stale committed DLL, an analyzer error) throws via Invoke-Executable.
```
