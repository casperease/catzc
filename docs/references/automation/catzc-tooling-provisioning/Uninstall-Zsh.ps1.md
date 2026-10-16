---
catzc:
  immutable:
    with_body_sha: f874447dd29b
    path: docs/references/automation/catzc-tooling-provisioning/Uninstall-Zsh.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning
    name: uninstall-zsh-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Provisioning/Uninstall-Zsh.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$directories = [System.Collections.Generic.List[string]]::new([string[]]...`, written with `#`.

```text
Children before parents: a child sorts after its parent, so the reverse ordinal order removes the deepest first. A
folder that still holds anything (a file another tool put there) stays.
```
