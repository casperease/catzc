# docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md

`automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the authored settings registry (configs/vscode-settings.yml, via Get-Config -Config
vscode-settings — the validated VscodeSettingsConfig, whose read-only `settings` map it renders from a
copy) and renders it to the settings.json content: a generated-file header (JSONC — VS Code
reads comments in settings.json) followed by the settings as JSON, in registry order. The explanations
live as comments in the yml — the authored, searched artifact — not in the rendering.

The one render-time completion is `search.exclude`: every path in -ManagedTarget (the root-config
registry's opted-in targets, supplied by Build-RootConfig's generator dispatch) is added to the map, so
find-all always lands on the source of truth and never on a generated copy. An authored entry wins over
an injected key of the same name (an explicit `false` stays un-excluded).

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
root-config registry names for the .vscode/settings.json target, and Build-RootConfig owns the write. It
reads only its own registry, never rootconfig.yml, so the dependency edge stays one-way
(RootConfig -> VSCode; see [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
```

## comment:2

Section `.PARAMETER ManagedTarget` of the comment-based help.

```text
The managed root-config target paths to complete `search.exclude` with (repo-root-relative). Supplied by
the generator dispatch; empty renders the authored settings alone.
```

## comment:3

Section `.PARAMETER MachineSetting` of the comment-based help.

```text
Settings resolved on this machine at render time, added after the authored ones (an authored key wins).
Supplied by the generator dispatch: `go.goroot`, the managed Go toolchain, so the Go extension and gopls run the
pinned go rather than whichever go comes first on PATH; and `python.defaultInterpreterPath`, the Python test
project's environment in this platform's layout. settings.json is a gitignored, per-machine copy, so a machine
path is in place there.
```

## comment:4

Section `.PARAMETER LanguageFormatter` of the comment-based help.

```text
The editor formatter of each language, VS Code language id -> extension id, rendered as that language's
`[<id>].editor.defaultFormatter`. Supplied by the generator dispatch from the file-language registry, so Format
Document runs the engine Format-Code runs
([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)); an authored
`[<id>]` block keeps its own settings, and an authored defaultFormatter in it wins.
```

## comment:5

Above `foreach ($key in ($MachineSetting.Keys | Sort-Object)) {`.

```text
Machine-resolved settings complete the authored ones, which win on a shared key; sorted, so the render is
stable.
```

## comment:6

Above `foreach ($id in ($LanguageFormatter.Keys | Sort-Object)) {`.

```text
Each language's editor formatter, merged into its [<id>] block (authored keys in the block win); sorted, so the
render is stable.
```
