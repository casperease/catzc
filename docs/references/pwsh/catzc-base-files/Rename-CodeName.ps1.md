# pwsh/Base.Files/Rename-CodeName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renames commands, types, parameters and file names across the tracked files, by a map of old to new names.

### description

The one repository command for a rename that reaches many files, so every in-tree caller moves with the name in the same change and no alias
is kept ([PDR-ONELIVE](../../../drs/principles/one-living-version.md)). It reads every text file `Get-GitTrackedPath` lists under -Path and
replaces each old name of -Map with its new name where the name stands as a whole token: never after a letter, digit, `_` or `-`, and never
before one. So `WidgetConfig` is renamed in `[Catzc.Widget.WidgetConfig]` but not in `GadgetWidgetConfig` or `WidgetConfigs`. Names are
matched case-sensitively and the longest first, so a name that contains another is replaced whole. A parameter is given with its dash
(`-WidgetRoot`), and a file name with its extension (`widget.yml`). Each file keeps its line endings and its byte order mark. A binary file
(one holding a NUL character), a tracked file deleted from the working tree and a path under -Exclude are left alone. It moves no file: a
file whose name changes is moved on disk beside the call.

### parameter `Map`

The old name to new name of each rename. Every row needs a non-empty old name and a different, non-empty new name.

### parameter `Path`

The repository-relative, '/'-separated paths whose tracked files are read; '.' (the default) for all.

### parameter `Exclude`

Repository-relative path prefixes left alone. Defaults to the session learnings and the hindsight log, which record history.

### parameter `DryRun`

Reports what would change and writes nothing.

### outputs

`[pscustomobject]` One row per file that holds an old name: its repository-relative `Path` and the `Count` of names replaced.

### example 1

```powershell
Rename-CodeName @{ 'Get-WidgetSet' = 'Get-GadgetSet'; 'WidgetConfig' = 'GadgetConfig' } -Path pwsh -DryRun
```

## comment:1

Above `$alternation = (@($lookup.Keys) | Sort-Object { $_.Length } -Descending |`, written with `#`.

```text
Longest first, so a name that contains another is replaced whole; a name matches only as a token, never inside a
longer one.
```

## comment:2

Above `$within = [regex]::new("[\w-]*(?:$alternation)[\w-]*")`, written with `#`.

```text
The longer tokens a name sits inside, such as an id `g-<name>`, are skipped by design; each is reported so the
caller decides.
```
