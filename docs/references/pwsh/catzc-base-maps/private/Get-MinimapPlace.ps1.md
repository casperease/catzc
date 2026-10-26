# pwsh/Base.Maps/private/Get-MinimapPlace.ps1

The helper that reads the place of one file for the code-locations minimap: its track, its module and the folder inside the module.

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
Get-MinimapPlace -Path pwsh/Azure/configs/azure.yml -Facts @{ track = 'pwsh'; module = 'Catzc.Azure' }
```

## The triple

A place is `[track, module, folder]`. `-` stands for no module and `.` for the module's own root. A folder inside the module is the path
between the module's folder and the file.

## A module that repeats its track

A module that only repeats its track (`.claude` in `.claude`) is no module. The place is then the track and the folder the file sits in.
