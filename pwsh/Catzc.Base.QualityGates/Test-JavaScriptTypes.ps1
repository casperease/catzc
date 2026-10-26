function Test-JavaScriptTypes {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $repositoryRoot = Get-RepositoryRoot
    # The generated jsconfig.json names the js track's files and the type roots Install-TypeScript fills (ADR-AUTO-JS-TYPESGATE).
    $project = Join-Path $repositoryRoot 'jsconfig.json'
    Assert-PathExist $project -PathType Leaf -ErrorText 'Test-JavaScriptTypes: jsconfig.json is missing; Build-RootConfig jsconfig.json renders it.'
    $tsc = Resolve-ToolExecutable -Tool typescript
    Assert-True $tsc.Found -ErrorText 'Test-JavaScriptTypes: tsc is not installed (no managed TypeScript found). Run Install-TypeScript.'

    $check = Invoke-Executable "`"$($tsc.Path)`" --noEmit --pretty false -p `"$project`"" -WorkingDirectory $repositoryRoot -PassThru -NoAssert -Silent
    # tsc prints one line per error, path(line,col): error TSnnnn: message; exit 0 is clean, 1 or 2 is errors, anything else is tsc failing.
    $pattern = '^(?<file>.+?)\((?<line>\d+),(?<column>\d+)\): error (?<code>TS\d+): (?<message>.*)$'
    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($line in @($check.Output -split '\r?\n')) {
        if ($line -match $pattern) {
            $file = [System.IO.Path]::GetRelativePath($repositoryRoot, [System.IO.Path]::GetFullPath($Matches['file'], $repositoryRoot)).Replace('\', '/')
            $issues.Add("${file}:$($Matches['line']):$($Matches['column']): error $($Matches['code']) $($Matches['message'].Trim())")
        }
    }
    if ($check.ExitCode -notin 0, 1, 2 -or ($check.ExitCode -ne 0 -and $issues.Count -eq 0)) {
        throw "tsc could not check the JavaScript (exit $($check.ExitCode)):`n$($check.Full)"
    }

    Write-QualityGateReport -Subject javascript-types -Title Test-JavaScriptTypes -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Errors = $issues.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
