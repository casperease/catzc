<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/Invoke-BashTest.ps1
    name: invoke-bash-test
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-languages/Invoke-BashTest.ps1.md
      test: automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1
  config:
    synopsis: Runs a catzc module's Bash tests and returns one result per Bash test.
    description: |-
      In the module's Bash test folder, <root>/tests/<module-in-kebab>/ (Catzc.Base.Repository -> catzc-base-repository;
      the Bash root is bash.yml's `root`, by default bash/ when the repository has one, else .bash/), runs the bats-core
      runner vendored at <root>/.vendor/bats-core/ (the bash.yml pin) under the bash engine, from the Bash root, through
      Invoke-Executable inside its time safeguard (the bash entry of timeouts.yml):

        bash .vendor/bats-core/bin/bats --recursive --report-formatter junit --output <temp> tests/<folder>

      The Bash tests are black-box tests: they load the engine's entry and call catzc through the cats dispatcher,
      as a Bash user does. How reaches them through the environment (Get-EngineContract for the bash engine), set for
      this command only and restored afterwards: CATZC_ENGINE_ENTRY, the repository's importer.sh, which a test's setup
      loads; CATZC_IMPORTER, the PowerShell entry cats loads — the repository's importer.ps1 for a source run, or
      -EntryScript (the build's Import-Catzc.ps1) for a build run; and CATZC_REPOSITORY_ROOT. A Bash test runs only
      under the bash engine: it is Bash.

      Returns one BashTestResult per @test, with its category from its name: a name starting with "integrity:" is
      integrity, everything else logic. A failing test is a result, not an error. The call throws, with the bats
      output, when the vendored runner is missing, and when bats fails without a failing test (a syntax error in a
      .bats file, or no tests).
    parameters:
      Module: The catzc module whose Bash tests to run (e.g. Catzc.Base.Repository).
      EntryScript: |-
        The PowerShell entry for a build run: the build's Import-Catzc.ps1. Default: the repository's importer.ps1 (the
        source run).
      EngineExecutable: |-
        The bash to run, already located by the caller: a test run passes the bash its source session resolved, because a
        build run's engine does not carry the tools.yml entry. Default: located here by Resolve-EngineExecutable.
    outputs: '[Catzc.Base.Languages.BashTestResult] One record per Bash test.'
    examples:
      - Invoke-BashTest Catzc.Base.Repository
      - Invoke-BashTest Catzc.Base.Repository -EntryScript out/build/Import-Catzc.ps1
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
