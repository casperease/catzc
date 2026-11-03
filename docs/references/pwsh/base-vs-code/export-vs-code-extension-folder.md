# pwsh/Base.VSCode/Export-VsCodeExtensionFolder.ps1

The bridge from a javascript module folder to the extension folder rendered from the registry.

## help

### synopsis

Renders the registered VS Code extension that a javascript module folder stands for, and returns the folder.

### description

Matches the module's folder name against the source folder of each extension in the vscode-extensions config and renders the first match
into the output directory with New-VsCodeExtensionFolder. A module that no registered extension names returns nothing.

### parameter `Module`

The module folder or path; only its last segment is matched.

### parameter `OutputDirectory`

The directory the extension folder is rendered into.

### outputs

`[string]` The rendered extension folder.

### example 1

```powershell
Export-VsCodeExtensionFolder -Module 'javascript/widget' -OutputDirectory $scratch
```
