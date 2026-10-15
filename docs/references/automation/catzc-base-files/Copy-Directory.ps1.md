---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Copy-Directory.ps1.md
    kind: comment-page
    body_sha: "56b5c4842b73"
    adrs: []
---

# automation/Catzc.Base.Files/Copy-Directory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A fast replacement for `Copy-Item -Recurse`, built on [System.IO]. The PowerShell file
cmdlets carry heavy per-item provider overhead on Windows (~15x slower per file/dir here),
which dominates when copying a tree of many small files; the raw .NET APIs avoid it.

Mirrors the tree under -Path into -Destination — the equivalent of
`Copy-Item (Join-Path $Path '*') $Destination -Recurse`. The destination is created if it
does not exist, files are overwritten, and empty subdirectories are preserved.
```

## comment:2

Above `foreach ($dir in [System.IO.Directory]::EnumerateDirectories($source, '*',...`.

```text
Recreate the directory structure first (so empty directories survive), then copy the files.
Each enumerated path starts with $source, so substring-after-prefix rebases it under $target
(safer than String.Replace, which would rewrite any other occurrence of the prefix).
```
