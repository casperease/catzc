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
    # The editor's project and its lenient twin, which empties once every module is raised.
    $projects = @('jsconfig.json', 'jsconfig.lenient.json')
    foreach ($name in $projects) {
        Assert-PathExist (Join-Path $repositoryRoot $name) -PathType Leaf -ErrorText "Test-JavaScriptTypes: $name is missing; Build-RootConfig $name renders it."
    }
    $compiler = Resolve-ToolExecutable -Tool typescript
    Assert-True $compiler.Found -ErrorText 'Test-JavaScriptTypes: tsc is not installed (no managed TypeScript found). Run Install-TypeScript.'

    # One tsc line per error; exit 0 is clean, 1 or 2 errors, anything else tsc failing.
    $pattern = '^(?<file>.+?)\((?<line>\d+),(?<column>\d+)\): error (?<code>TS\d+): (?<message>.*)$'
    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $projects) {
        $project = Join-Path $repositoryRoot $name
        $check = Invoke-Executable "`"$($compiler.Path)`" --noEmit --pretty false -p `"$project`"" -WorkingDirectory $repositoryRoot -PassThru -NoAssert -Silent
        # A project left with no files reports TS18003, which is nothing to check.
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
