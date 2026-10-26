# pwsh/Base.Files/Copy-Directory.ps1

The fast recursive directory copy: it mirrors the contents of one directory into another through `[System.IO]`.

## help

### synopsis

Recursively copies the contents of a directory into a destination directory.

### description

A fast replacement for `Copy-Item -Recurse`, built on `[System.IO]`. The PowerShell file cmdlets carry heavy per-item provider overhead on
Windows (~15x slower per file/dir here), which dominates when copying a tree of many small files; the raw .NET APIs avoid it.

Mirrors the tree under -Path into -Destination — the equivalent of `Copy-Item (Join-Path $Path '*') $Destination -Recurse`. The destination
is created if it does not exist, files are overwritten, and empty subdirectories are preserved.

### parameter `Path`

The source directory whose contents are copied. Must exist.

### parameter `Destination`

The target directory the contents are copied into (created if missing).

### example 1

```powershell
Copy-Directory $fixtureTemplates $sandbox
```

## How the copy walks

The directory structure is recreated first, so empty directories survive, and then the files are copied. Each enumerated path starts with the
source, so cutting off that prefix and appending the rest to the target rebases it; this is safer than `String.Replace`, which would rewrite
any other occurrence of the prefix inside a path.

The walk is a named whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): a copy takes
everything, so no name is pruned and no depth drops a file.
