# pwsh/Base.Files/Get-InputStamp.ps1

The command that fingerprints a set of input files into one SHA-256 hex string, by their content or by their last write and size.

## help

### synopsis

Fingerprints a set of input files by their paths and either their content or their last write and size.

### description

Returns one SHA-256 hex string over the sorted (path, identity) of every file named by -Path. A path may be a file or a folder: a folder
contributes every file below it (-Filter narrows by name). A missing path contributes a marker of its own, so deleting an input changes the
stamp.

By content, the default, the stamp depends on what the inputs say, never on when they were written: a path under -Root is named relative to
it with '/' separators, and a file's content is hashed with its carriage returns removed. A clone, a snapshot, a CRLF checkout and a
touched-but-identical file all stamp the same, so every checkout agrees on a stamp computed from the same inputs (the file-meta result
cache). By metadata, a file's last write and size stand in for its content: no file is read, and a touch or a checkout only ever makes the
stamp differ, never hides a change (the generated-file writers' memo). The work is done by the compiled Catzc.Base.Files.InputStamp, in
parallel.

It rests on [PDR-ONELIVE](../../../drs/principles/one-living-version.md).

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

### parameter `By`

What stands for a file in the stamp: `Content` (its hash, the same on every checkout) or `Metadata` (its last write and size, cheaper, and
different after a touch). Default: `Content`, declared once on Catzc.Base.Files.InputStamp.

### outputs

`[string]` A 64-character lowercase SHA-256 hex string.

### example 1

```powershell
Get-InputStamp -Path $glossaryPaths, (Resolve-RepoPath 'docs/drs') -Exclude '*/README.md'
```
