---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/configs/vscode-launch.yml.md
    folder: docs/references/automation/catzc-base-vscode/configs
    name: vscode-launch-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e26c6cd7e8c3
---

# automation/Catzc.Base.VSCode/configs/vscode-launch.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `version: "0.2.0"`, written with `#`.

```text
VS Code launch-profile registry — the single authored source for .vscode/launch.json. The file the editor
reads is a managed, gitignored copy rendered from this registry by New-VSCodeLaunch (wired through
Build-RootConfig; see rootconfig.yml and [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)) — edit THIS file,
never launch.json. Explanations live here as comments; the rendered JSON carries only a generated-file
header (VS Code reads JSONC, so the header is legal).

Loaded via Get-Config -Config vscode-launch and validated by the VscodeLaunchConfig type: a version
string plus a non-empty configurations list, each entry carrying name/type/request, names unique.
```

## comment:2

Above `- name: Debug Module`, written with `#`.

```text
Debug the module system end to end: dot-source the importer under the PowerShell debugger, from the
repository root, so breakpoints in any module function bind.
```
