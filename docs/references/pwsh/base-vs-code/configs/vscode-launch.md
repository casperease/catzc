# pwsh/Base.VSCode/configs/vscode-launch.yml

The VS Code launch-profile registry: the one authored file that `.vscode/launch.json` is rendered from. Edit this file, never `launch.json`.

## Rendering and validation

The file the editor reads is a managed, gitignored copy rendered from this registry by `New-VsCodeLaunch` (wired through `Build-RootConfig`;
see `rootconfig.yml` and [ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md)). Explanations live in the registry as
comments; the rendered JSON carries only a generated-file header, which is legal since VS Code reads JSONC.

`Get-Config -Config vscode-launch` loads it and the `VscodeLaunchConfig` type validates it: a version string plus a non-empty
`configurations` list, each entry carrying `name`, `type` and `request`, with unique names.

## Profiles

**Debug Module** debugs the module system end to end: it dot-sources the importer under the PowerShell debugger, from the repository root,
so breakpoints in any module function bind.
