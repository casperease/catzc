<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/New-VSCodeSettings.ps1
    kind: function
    subkind: writer
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.VSCode
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md
      test: automation/Catzc.Base.VSCode/tests/New-VSCodeSettings.Tests.ps1
    adrs:
      - ADR-REPO-FORMAT#8
      - ADR-REPO-ROOTCFG
  config:
    synopsis: |-
      Renders .vscode/settings.json content from the vscode-settings registry — the glue that keeps the
      editor's behaviour in sync with the tooling.
    description: |-
      Reads the authored settings registry (configs/vscode-settings.yml, via Get-Config -Config
      vscode-settings — the validated VscodeSettingsConfig, whose read-only `settings` map it renders from a
      copy) and renders it to the settings.json content: the settings as JSON, in registry order, without a head
      (Build-RootConfig writes the generated-file head as a JSONC comment head, which VS Code reads in settings.json). The explanations
      live as comments in the yml — the authored, searched artifact — not in the rendering.

      The one render-time completion is `search.exclude`: every path in -ManagedTarget (the root-config
      registry's opted-in targets, supplied by Build-RootConfig's generator dispatch) is added to the map, so
      find-all always lands on the source of truth and never on a generated copy. An authored entry wins over
      an injected key of the same name (an explicit `false` stays un-excluded).

      This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
      root-config registry names for the .vscode/settings.json target, and Build-RootConfig owns the write. It
      reads only its own registry, never rootconfig.yml, so the dependency edge stays one-way
      (RootConfig -> VSCode; see [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
    parameters:
      ManagedTarget: |-
        The managed root-config target paths to complete `search.exclude` with (repo-root-relative). Supplied by
        the generator dispatch; empty renders the authored settings alone.
      MachineSetting: |-
        Settings resolved on this machine at render time, added after the authored ones (an authored key wins).
        Supplied by the generator dispatch: `go.goroot`, the managed Go toolchain, so the Go extension and gopls run the
        pinned go rather than whichever go comes first on PATH; and `python.defaultInterpreterPath`, the Python test
        project's environment in this platform's layout. settings.json is a gitignored, per-machine copy, so a machine
        path is in place there.
      LanguageFormatter: |-
        The editor formatter of each language, VS Code language id -> extension id, rendered as that language's
        `[<id>].editor.defaultFormatter`. Supplied by the generator dispatch from the file-language registry, so Format
        Document runs the engine Format-Code runs
        ([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)); an authored
        `[<id>]` block keeps its own settings, and an authored defaultFormatter in it wins.
    outputs: '[string] The rendered settings.json content (LF-joined; the writer canonicalises).'
    examples:
      - New-VSCodeSettings -ManagedTarget '/PSScriptAnalyzerSettings.psd1', 'importer.ps1'
---
#>

function New-VSCodeSettings {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowEmptyCollection()]
        [string[]] $ManagedTarget = @(),

        [hashtable] $MachineSetting = @{},

        [System.Collections.IDictionary] $LanguageFormatter = @{}
    )

    $config = Get-Config -Config vscode-settings

    # The typed registry is the cached, read-only config: render from a copy of its settings.
    $settings = [ordered]@{}
    foreach ($key in $config.settings.Keys) {
        $settings[$key] = $config.settings[$key]
    }
    foreach ($key in ($MachineSetting.Keys | Sort-Object)) {
        if (-not $settings.Contains($key)) {
            $settings[$key] = $MachineSetting[$key]
        }
    }

    foreach ($id in ($LanguageFormatter.Keys | Sort-Object)) {
        $key = "[$id]"
        $block = [ordered]@{}
        if ($settings.Contains($key)) {
            foreach ($setting in $settings[$key].Keys) {
                $block[$setting] = $settings[$key][$setting]
            }
        }
        if (-not $block.Contains('editor.defaultFormatter')) {
            $block['editor.defaultFormatter'] = $LanguageFormatter[$id]
        }
        $settings[$key] = $block
    }

    # Complete search.exclude with the managed targets — authored keys win, injected keys append in order.
    $exclude = [ordered]@{}
    if ($settings.Contains('search.exclude')) {
        foreach ($glob in $settings['search.exclude'].Keys) {
            $exclude[$glob] = $settings['search.exclude'][$glob]
        }
    }
    foreach ($target in $ManagedTarget) {
        if (-not $exclude.Contains($target)) {
            $exclude[$target] = $true
        }
    }
    $settings['search.exclude'] = $exclude

    (ConvertTo-Json -InputObject $settings -Depth 12) + "`n"
}
