# automation/Catzc.Base.VSCode/Install-VSCodeExtension.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Installs the repository's own editor extensions, the entries under extensions in vscode-extensions.yml, through the editor's CLI.

### description

Each extension is generated: New-VSCodeExtensionFolder renders it from its registry entry and its script in `assets/extensions/` to
`<Root>/<name>/`, Build-VSCodeExtension packs that folder, and `code --install-extension --force` installs it, so the editor writes
its own registry entry. An extension whose installed copy (`<publisher>.<name>-<version>` in the editor's
extensions folder) already holds every source file byte for byte is skipped, so the importer runs this on every load and only a
changed extension costs an install. An extension of the same name is replaced; the editor loads it on its next window reload.

A link from the editor's extensions folder into the repository is not the install: the editor would write the extension's files
through the link into the working tree. Remove such a link first.

### parameter Name

The extension names to install. Default: every entry under extensions in vscode-extensions.yml.

### parameter Root

The folder the extensions are rendered under. Default: the vscode-extensions folder under the output root.

### parameter ExtensionsDirectory

The editor's extensions folder, where an installed copy is compared. Default: ~/.vscode/extensions.

### parameter Force

Installs even an extension whose installed copy is current.

### outputs

`[string[]]` The .vsix files that were installed.

### example 1

```powershell
Install-VSCodeExtension
```

### example 2

```powershell
Install-VSCodeExtension -Name catzc-git-changes -Force
```
