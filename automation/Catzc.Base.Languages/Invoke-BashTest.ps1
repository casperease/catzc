<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/Invoke-BashTest.ps1
    kind: function
    module: Catzc.Base.Languages
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Runs a catzc module's Bash tests and returns one result per Bash test.
.DESCRIPTION
    The tests are black-box: they reach catzc only through an environment contract set for this call and restored.
    [comment:1](/docs/references/automation/catzc-base-languages/Invoke-BashTest.ps1.md#comment1)
.PARAMETER Module
    The catzc module whose Bash tests to run (e.g. Catzc.Base.Repository).
.PARAMETER EntryScript
    Leave it out for a source run: it then defaults to the repository's importer.ps1.
    [comment:2](/docs/references/automation/catzc-base-languages/Invoke-BashTest.ps1.md#comment2)
.PARAMETER EngineExecutable
    A build run's engine has no tools.yml entry, so the caller must pass the bash its source session resolved.
    [comment:3](/docs/references/automation/catzc-base-languages/Invoke-BashTest.ps1.md#comment3)
.OUTPUTS
    [Catzc.Base.Languages.BashTestResult] One record per Bash test.
.EXAMPLE
    Invoke-BashTest Catzc.Base.Repository
.EXAMPLE
    Invoke-BashTest Catzc.Base.Repository -EntryScript out/build/Import-Catzc.ps1
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

    # A failing exit with no failing test means bats broke around the tests, such as a .bats file that does not parse.
    # [comment:4](/docs/references/automation/catzc-base-languages/Invoke-BashTest.ps1.md#comment4)
    if ($results.Count -eq 0 -or ($run.ExitCode -ne 0 -and -not @($results | Where-Object { $_.Outcome -eq 'fail' }).Count)) {
        throw "bats failed in $relative/ (exit $($run.ExitCode)) with no failing test:`n$($run.Full)"
    }

    $results
}
