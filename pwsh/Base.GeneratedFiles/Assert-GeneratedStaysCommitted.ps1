function Assert-GeneratedStaysCommitted {
    [CmdletBinding()]
    param(
        [string[]] $Path
    )

    if ($PSBoundParameters.ContainsKey('Path')) {
        $deleted = @($Path)
    }
    else {
        $diff = Invoke-Executable 'git -c core.quotepath=off diff --cached --name-only --diff-filter=D' `
            -WorkingDirectory (Get-RepositoryRoot) -PassThru -Silent
        $deleted = @("$($diff.Output)" -split "`r?`n" | Where-Object { $_ })
    }

    # The registry answers, never a head: a deleted path is protected when a writer of a class other than rollable declares it as an output.
    $stay = foreach ($writer in @(Get-GeneratedWriterOrder | Where-Object { $_.class -cne 'rollable' })) {
        foreach ($output in @($writer.outputs | ForEach-Object path)) {
            [pscustomobject] @{ Writer = $writer.name; Class = $writer.class; Pattern = [Catzc.Base.Reports.OutputPattern]::Parse($output) }
        }
    }
    $stay = @($stay)

    $refused = foreach ($file in $deleted) {
        $hit = $stay | Where-Object { $_.Pattern.Matches($file) } | Select-Object -First 1
        if ($hit) {
            "$file (writer $($hit.Writer), class $($hit.Class))"
        }
    }
    $refused = @($refused)
    if ($refused.Count -gt 0) {
        throw "Assert-GeneratedStaysCommitted: $($refused.Count) staged deletion(s) of generated files that stay committed: $($refused -join '; ')."
    }
}
