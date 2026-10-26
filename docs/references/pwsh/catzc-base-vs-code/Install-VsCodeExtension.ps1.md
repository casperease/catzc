# pwsh/Base.VSCode/Install-VsCodeExtension.ps1

The command that installs the repository's own editor extensions through the editor's CLI, and skips the ones already current.

## help

### synopsis

Installs the repository's own editor extensions, the entries under extensions in vscode-extensions.yml, through the editor's CLI.

### description

Each extension is generated: New-VsCodeExtensionFolder renders it from its registry entry and its script in `assets/extensions/` to
`<Root>/<name>/`, Build-VsCodeExtension packs that folder, and `code --install-extension --force` installs it, so the editor writes its own
registry entry. An extension whose installed copy (`<publisher>.<name>-<version>` in the editor's extensions folder) already holds every
source file byte for byte is skipped, so the importer runs this on every load and only a changed extension costs an install. An extension of
the same name is replaced; the editor loads it on its next window reload.

A link from the editor's extensions folder into the repository is not the install: the editor would write the extension's files through the
link into the working tree. Remove such a link first.

### parameter `Name`

The extension names to install. Default: every entry under extensions in vscode-extensions.yml.

### parameter `Root`

The folder the extensions are rendered under. Default: the vscode-extensions folder under the output root.

### parameter `ExtensionsDirectory`

The editor's extensions folder, where an installed copy is compared. Default: ~/.vscode/extensions.

### parameter `Force`

Installs even an extension whose installed copy is current.

### outputs

`[string[]]` The .vsix files that were installed.

### example 1

```powershell
Install-VsCodeExtension
```

### example 2

```powershell
Install-VsCodeExtension -Name catzc-git-changes -Force
```

## When an extension is current

The folders are judged once for every extension, so one rendered extension never makes the next look current while it is stale. A current
stamp is only ever stored after every extension installed cleanly, so an unchanged folder with its copy present is that copy; the
file-by-file comparison is for a folder rendered now. The editor writes its own `__metadata` into the installed `package.json`, so the
manifest is compared without it.
