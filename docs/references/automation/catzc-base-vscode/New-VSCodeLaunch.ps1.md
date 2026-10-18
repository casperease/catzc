# automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders .vscode/launch.json content from the vscode-launch registry — the debug launch profiles the
editor offers.

### description

Reads the authored launch-profile registry (configs/vscode-launch.yml, via Get-Config -Config
vscode-launch, which maps and validates it as a VscodeLaunchConfig) and renders it to the launch.json content: the version and
configurations as JSON, in registry order, without a head (Build-RootConfig writes the generated-file head as a JSONC comment
head, which VS Code reads in launch.json). The per-profile explanations live as comments in the yml — the
authored, searched artifact — not in the rendering.

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
root-config registry names for the .vscode/launch.json target, and Build-RootConfig owns the write.
See [ADR-REPO-ROOTCFG](../../../adr/repository/generated-root-configs.md).

### outputs

`[string]` The rendered launch.json content (LF-joined; the writer canonicalises).

### example 1

```powershell
New-VSCodeLaunch
```
