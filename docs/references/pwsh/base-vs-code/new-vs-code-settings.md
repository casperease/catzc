# pwsh/Base.VSCode/New-VsCodeSettings.ps1

The renderer of `.vscode/settings.json` from the `vscode-settings` registry, completed with the machine-resolved settings, the formatters,
the lamps' filters and the `.editorconfig` baseline.

## help

### synopsis

Renders .vscode/settings.json content from the vscode-settings registry — the glue that keeps the editor's behaviour in sync with the
tooling.

### description

Reads the authored settings registry (configs/vscode-settings.yml, via Get-Config -Config vscode-settings — the validated
VscodeSettingsConfig, whose read-only `settings` map it renders from a copy) and renders it to the settings.json content: the settings as
JSON, in registry order, without a head (Build-RootConfig writes the generated-file head as a JSONC comment head, which VS Code reads in
settings.json). The explanations live as comments in the yml — the authored, searched artifact — not in the rendering.

The one render-time completion is `search.exclude`: every path in -ManagedTarget (the root-config registry's opted-in targets, supplied by
Build-RootConfig's generator dispatch) is added to the map, so find-all always lands on the source of truth and never on a generated copy.
An authored entry wins over an injected key of the same name (an explicit `false` stays un-excluded).

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the root-config registry names for the
.vscode/settings.json target, and Build-RootConfig owns the write. It reads only its own registry, never rootconfig.yml, so the dependency
edge stays one-way (RootConfig -> VSCode; see [ADR-REPO-ROOTCFG](../../../drs/repository/generated-root-configs.md)).

### parameter `ManagedTarget`

The managed root-config target paths to complete `search.exclude` with (repo-root-relative). Supplied by the generator dispatch; empty
renders the authored settings alone.

### parameter `MachineSetting`

Settings resolved on this machine at render time, added after the authored ones (an authored key wins). Supplied by the generator dispatch:
`go.goroot`, the managed Go toolchain, so the Go extension and gopls run the pinned go rather than whichever go comes first on PATH; and
`python.defaultInterpreterPath`, the Python test project's environment in this platform's layout. settings.json is a gitignored, per-machine
copy, so a machine path is in place there.

### parameter `LanguageFormatter`

The editor formatter of each language, VS Code language id -> extension id, rendered as that language's `[<id>].editor.defaultFormatter`.
Supplied by the generator dispatch from the file-language registry, so Format Document runs the engine Format-Code runs
([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)); an
authored `[<id>]` block keeps its own settings, and an authored defaultFormatter in it wins.

### parameter `RepositoryFilter`

The repository's filters, name to the include and exclude sets each claims by, in lamp order (Get-RepositoryFilter), rendered as
`catzc.trackLamps.filters` so the lamps read what they hide from the settings alone; none when empty.

### parameter `LampLanguage`

The tagged languages the lamps offer, name to its tag and extensions, in the languages config's order, rendered as
`catzc.trackLamps.languages`; none when empty.

### parameter `CurrentPath`

The settings file on disk, read for the rows another writer owns: each `carried` setting of vscode-settings.yml keeps the rows its owner key
lists, and the owner key itself, so a regenerated file keeps the lamps' working view. Default: `.vscode/settings.json` under the repository
root.

### parameter `EditorConfigPath`

The .editorconfig whose sections render into the editor settings, vscode-settings.yml's `editorconfig` mapping them to languages
(ConvertFrom-EditorConfig). Default: `.editorconfig` under the repository root.

### outputs

`[string]` The rendered settings.json content (LF-joined; the writer canonicalises).

### example 1

```powershell
New-VsCodeSettings -ManagedTarget '/PSScriptAnalyzerSettings.psd1', 'importer.ps1'
```

## What completes the authored settings

An authored setting wins over a rendered one on a shared key, and every merge is sorted, so the render is stable.

- **Machine-resolved settings** complete the authored ones.
- **The `.editorconfig` baseline**, read from `-EditorConfigPath`, lets the editor follow it with no extension; the `editorconfig` map of
  `vscode-settings.yml` maps its sections to languages.
- **Each language's editor formatter** is merged into its `[<id>]` block, where authored keys in the block win.
- **The lamps' filters** (`-RepositoryFilter`, from `Get-RepositoryFilter`: name to the include and exclude sets each claims by, in lamp
  order) and each language's extensions are written into the settings, because the lamps read what they hide from the settings, so the
  extension needs neither a config nor a session.
- **Carried rows**: a carried map keeps the rows another writer added (the lamps' `files.exclude`), as listed under that writer's owner key
  in the settings file on disk (`-CurrentPath`); a row the registry authors stays the registry's.
