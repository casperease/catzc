# pwsh/Base.Languages/Get-PathFileType.ps1

`Get-PathFileType` returns the file type of a path: the last extension of its file name, lowercase, without the dot. It separates the file
types inside one file language, which `Get-FileLanguage` names by the extension.

## help

### synopsis

Returns the file type of a path, the extension of its file name without the dot.

### description

The file type says which sort of file inside its file language this is: `ps1`, `psm1` and `psd1` are all PowerShell, `yml` and `yaml` are
different file types of the YAML family. It is the last extension of the file name, lower case. A file with no extension, a dotfile such as
`.gitkeep`, and a name that ends in a dot have none: nothing is returned
([DDR-TRACK-FILELANGUAGE](../../../drs/design/tracks.md#rule-ddr-track-filelanguage)).

### parameter `Path`

A repository-relative or absolute path ('/' or '\' separated).

### outputs

`[string]` The extension without its dot, in lower case, or nothing.

### example 1

```powershell
(Get-PathFileType 'pwsh/.internal/Catzc.Internal.Types.psm1')   # -> psm1
```

### example 2

```powershell
(Get-PathFileType 'docs/references/Get-Foo.ps1.md')                   # -> md
```
