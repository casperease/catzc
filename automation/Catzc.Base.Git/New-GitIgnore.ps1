<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Git/New-GitIgnore.ps1
    name: new-git-ignore
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-git/New-GitIgnore.ps1.md
    test: automation/Catzc.Base.Git/tests/New-GitIgnore.Tests.ps1
    cites:
      - ADR-REPO-ROOTCFG
  config:
    synopsis: |-
      Renders the repository-root .gitignore content from the gitignore registry — the pretty-printer behind
      "what git ignores is declared, explained, and generated".
    description: |-
      Reads the section registry (configs/gitignore.yml, via Get-Config -Config gitignore) and renders it to the
      full .gitignore text: each section as a titled comment
      block with its wrapped `why` explanation and its verbatim pattern lines (Format-GitIgnoreSection). A
      section declaring `inject: <provider>` takes its patterns from -Inject at render time — the root-config
      section is fed the registry's committed:false targets by Build-RootConfig, so the ignored-copies list
      lives in ONE place (rootconfig.yml) and .gitignore can never drift from it.

      This is a pure renderer: it returns the content and writes nothing — it is the `generator` the
      root-config registry names for the .gitignore target, and Build-RootConfig owns the write (through the
      same idempotent Write-FileIfChanged path as every managed file). It reads only its own registry, never
      rootconfig.yml, so Catzc.Base.Git carries no dependency on Catzc.Base.RootConfig (the composition edge
      runs the other way; see [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
    parameters:
      Inject: |-
        Render-time patterns per provider name (e.g. @{ 'rootconfig-committed-false' = '/.editorconfig', … }).
        Every `inject` provider the registry names must be supplied — an unknown provider throws; an empty list
        renders the section titled but empty.
    outputs: '[string] The rendered .gitignore content (LF-joined; the writer canonicalises).'
    examples:
      - New-GitIgnore -Inject @{ 'rootconfig-committed-false' = @('/PSScriptAnalyzerSettings.psd1') }
---
#>

function New-GitIgnore {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [hashtable] $Inject = @{}
    )

    $config = Get-Config -Config gitignore

    $lines = [System.Collections.Generic.List[string]]::new()

    foreach ($section in $config.sections) {
        $patterns = if ($section.inject) {
            if (-not $Inject.ContainsKey($section.inject)) {
                throw "gitignore section '$($section.id)' names inject provider '$($section.inject)', which the caller did not supply. Providers given: $(if ($Inject.Keys.Count) { $Inject.Keys -join ', ' } else { '(none)' })."
            }
            @(foreach ($injected in @($Inject[$section.inject])) {
                    [pscustomobject]@{ pattern = [string] $injected; note = $null }
                })
        }
        else {
            @($section.patterns)
        }

        if ($lines.Count -gt 0) {
            $lines.Add('')
        }
        foreach ($line in (Format-GitIgnoreSection -Title $section.title -Why $section.why -Pattern $patterns)) {
            $lines.Add($line)
        }
    }

    ($lines -join "`n") + "`n"
}
