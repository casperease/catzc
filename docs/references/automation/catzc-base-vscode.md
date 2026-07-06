# Catzc.Base.VSCode

The declarative editor-config module. It owns the rule that **the editor is glued to the tooling**: every file in `.vscode/` —
`settings.json`, `extensions.json`, `launch.json`, the Azure Pipelines schema, and the markdown-preview CSS — is a gitignored, generated
artifact derived from an authored source in this module, so the editor's behaviour cannot drift from the tooling it mirrors (see
[generated-root-configs](../../adr/repository/generated-root-configs.md)). What it deliberately does **not** own is the materialisation: the
renderers are pure functions that return content and write nothing; the `.vscode/` targets are managed entries written by
[Catzc.Base.RootConfig](catzc-base-rootconfig.md)'s `Build-RootConfig`, which names each renderer as its entry's generator (the CSS is a
`copyAsLink` entry — the `.vscode/` file is a link to this module's asset).

## Domains

| Domain   | Area     | Name                                                     |
| -------- | -------- | -------------------------------------------------------- |
| domain:1 | render   | [Editor-file rendering](#domain1--editor-file-rendering) |
| domain:2 | registry | [The editor registries](#domain2--the-editor-registries) |

### domain:1 — Editor-file rendering

Turning the registries into the `.vscode/` contents. Three renderers emit a generated-file header (JSONC — VS Code reads comments in
`settings.json`, `extensions.json`, and `launch.json`) followed by the authored content as JSON, in registry order; the fourth, the Azure
Pipelines schema, is consumed by the extension's validator as **strict** JSON, so its provenance marker is a `$comment` key rather than a
`//` header. Settings rendering performs the one render-time completion: every managed target passed by the caller joins `search.exclude`,
an authored entry winning over an injected key of the same name (an explicit `false` un-exclude survives). Extensions, launch, and the
pipeline schema render their registries verbatim — the generators are the seam should any ever need dynamic content. The authored
explanations live as comments in the yml — the searched, reviewed artifact — not in the renderings.

### domain:2 — The editor registries

Which editor behaviour the workspace pins, and why. Four registries, each entry carrying its rationale as a comment:

- `vscode-settings.yml` — a free-form `settings:` mapping of VS Code keys (loaded raw — there is no repository-side shape to validate
  against the editor's own schema) — notably the PowerShell `codeFormatting` block that must stay in step with
  `PSScriptAnalyzerSettings.psd1`, and the authored `search.exclude` map for the generated manifests. The managed-targets completion is
  deliberately **not** in this registry: it is injected by [Catzc.Base.RootConfig](catzc-base-rootconfig.md)'s generator dispatch from its
  own registry, so the list lives once and the dependency edge stays one-way (RootConfig → VSCode; a renderer never reads `rootconfig.yml`).
- `vscode-extensions.yml` — the recommended-extension ids, **binding**: validated on load by the private convention validator
  (`Assert-VscodeExtensionsConfig` — non-empty, unique `publisher.name` ids).
- `vscode-launch.yml` — the debug launch profiles, **binding**: validated on load (`Assert-VscodeLaunchConfig` — a version plus profiles
  each carrying `name`/`type`/`request`, names unique).
- `vscode-pipeline-schema.yml` — the repo-controlled Azure Pipelines JSON Schema (loaded raw — free-form JSON-Schema keys), authored to
  replace the extension's bundled per-task `anyOf` so the offline "does not match the pattern of `^PowerShell@2$`" false positives disappear
  while the structural checks worth keeping remain. Wired to the extension by `azure-pipelines.customSchemaFile` in `vscode-settings.yml`.

The module also ships the one non-JSON editor asset, `assets/markdown-preview-dark.css`, whose generated marker is authored in the source
itself (a `/* */` block) since the copy-in injects no header.

## What the module does

The module makes the workspace's editor behaviour a declared, explained artifact that cannot drift from the tooling it mirrors. All five
`.vscode/` targets are `committed: false` in the root-config registry: gitignored (the editor greys them), reproduced on every import, and
absent until a fresh clone's first import — the same contract as the generated cspell dictionaries. Editing a `.vscode/` file is editing a
build output the next import overwrites; the yml registries and the CSS asset are where changes go.

The injected `search.exclude` completion is the point of the design: the repository's managed files (the root-config copy-ins, the generated
committed files, and the `.vscode/` copies themselves) are derived artifacts, and a search that lands in one invites an edit that the next
import silently overwrites. With the exclusion list computed from the same registry that defines "managed", opting a file into management
removes it from find-all in the same change — the editor and the tooling cannot disagree, and there is no hand-kept second list. It is the
same one-source-injection shape as [Catzc.Base.Git](catzc-base-git.md)'s managed-copies zone.

## Division

The module's public surface, sorted into the domains above.

| Domain                           | Function                     |
| -------------------------------- | ---------------------------- |
| domain:1 — Editor-file rendering | `New-VSCodeSettings`         |
|                                  | `New-VSCodeExtensions`       |
|                                  | `New-VSCodeLaunch`           |
|                                  | `New-VSCodePipelineSchema`   |
| domain:2 — The editor registries | `vscode-settings.yml`        |
|                                  | `vscode-extensions.yml`      |
|                                  | `vscode-launch.yml`          |
|                                  | `vscode-pipeline-schema.yml` |
