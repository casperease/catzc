---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/New-VSCodeLaunch.ps1.md
    kind: reference
    body_sha: "4e8b280744d0"
    adrs: []
---

# automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the authored launch-profile registry (configs/vscode-launch.yml, via Get-Config -Config
vscode-launch, which maps and validates it as a VscodeLaunchConfig) and renders it to the launch.json content: a
generated-file header (JSONC — VS Code reads comments in launch.json) followed by the version and
configurations as JSON, in registry order. The per-profile explanations live as comments in the yml — the
authored, searched artifact — not in the rendering.

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
root-config registry names for the .vscode/launch.json target, and Build-RootConfig owns the write.
See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
```
