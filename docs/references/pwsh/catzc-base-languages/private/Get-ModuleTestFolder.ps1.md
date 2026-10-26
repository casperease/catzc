# pwsh/Base.Languages/private/Get-ModuleTestFolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The name of a module's test folder for a language: its folder name, in the language's folder case.

### description

A module's folder drops the namespace its track declares
([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)), so the first track whose namespace prefixes the
module's full name gives the folder; a name no track's namespace prefixes is its own folder. The languages config then renders that folder
in the language's folder case.

### parameter `Language`

The language whose test folder is named, as languages.yml names it (`python`, `go`, ...).

### parameter `Module`

The module's full name (`Catzc.Base.Widgets`), or a folder name no track's namespace prefixes.

### outputs

`[string]` The test folder's name.

### example 1

```powershell
Get-ModuleTestFolder python Catzc.Base.Repository
```

## comment:1

Above `$folder = $Module`, written with `#`.

```text
A module's test folder is named from its folder, which drops the namespace its track declares, in the language's folder
case; a name no track's namespace prefixes is its own folder.
```
