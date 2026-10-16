---
catzc:
  immutable:
    with_body_sha: "6186b459eb4c"
    repo_status: locked
    path: docs/references/automation/catzc-base-modules/types/Module.cs.md
    folder: docs/references/automation/catzc-base-modules/types
    name: module-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Modules/types/Module.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class Module`, written with `//`.

```text
A module of a deployable track as the one resolver returns it: identity only. Its needs and its place in the order are functions of
the declared graph over module names, not members of this type.
```
