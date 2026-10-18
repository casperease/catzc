# automation/Catzc.Base.Files/Copy-Directory.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Recursively copies the contents of a directory into a destination directory.

### description

A fast replacement for `Copy-Item -Recurse`, built on `[System.IO]`. The PowerShell file cmdlets carry heavy per-item provider overhead on
Windows (~15x slower per file/dir here), which dominates when copying a tree of many small files; the raw .NET APIs avoid it.

Mirrors the tree under -Path into -Destination — the equivalent of `Copy-Item (Join-Path $Path '*') $Destination -Recurse`. The destination
is created if it does not exist, files are overwritten, and empty subdirectories are preserved.

### parameter Path

The source directory whose contents are copied. Must exist.

### parameter Destination

The target directory the contents are copied into (created if missing).

### example 1

```powershell
Copy-Directory $fixtureTemplates $sandbox
```

## comment:1

Above `foreach ($dir in Get-ChildPath $source -Directory -Depth 64 -Exclude @()...`, written with `#`.

```text
Recreate the directory structure first (so empty directories survive), then copy the files.
Each enumerated path starts with $source, so substring-after-prefix rebases it under $target
(safer than String.Replace, which would rewrite any other occurrence of the prefix).
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a copy
takes everything, so no name is pruned and no depth drops a file.
```
