---
catzc:
  immutable:
    with_body_sha: e041f22782a3
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ContentStamp.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-content-stamp-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Get-ContentStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The fingerprint of a set of input files: one SHA-256 over a label and each file's path and content hash.

### description

A quality check's result cache keys each file on its own SHA-256 and this stamp of everything else that decides the check's verdict
([ADR-AUTO-CACHE#10](../../../../adr/automation/caching.md#rule-adr-auto-cache10)). A missing input hashes as missing, so adding, editing or
removing one changes the stamp, and every cached verdict of that check is checked again. The files are fingerprinted in the given order
under their repository-relative paths, so the stamp is the same on every clone.

A PowerShell input (.ps1, .psm1, .psd1 — an analyzer rule, a settings file) is fingerprinted by its tokens without its comments: a comment
never decides a verdict, and comments in rule files change often (an ADR citation sweep rewrites them), which would otherwise send every
file back through the check. Every change to the code itself still changes the stamp. A PowerShell file that does not parse, and every other
input, is fingerprinted by its bytes.

### parameter Label

What the stamp is for (an engine or check name); two checks never share a stamp.

### parameter File

The input files, absolute paths.

### parameter RepositoryRoot

The root the paths are recorded relative to.

### outputs

`[string]` A hex SHA-256.

## comment:1

Above `$previousWasLineEnd = $true`, written with `#`.

```text
Comments go; a run of line ends (what a removed comment line leaves) counts as one, since a line
end separates statements but a blank line does not.
```
