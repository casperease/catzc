<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-JavaScriptTypes.ps1.md"
  header: "generated"
---
#>

function Test-JavaScriptTypes {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $repositoryRoot = Get-RepositoryRoot
    $projects = @('jsconfig.json') + @(if (@((Get-Config -Config javascript).strict).Count -gt 0) {
            'jsconfig.strict.json'
        })
    foreach ($name in $projects) {
        Assert-PathExist (Join-Path $repositoryRoot $name) -PathType Leaf -ErrorText "Test-JavaScriptTypes: $name is missing; Build-RootConfig $name renders it."
    }
    $tsc = Resolve-ToolExecutable -Tool typescript
    Assert-True $tsc.Found -ErrorText 'Test-JavaScriptTypes: tsc is not installed (no managed TypeScript found). Run Install-TypeScript.'

    # tsc prints one line per error, path(line,col): error TSnnnn: message; exit 0 is clean, 1 or 2 is errors, anything
    # else is tsc failing.
    $pattern = '^(?<file>.+?)\((?<line>\d+),(?<column>\d+)\): error (?<code>TS\d+): (?<message>.*)$'
    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $projects) {
        $project = Join-Path $repositoryRoot $name
        $check = Invoke-Executable "`"$($tsc.Path)`" --noEmit --pretty false -p `"$project`"" -WorkingDirectory $repositoryRoot -PassThru -NoAssert -Silent
        # A project left with no files (every module raised out of the lenient one) has nothing to check, which tsc
        # reports as TS18003.
        $lines = @($check.Output -split '\r?\n')
        if ($check.ExitCode -ne 0 -and @($lines -match 'error TS18003:').Count -gt 0 -and
            @($lines -match $pattern).Count -eq 0) {
            continue
        }
        $found = 0
        foreach ($line in @($check.Output -split '\r?\n')) {
            if ($line -match $pattern) {
                $file = [System.IO.Path]::GetRelativePath($repositoryRoot,
                    [System.IO.Path]::GetFullPath($Matches['file'], $repositoryRoot)).Replace('\', '/')
                $issues.Add("${file}:$($Matches['line']):$($Matches['column']): error $($Matches['code']) $($Matches['message'].Trim())")
                $found++
            }
        }
        if ($check.ExitCode -notin 0, 1, 2 -or ($check.ExitCode -ne 0 -and $found -eq 0)) {
            throw "tsc could not check the JavaScript of $name (exit $($check.ExitCode)):`n$($check.Full)"
        }
    }

    Write-QualityGateReport -Subject javascript-types -Title Test-JavaScriptTypes -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Errors = $issues.Count; Projects = $projects.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
