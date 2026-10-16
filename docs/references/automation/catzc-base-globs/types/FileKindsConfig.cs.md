---
catzc:
  immutable:
    with_body_sha: "532ddd6253c6"
    repo_status: locked
    path: docs/references/automation/catzc-base-globs/types/FileKindsConfig.cs.md
    folder: docs/references/automation/catzc-base-globs/types
    name: file-kinds-config-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Globs/types/FileKindsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class FileKindsConfig`, written with `//`.

```text
The one definition of what a file is, by role: every kind with its one-sentence definition, the globs that select it, and optional
subkinds that narrow it. Local to catzc and global to every file; a consumer extends it by a config fragment, which adds a kind or
replaces the globs of one (a map merges key by key, a list replaces). The fallback kind is declared here, once.
```
