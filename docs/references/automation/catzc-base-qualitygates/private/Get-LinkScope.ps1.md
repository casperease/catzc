---
catzc:
  immutable:
    with_body_sha: aa98ed33c436
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LinkScope.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-link-scope-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Get-LinkScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the repository-relative files the link engine reads.

### description

With no -Path, every git-tracked file (Get-GitTrackedPath) — the repository as committed, not whatever lies
untracked in the working folder. With -Path, the given files and the files under the given folders, from the
filesystem. Either way a file the content tools leave as written (Get-ContentExemptPath: vendored, generated,
fixture, or contract asset) is never aligned. No list of its own: a new class is declared in the .gitattributes
source.

### parameter RepositoryRoot

The repository root the returned paths are relative to.

### parameter Path

Optional files or folders (absolute or relative to the current location) to limit the scope to.

### outputs

`[string[]]` repository-relative, '/'-separated paths.

## comment:1

Above `$isDiskRoot = {`, written with `#`.

```text
Never enumerate a whole drive: neither the repository root nor a -Path may be a disk root (C:\, /, a UNC
share root). A relative -Path resolves against the current location, so '.' run from C:\ would be all of C:.
```
