---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/configs/vscode-launch.yml.md
    kind: comment-page
    body_sha: "79242c5e053d"
    adrs: []
---

# automation/Catzc.Base.VSCode/configs/vscode-launch.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `version: "0.2.0"`.

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

Above `- name: Debug Module`.

```text
Debug the module system end to end: dot-source the importer under the PowerShell debugger, from the
repository root, so breakpoints in any module function bind.
```
