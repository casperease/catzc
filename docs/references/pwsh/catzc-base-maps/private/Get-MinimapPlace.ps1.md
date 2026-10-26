# pwsh/Catzc.Base.Maps/private/Get-MinimapPlace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads the place a file sits in: its track, its module and the folder inside the module.

### description

A place is `[track, module, folder]`, the triple the code-locations minimap draws. The file's path is normalised as a repository-relative
path (ADR-AUTO-PATH), and the module and the folder are read from where the file sits, never from its head.

### parameter `Path`

The file's repository-relative path.

### parameter `Facts`

The file's facts (Get-MinimapFact): its track and the module that holds it.

### outputs

`[string[]]` The track, the module (`-` for none) and the folder (`.` for the module's own root).

### example 1

```powershell
Get-MinimapPlace -Path pwsh/Catzc.Azure/configs/azure.yml -Facts @{ track = 'pwsh'; module = 'Catzc.Azure' }
```

## comment:1

Above `$module = if ($Facts['module'] -and "$($Facts['module'])" -ne $track) {`, written with `#`.

```text
A place is [track, module, folder]: '-' for no module, and '.' for the module's own root; a folder inside the module is the path
between the module's folder and the file.
```

## comment:2

Above `$module = if ($Facts['module'] -and "$($Facts['module'])" -ne $track) {`, written with `#`.

```text
A module that only repeats its track (`.claude` in `.claude`) is no module: the place is the track and the folder
the file sits in.
```
