function New-GitIgnore {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [hashtable] $Inject = @{}
    )

    $config = Get-Config -Config gitignore

    $lines = [System.Collections.Generic.List[string]]::new()

    foreach ($section in $config.sections) {
        # Static from the registry, or injected by the caller; a provider the caller did not supply fails, never renders a partial file.
        $patterns = @(if ($section.inject) {
                if (-not $Inject.ContainsKey($section.inject)) {
                    throw "gitignore section '$($section.id)' names inject provider '$($section.inject)', which the caller did not supply. Providers given: $(if ($Inject.Keys.Count) { $Inject.Keys -join ', ' } else { '(none)' })."
                }
                @(foreach ($injected in @($Inject[$section.inject])) {
                        [pscustomobject]@{ pattern = [string] $injected; note = $null }
                    })
            }
            else {
                @($section.patterns)
            })

        if ($lines.Count -gt 0) {
            $lines.Add('')
        }
        foreach ($line in (Format-GitIgnoreSection -Title $section.title -Why $section.why -Pattern $patterns)) {
            $lines.Add($line)
        }
    }

    ($lines -join "`n") + "`n"
}
