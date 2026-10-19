function Set-ImportMix {
    [CmdletBinding()]
    [OutputType([Catzc.Base.ModuleSystem.ImportMix])]
    param(
        [ArgumentCompleter({ (Get-Config -Config languages).languages.name })]
        [string[]] $Languages,

        [ArgumentCompleter({ [Catzc.Base.Engines.ExecutionEngines]::Names })]
        [string[]] $Engines,

        [switch] $DryRun
    )

    $resolveArgs = @{}
    foreach ($axis in 'Languages', 'Engines') {
        if ($PSBoundParameters.ContainsKey($axis)) {
            $resolveArgs[$axis] = $PSBoundParameters[$axis]
        }
    }
    $mix = Resolve-ImportMix @resolveArgs
    if ($DryRun) {
        return $mix
    }

    # The session record: the importer sets it once, and the test runner and the builder read it through Get-ImportMix.
    $script:importMix = $mix
    $removed = @(foreach ($name in $mix.skipped_modules) {
            if (Get-Module -Name $name) {
                Remove-Module -Name $name -Force
                $name
            }
        })
    if ($removed.Count -gt 0) {
        Write-Message "Removed $($removed.Count) module(s) outside the mix (languages: $($mix.languages -join ', ')): $($removed -join ', ')"
    }
    $mix
}
