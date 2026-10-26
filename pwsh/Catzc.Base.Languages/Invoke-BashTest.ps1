<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-languages/Invoke-BashTest.ps1.md"
  header: "generated"
---
#>

function Invoke-BashTest {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Languages.BashTestResult])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $EntryScript,

        [string] $EngineExecutable,

        [string] $Folder
    )

    $root = Get-RepositoryRoot
    # The Bash root from bash.yml (BashConfig.ResolveRoot: the declared root, else bash/ when present, else .bash/).
    $bashRelative = (Get-Config -Config bash).ResolveRoot($root)
    $bashRoot = Join-Path $root $bashRelative
    # The test folder: the one named, a module's own tests/ or the holder's, else the module's folder under the holder's
    # tests/ in bash's folder case.
    $relative = if ($Folder) {
        [System.IO.Path]::GetRelativePath($root, [System.IO.Path]::GetFullPath($Folder, $root)).Replace('\',
            '/').TrimEnd('/')
    }
    else {
        "$bashRelative/tests/$((Get-Config -Config languages).TestFolderOf('bash', $Module))"
    }
    if (-not (Test-Path -LiteralPath (Join-Path $root $relative) -PathType Container)) {
        throw "Module '$Module' has no Bash tests: $relative/ does not exist."
    }
    # bats runs from the Bash root, so the folder is named relative to it.
    $inBashRoot = [System.IO.Path]::GetRelativePath($bashRoot, (Join-Path $root $relative)).Replace('\', '/')
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
            "`"$inBashRoot`"") -WorkingDirectory $bashRoot -PassThru -NoAssert
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

    if ($results.Count -eq 0 -or ($run.ExitCode -ne 0 -and
        -not @($results | Where-Object { $_.Outcome -eq 'fail' }).Count)) {
        throw "bats failed in $relative/ (exit $($run.ExitCode)) with no failing test:`n$($run.Full)"
    }

    $results
}
