<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Languages/Invoke-BashTest.ps1
    name: invoke-bash-test
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-languages/Invoke-BashTest.ps1.md
    test: automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1
---
#>

function Invoke-BashTest {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.BashTestResult])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $EntryScript,

        [string] $EngineExecutable
    )

    $root = Get-RepositoryRoot
    $folderName = $Module.ToLowerInvariant().Replace('.', '-')
    # The Bash root from bash.yml (BashConfig.ResolveRoot: the declared root, else bash/ when present, else .bash/).
    $bashRelative = (Get-Config -Config bash).ResolveRoot($root)
    $bashRoot = Join-Path $root $bashRelative
    $relative = "$bashRelative/tests/$folderName"
    if (-not (Test-Path -LiteralPath (Join-Path $root $relative) -PathType Container)) {
        throw "Module '$Module' has no Bash tests: $relative/ does not exist."
    }
    $bats = "$([Catzc.Base.Languages.BashConfig]::BatsFolder)/bin/bats"
    if (-not (Test-Path -LiteralPath (Join-Path $bashRoot $bats) -PathType Leaf)) {
        throw "The bats-core runner is missing: $bashRelative/$bats does not exist. Run Update-BatsVendor."
    }

    # The engine contract, for the bash engine: a Bash test is Bash, so it runs only there.
    $environment = Get-EngineContract -Engine ([Catzc.Base.Engines.ExecutionEngines]::Bash.Name) -EngineExecutable $EngineExecutable -EntryScript $EntryScript
    $bash = $environment['CATZC_ENGINE_EXECUTABLE']
    # bats writes report.xml into the output folder; forward-slashed, so bash reads the Windows path too.
    $output = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-bats-$([guid]::NewGuid().ToString('N'))"
    [void][System.IO.Directory]::CreateDirectory($output)

    $saved = @{}
    foreach ($name in $environment.Keys) {
        $saved[$name] = [System.Environment]::GetEnvironmentVariable($name)
        [System.Environment]::SetEnvironmentVariable($name, $environment[$name])
    }
    try {
        $run = Invoke-Executable ("`"$bash`" $bats --recursive --report-formatter junit --output `"$($output.Replace('\', '/'))`" " +
            "`"tests/$folderName`"") -WorkingDirectory $bashRoot -PassThru -NoAssert
        $report = Join-Path $output 'report.xml'
        $reportText = if (Test-Path -LiteralPath $report -PathType Leaf) {
            [System.IO.File]::ReadAllText($report)
        }
        else {
            ''
        }
    }
    finally {
        foreach ($name in $environment.Keys) {
            if ($null -eq $saved[$name]) {
                Remove-Item -LiteralPath "Env:$name" -ErrorAction Ignore
            }
            else {
                [System.Environment]::SetEnvironmentVariable($name, $saved[$name])
            }
        }
        Remove-Item -LiteralPath $output -Recurse -Force -ErrorAction Ignore
    }

    try {
        $results = @(ConvertFrom-BatsJunit -Text $reportText)
    }
    catch {
        throw "bats failed in $relative/ (exit $($run.ExitCode)): $($_.Exception.Message)`n$($run.Full)"
    }

    if ($results.Count -eq 0 -or ($run.ExitCode -ne 0 -and -not @($results | Where-Object { $_.Outcome -eq 'fail' }).Count)) {
        throw "bats failed in $relative/ (exit $($run.ExitCode)) with no failing test:`n$($run.Full)"
    }

    $results
}
