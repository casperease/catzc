# pwsh/Base.FileLimits/Build-WidthConfigs.ps1

The generator that fills a width-bearing tool config template with the widths the file-limits config declares.

## help

### synopsis

Renders a width-bearing tool config from its template, with every width the file-limits config declares.

### description

The template is the root asset of the same name in Catzc.Base.RootConfig. Each `$width.<extension>` token in it becomes the width
`Get-FileLimit` resolves for a file of that extension, so `.editorconfig`, prettier and markdownlint all read the one declared width.
Build-RootConfig calls it as the generator of the three targets and writes the result; it writes nothing itself.

### parameter `Target`

The root config to render: `.editorconfig`, `.prettierrc.yml` or `.markdownlint.yml`.

### outputs

`[string]` The filled content of the target.

### example 1

```powershell
Build-WidthConfigs -Target .editorconfig
```
