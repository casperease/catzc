---
catzc:
  immutable:
    with_body_sha: "273798cd91e7"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-provisioning/tests/Clear-TempFolders.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning/tests
    name: clear-temp-folders-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Provisioning/tests/Clear-TempFolders.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (-not $IsWindows) {`, written with `#`.

```text
FileShare.None is a MANDATORY lock only on Windows; on Unix it is advisory and does not block
delete, so the "locked" file would be removed and this case cannot be set up.
```

## comment:2

Above `$result = Clear-TempFolders -Path @($folder, $folder, ($folder +...`, written with `#`.

```text
The third entry is the same folder with a trailing separator (dedup must canonicalize it away). Use
the platform separator — a hardcoded '\' is a literal filename char on Unix, i.e. a DIFFERENT path.
```
