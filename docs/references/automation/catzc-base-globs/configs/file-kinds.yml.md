---
catzc:
  immutable:
    with_body_sha: "29db5acb5ef4"
    repo_status: locked
    path: docs/references/automation/catzc-base-globs/configs/file-kinds.yml.md
    folder: docs/references/automation/catzc-base-globs/configs
    name: file-kinds-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Globs/configs/file-kinds.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `kinds:`, written with `#`.

```text
The one definition of what a file is, by role. A kind names the role and never the language, track or module, which are keys of their own
in a file's head. Kinds are checked in the order written: the first whose globs, or whose subkinds' globs, match a path names it, and a
file no entry selects is `other`. A consumer extends this in a config fragment, which adds a kind (checked after these) or replaces the
globs of one.
```
