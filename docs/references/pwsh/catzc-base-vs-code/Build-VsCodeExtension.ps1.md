# pwsh/Catzc.Base.VSCode/Build-VsCodeExtension.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Packs one extension folder, the one that holds a package.json, into a .vsix the editor installs.

### description

A .vsix is a zip of the folder under `extension/`, with an `extension.vsixmanifest` that names the identity (publisher, name, version) and
the editor engine, and a `[Content_Types].xml` that types each file extension. This writes that zip from the folder's package.json alone, so
no node tooling is needed, and the editor writes its own registry entry when it installs the file.

The package is written to `<output>/vsix/<name>-<version>.vsix` and replaces an older file of that name.

### parameter `Path`

The extension folder, absolute or relative to the repository root. It must hold a package.json with name, version and publisher.

### parameter `OutputDirectory`

The folder the .vsix is written to. Default: the vsix folder under the output root.

### outputs

`[string]` The full path of the .vsix.

### example 1

```powershell
Build-VsCodeExtension out/vscode-extensions/catzc-git-changes
```
