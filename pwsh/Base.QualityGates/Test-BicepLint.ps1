function Test-BicepLint {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $Path = @('infrastructure'),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $repositoryRoot = Get-RepositoryRoot
    $files = [string[]] @(@(foreach ($folder in $Path) {
                Get-GitTrackedPath $folder
            }) | Where-Object { $_.EndsWith('.bicep', [System.StringComparison]::Ordinal) } | Sort-Object -Unique)

    $issues = [System.Collections.Generic.List[string]]::new()
    if ($files.Count -gt 0) {
        $bicep = Resolve-ToolExecutable -Tool bicep
        if (-not ($bicep.Found -and $bicep.VersionOk)) {
            throw "Test-BicepLint needs the Bicep CLI at the tools.yml pin '$($bicep.Required)' (found: $($bicep.Version ?? 'none')). Run Install-Bicep."
        }
        # The linter reads its rule levels from the nearest bicepconfig.json; every diagnostic it prints is a finding, a warning included.
        foreach ($file in $files) {
            $check = Invoke-Executable "`"$($bicep.Path)`" lint `"$file`"" -WorkingDirectory $repositoryRoot -PassThru -NoAssert -Silent
            $found = 0
            foreach ($line in ($check.Full -split '\r?\n')) {
                if ($line -match '^(?<file>.+?)\((?<line>\d+),(?<column>\d+)\) : (?<level>Error|Warning|Info) (?<rule>[^:]+): (?<message>.+)$') {
                    $found++
                    $relative = [System.IO.Path]::GetRelativePath($repositoryRoot, $Matches['file']).Replace('\', '/')
                    $issues.Add("${relative}:$($Matches['line']):$($Matches['column']): $($Matches['level']) $($Matches['rule']): $($Matches['message'])")
                }
            }
            if ($check.ExitCode -ne 0 -and $found -eq 0) {
                throw "The Bicep linter could not check '$file' (exit $($check.ExitCode)):`n$($check.Full)"
            }
        }
    }

    Write-QualityGateReport -Subject bicep-lint -Title Test-BicepLint -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Files = $files.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
