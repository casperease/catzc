# pwsh/Catzc.Base.Languages/Get-PathFileType.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the file type of a path, the extension of its file name without the dot.

### description

The file type says which sort of file inside its file language this is: `ps1`, `psm1` and `psd1` are all PowerShell, `yml` and `yaml` are
different file types of the YAML family. It is the last extension of the file name, lower case. A file with no extension, a dotfile such as
`.gitkeep`, and a name that ends in a dot have none: nothing is returned
([DDR-TRACK-FILELANGUAGE](../../../adr/design/tracks.md#rule-ddr-track-filelanguage)).

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
