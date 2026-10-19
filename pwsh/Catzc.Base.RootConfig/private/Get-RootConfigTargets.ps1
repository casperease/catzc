function Get-RootConfigTargets {
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        $Config,

        # Only where a file is materialised: a committed generated file reads the mix-independent list.
        [switch] $FollowMix
    )

    # An engine's importer entry follows the session's mix: it is managed only when one of the engines it serves is in the mix.
    $mixEngines = $null
    foreach ($entry in @($Config.files | Where-Object { $_.optIn })) {
        if (-not $FollowMix) {
            $entry
            continue
        }
        $servedBy = @(foreach ($engine in [Catzc.Base.Engines.ExecutionEngines]::All) {
                if ($engine.ImporterEntry -ceq $entry.target) {
                    $engine.Name
                }
            })
        if ($servedBy.Count -gt 0) {
            if ($null -eq $mixEngines) {
                $mixEngines = @((Get-ImportMix).engines)
            }
            $inMix = @(foreach ($name in $servedBy) {
                    if ($mixEngines -ccontains $name) {
                        $name
                    }
                })
            if ($inMix.Count -eq 0) {
                Write-Verbose "Root config '$($entry.target)' skipped: none of its engines ($($servedBy -join ', ')) is in the mix"
                continue
            }
        }
        $entry
    }
}
