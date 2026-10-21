<#
---
catzc:
  immutable:
    with_body_sha: "3de483135680"
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Set-ImportMix.Tests.ps1
    docs: "[Set-ImportMix.ps1.md](../../docs/references/pwsh/catzc-base-module-system/Set-ImportMix.ps1.md)"
    cites:
      - ADR-AUTO-IMPORTER-RESOLVEDAFTERLOAD
      - ADR-AUTO-IMPORTER-CODELANGUAGESSELECTMODULES
---
#>

function Set-ImportMix {
    [CmdletBinding()]
    [OutputType([Catzc.Base.ModuleSystem.ImportMix])]
    param(
        [ArgumentCompleter({ (Get-Config -Config languages).languages.name })]
        [string[]] $LanguageNames,

        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string[]] $Engines,

        [switch] $DryRun
    )

    $resolveArgs = @{}
    if ($PSBoundParameters.ContainsKey('LanguageNames')) {
        $resolveArgs['Languages'] = $LanguageNames
    }
    if ($PSBoundParameters.ContainsKey('Engines')) {
        $resolveArgs['Engines'] = $Engines
    }
    $mix = Resolve-ImportMix @resolveArgs
    if ($DryRun) {
        return $mix
    }

    # The session record: the importer sets it once, and the test runner and the builder read it through Get-ImportMix.
    $script:importMix = $mix
    foreach ($name in $mix.skipped_modules) {
        if (Get-Module -Name $name) {
            Remove-Module -Name $name -Force
            Write-Message "Removed module $name (outside the mix; languages: $($mix.languages -join ', '))"
        }
    }
    $mix
}
