# automation/Catzc.Base.Files/Get-InputStamp.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Fingerprints a set of input files by their paths and content, the same on every checkout of the same inputs.

### description

Returns one SHA-256 hex string over the sorted (path, content hash) of every file named by -Path. A path may be a file or a folder: a folder
contributes every file below it (-Filter narrows by name). A missing path contributes a marker of its own, so deleting an input changes the
stamp.

The stamp depends on what the inputs say, never on when they were written: a path under -Root is named relative to it with '/' separators,
and a file's content is hashed with its carriage returns removed. A clone, a snapshot, a CRLF checkout and a touched-but-identical file all
stamp the same, so a generator can write the stamp into the file it generates and every checkout agrees with it (Test-GeneratedFileCurrent).
The work is done by the compiled Catzc.Base.Files.InputStamp, which hashes the files in parallel: a few megabytes of text take milliseconds.

It rests on [ADR-PRIN-ONELIVE](../../../adr/principles/one-living-version.md).

### parameter `Path`

The input files and folders to fingerprint.

### parameter `Filter`

A file-name filter applied inside folders (for example `*.md`). Defaults to every file.

### parameter `Exclude`

Wildcard patterns for files left out of the stamp, matched against the full path with '/' separators (for example `*/README.md`). A
generator names its own output, and the generated pages beside its inputs, so writing them does not change the stamp.

### parameter `Root`

The folder paths are named relative to. Default: the repository root. A path outside it is named in full.

### parameter `Salt`

Extra text folded into the stamp, for an input that is not a file (a setting, a version).

### outputs

`[string]` A 64-character lowercase SHA-256 hex string.

### example 1

```powershell
Get-InputStamp -Path $glossaryPaths, (Resolve-RepoPath 'docs/adr') -Exclude '*/README.md'
```
