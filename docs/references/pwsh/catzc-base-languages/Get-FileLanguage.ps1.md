# pwsh/Catzc.Base.Languages/Get-FileLanguage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the repository's file languages — all of them, the named ones, or the one a file is written in.

### description

The file-language registry (configs/languages.yml, validated by the LanguagesConfig type) names each language a tracked file is written in
by its extensions ([DDR-TRACK-FILELANGUAGE](../../../drs/design/tracks.md#rule-ddr-track-filelanguage)), with the formatter engine that
formats it (or why it has none) and its ADR folder. Each result is a FileLanguage, in declared order.

-Path answers "which file language is this file?" by its extension, case-insensitively. A file whose extension no language lists, a file
with no extension, and a dotfile such as .gitkeep return nothing; -Path never throws.

### parameter `Name`

The file-language name(s) to return. An unknown name throws, naming the config file.

### parameter `Path`

A file path (repository-relative or absolute); returns the file language its extension names.

### example 1

```powershell
Get-FileLanguage
```

### example 2

```powershell
(Get-FileLanguage -Name markdown).formatter                              # -> prettier
```

### example 3

```powershell
(Get-FileLanguage -Path 'pwsh/Catzc.Base.Languages/Get-FileLanguage.ps1').name   # -> powershell
```
