# Catzc.Base.VSCode

The declarative editor-config module. It owns the rule that **the editor is glued to the tooling**: every file in `.vscode/` —
`settings.json`, `extensions.json`, `launch.json`, the Azure Pipelines schema, and the markdown-preview CSS — is a gitignored, generated
artifact derived from an authored source in this module, so the editor's behaviour cannot drift from the tooling it mirrors (see
[generated-root-configs](../../../drs/repository/generated-root-configs.md)). What it deliberately does **not** own is the materialisation: the
renderers are pure functions that return content and write nothing; the `.vscode/` targets are managed entries written by
[Catzc.Base.RootConfig](../base-root-config/index.md)'s `Build-RootConfig`, which names each renderer as its entry's generator (the CSS is a
`source` entry — the `.vscode/` file is a headed copy of this module's asset).

## Responsibilities

| Responsibility   | Area     | Name                                                                            |
| ---------------- | -------- | ------------------------------------------------------------------------------- |
| responsibility:1 | render   | [Editor-file rendering](#responsibility1--editor-file-rendering)                |
| responsibility:2 | registry | [The editor registries](#responsibility2--the-editor-registries)                |
| responsibility:3 | session  | [The session's own binding](#responsibility3--the-sessions-own-binding)         |
| responsibility:4 | package  | [The cats extensions' packages](#responsibility4--the-cats-extensions-packages) |

### responsibility:1 — Editor-file rendering

Turning the registries into the `.vscode/` contents. Three renderers emit a generated-file header (JSONC — VS Code reads comments in
`settings.json`, `extensions.json`, and `launch.json`) followed by the authored content as JSON, in registry order; the fourth, the Azure
Pipelines schema, is consumed by the extension's validator as **strict** JSON, so its provenance marker is a `$comment` key rather than a
`//` header. Settings rendering performs the render-time completions, an authored entry always winning over a rendered one: every managed
target passed by the caller joins `search.exclude` (an explicit `false` un-exclude survives); the `.editorconfig` sections render into the
editor's top-level and per-language settings; and the lamps' filters and tagged languages render into the lamps' own settings, so an
extension reads catzc's configs through the settings alone. Extensions, launch, and the pipeline schema render their registries verbatim —
the generators are the seam should any ever need dynamic content. The authored explanations live as comments in the yml — the searched,
reviewed artifact — not in the renderings.

### responsibility:2 — The editor registries

Which editor behaviour the workspace pins, and why. Four registries, each entry carrying its rationale as a comment:

- `vscode-settings.yml` — a `settings:` mapping of VS Code's own keys, passed through to the editor as-is; its config type
  (`VscodeSettingsConfig`) checks only the structure (a non-empty map, each language override a map, `search.exclude` a map of glob to
  boolean) — notably the PowerShell `codeFormatting` block that must stay in step with `PSScriptAnalyzerSettings.psd1`, and the authored
  `search.exclude` map for the generated manifests. The managed-targets completion is deliberately **not** in this registry: it is injected
  by [Catzc.Base.RootConfig](../base-root-config/index.md)'s generator dispatch from its own registry, so the list lives once and the
  dependency edge stays one-way (RootConfig → VSCode; a renderer never reads `rootconfig.yml`).
- `vscode-extensions.yml` — the recommended-extension ids, **binding**: validated on load by its config type (`VscodeExtensionsConfig` —
  non-empty, unique `publisher.name` ids).
- `vscode-launch.yml` — the debug launch profiles, **binding**: validated on load by its config type (`VscodeLaunchConfig` — a version plus
  profiles each carrying `name`/`type`/`request`, names unique).

The module also ships the one non-JSON editor asset, `assets/markdown-preview-dark.css`, whose generated marker is authored in the source
itself (a `/* */` block) since the copy-in injects no header.

### responsibility:3 — The session's own binding

What a pwsh session inside VS Code can say about itself, from the inside. A session is bound to the one types instance it loaded
([hosting-csharp-types](../../../drs/automation/pwsh/hosting-csharp-types.md), ADR-PWSH-TYPES-ONEINSTANCEPERSESSION), and the sources change
under it many times a day, so the question "which instance am I on, and what holds the others" is asked of the session itself, never of
another process. The answer is one typed record (`VscodeSession`): the host (the extension's own session or an integrated terminal), the
loaded and the sources' hash with the drift between them, the committed builds and the processes holding each, the environment variables the
editor and its extensions contributed, and the editor's newest log session with the extension log's start and stop lines. The command
refuses to run outside VS Code (`Assert-IsRunningInVsCode`).

### responsibility:4 — The cats extensions' packages

Turning each cats extension into a package the editor installs. The extensions themselves are modules of the `js` track
([javascript-track](../../../drs/automation/javascript/javascript-track.md)); this module owns only what depends on catzc: the manifest
rendered from the extensions registry (its repeats expanded over a catzc config, its colours resolved from the lamp palette), the lamp
glyphs recoloured per condition and the label glyphs drawn per repeated item, the icon theme rendered from `file-icons.yml`, packing, and
installing. It reaches an extension through its rendered manifest and settings, never through its code.

## What the module does

The module makes the workspace's editor behaviour a declared, explained artifact that cannot drift from the tooling it mirrors. All five
`.vscode/` targets are `committed: false` in the root-config registry: gitignored (the editor greys them), reproduced on every import, and
absent until a fresh clone's first import — the same contract as the generated cspell dictionaries. Editing a `.vscode/` file is editing a
build output the next import overwrites; the yml registries and the CSS asset are where changes go.

The injected `search.exclude` completion is the point of the design: the repository's managed files (the root-config copy-ins, the generated
committed files, and the `.vscode/` copies themselves) are derived artifacts, and a search that lands in one invites an edit that the next
import silently overwrites. With the exclusion list computed from the same registry that defines "managed", opting a file into management
removes it from find-all in the same change — the editor and the tooling cannot disagree, and there is no hand-kept second list. It is the
same one-source-injection shape as [Catzc.Base.Git](../base-git/index.md)'s managed-copies section.

## Division

The module's public surface, sorted into the responsibilities above.

| Responsibility                                   | Function                  |
| ------------------------------------------------ | ------------------------- |
| responsibility:1 — Editor-file rendering         | `New-VsCodeSettings`      |
|                                                  | `New-VsCodeExtensions`    |
|                                                  | `New-VsCodeLaunch`        |
|                                                  | `New-VsCodeTasks`         |
| responsibility:2 — The editor registries         | `vscode-settings.yml`     |
|                                                  | `vscode-extensions.yml`   |
|                                                  | `vscode-launch.yml`       |
|                                                  | `vscode-tasks.yml`        |
| responsibility:3 — The session's own binding     | `Get-VsCodeSession`       |
| responsibility:4 — The cats extensions' packages | `Build-VsCodeExtension`   |
|                                                  | `Install-VsCodeExtension` |
