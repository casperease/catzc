# Catzc.Base.VSCode

The declarative editor-settings module. It owns the rule that **the editor is glued to the tooling**: `.vscode/settings.json` is rendered
from an authored yml registry (`vscode-settings.yml`) and completed at render time with the managed root-config targets, so find-all always
lands on a source of truth and never on a generated copy (see [generated-root-configs](../../adr/repository/generated-root-configs.md)).
What it deliberately does **not** own is the materialisation: `New-VSCodeSettings` is a pure renderer that returns content and writes
nothing; the `settings.json` target is a managed, committed root file written by [Catzc.Base.RootConfig](catzc-base-rootconfig.md)'s
`Build-RootConfig`, which names `New-VSCodeSettings` as that entry's generator.

## Domains

| Domain   | Area     | Name                                                     |
| -------- | -------- | -------------------------------------------------------- |
| domain:1 | render   | [Settings rendering](#domain1--settings-rendering)       |
| domain:2 | registry | [The settings registry](#domain2--the-settings-registry) |

### domain:1 — Settings rendering

Turning the settings registry into the `settings.json` content. This domain renders a generated-file header (JSONC — VS Code reads comments
in `settings.json`) followed by the authored settings as JSON, in registry order, and performs the one render-time completion: every managed
target passed by the caller joins `search.exclude`, an authored entry winning over an injected key of the same name (an explicit `false`
un-exclude survives). The authored explanations live as comments in the yml — the searched, reviewed artifact — not in the rendering.

### domain:2 — The settings registry

Which editor behaviour the workspace pins, and why. The registry is `vscode-settings.yml`: a free-form `settings:` mapping of VS Code keys
(loaded raw — there is no repository-side shape to validate against the editor's own schema), each carrying its rationale as a comment —
notably the PowerShell `codeFormatting` block that must stay in step with `PSScriptAnalyzerSettings.psd1`, and the authored
`search.exclude`/`files.watcherExclude` maps for the generated manifests. The managed-targets completion is deliberately **not** in this
registry: it is injected by [Catzc.Base.RootConfig](catzc-base-rootconfig.md)'s generator dispatch from its own registry, so the list lives
once and the dependency edge stays one-way (RootConfig → VSCode; the renderer never reads `rootconfig.yml`).

## What the module does

The module is small and single-purpose: it makes the workspace's editor behaviour a declared, explained artifact that cannot drift from the
tooling it mirrors. The settings file VS Code reads is `committed: true` in the root-config registry — the editor consumes it whenever the
workspace opens, import or no import — so a fresh clone gets correct editor behaviour immediately, the importer merely keeps it current, and
a registry change surfaces as a normal reviewable diff.

The injected `search.exclude` completion is the point of the design: the repository's managed files (the root-config copy-ins and the
generated committed files alike) are derived artifacts, and a search that lands in one invites an edit that the next import silently
overwrites. With the exclusion list computed from the same registry that defines "managed", opting a file into management removes it from
find-all in the same change — the editor and the tooling cannot disagree, and there is no hand-kept second list. It is the same
one-source-injection shape as [Catzc.Base.Git](catzc-base-git.md)'s managed-copies zone.

## Division

The module's public surface, sorted into the domains above.

| Domain                           | Function              |
| -------------------------------- | --------------------- |
| domain:1 — Settings rendering    | `New-VSCodeSettings`  |
| domain:2 — The settings registry | `vscode-settings.yml` |
