# pwsh/Base.Languages/Set-GeneratedFileHead.ps1

`Set-GeneratedFileHead` stamps the head on a file its writer has already written, so a writer outside PowerShell, such as a Python one,
calls the one head renderer and never a copy of it (ADR-REPO-FILEMETA-COMPOSEDFILES).

## help

### synopsis

Stamps the generated-file head on a file its writer has written, filled from the writer's row of the writer registry.

### description

Reads the file and renders its head through `Format-GeneratedFileHead` with the writer's name, which reads the writer's row and finds the
file's carrier entry in file-carriers.yml through `FileCarrierResolver` (an entry whose globs match the path wins, otherwise the entry of its
file language), and writes it back only when it changes. A png is stamped as bytes, every other file as text with its own line ends. A path no entry names is
refused.

### parameter `Path`

The file to stamp, by its repository-relative path.

### parameter `Writer`

The name of the writer row that writes the file, which exactly one row of the registry declares.

### example 1

```powershell
Set-GeneratedFileHead -Path docs/.assets/widget.drawio.png -Writer Build-Diagrams
```

## Bytes or text

The png signature in the file's first bytes picks the bytes form, and the carrier entry must agree.
