# pwsh/Base.Languages/Export-JavaScriptModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Packages a javascript module into a destination folder, as source files or as a VS Code extension vsix.

### description

Copies the files git tracks for the module, tests excluded, in ordinal order. A module whose package.json declares the editor engine is an
extension: it is packed into one `<publisher>.<name>-<version>.vsix` with a fixed timestamp and sorted entries, so two exports are
byte-identical. A module that registers an extension and holds no package.json is rendered through Export-VsCodeExtensionFolder first. Any
other module ships as source. Returns the module, destination, form (`source` or `vsix`), file count and artifact path.

### parameter `Module`

The module folder, relative to the repository root or an absolute path under it.

### parameter `Destination`

The folder the module is packaged into; created when missing.

### parameter `Silent`

Suppresses the message that names the packaged module.

### example 1

```powershell
Export-JavaScriptModule -Module 'javascript/widget' -Destination $buildRoot/javascript/widget
```

## comment:1

Above `$rendered = $null`, written with `#`.

```text
An extension the repository registers carries no tracked package.json; its folder is rendered from the registry, the one
living version of the manifest, packed from memory, and the temporary render is removed at once.
```

## comment:2

Above `$files = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
Only what git tracks ships, and no test
([ADR-AUTO-BUNDLE-EVERYLANGUAGE](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-everylanguage)).
```

## comment:3

Above `$files.Sort([System.StringComparer]::Ordinal)`, written with `#`.

```text
Sorted ordinally, so a rebuild writes the same bytes
([ADR-AUTO-BUNDLE-IMMUTABLEBUILD](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild)).
```

## comment:4

Above `$stamp = [System.DateTimeOffset]::new(1980, 1, 1, 0, 0, 0,...`, written with `#`.

```text
A fixed timestamp and sorted entries make two exports byte-identical
([ADR-AUTO-BUNDLE-IMMUTABLEBUILD](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild)).
```
