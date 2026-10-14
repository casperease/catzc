<#
.SYNOPSIS
    Quality gate: checks every shell script the repository holds — LF line endings, and ShellCheck on the repository's own.
.DESCRIPTION
    Bash reads a carriage return as part of the command, so a shell script with CRLF line endings does not run
    ([ADR-AUTO-ENGINE#2](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine2): the bash engine requires LF).
    The scope is every tracked *.sh and *.bats file plus the root importer.sh (a committed root-config copy that is
    regenerated on import). Three checks:

      LF          every file in scope: a carriage return anywhere is one issue (.gitattributes pins *.sh eol=lf, so a
                  re-checkout fixes a stale working copy; a CRLF file in the index needs re-adding);
      executable  every tracked file in scope that starts with a shebang must be stored executable (git mode 100755,
                  Get-GitTrackedPath -Executable), since it is meant to run directly; a sourced file has no shebang;
      ShellCheck  every file in scope except -ShellCheckExclude (vendored third-party scripts): each finding is one issue,
                  '<file>:<line>:<column>: <severity>: <message> [SC<code>]', from the pinned ShellCheck (tools.yml
                  `shellcheck`, Install-Shellcheck), run by its path.

    Ends with Write-QualityGateReport: the report lands in out/test-shell-scripts/, and the gate throws once listing every
    issue (or returns the result with -PassThru). Throws with "Run Install-Shellcheck" when ShellCheck at the pin is
    missing and there is a script to check. Needs the source tree (Assert-SourceTree).
.PARAMETER ShellCheckExclude
    Repository-relative wildcard paths ShellCheck skips: vendored third-party scripts, which are LF-checked but not
    analysed. Default: the vendored dotnet-install.sh.
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-shell-scripts).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; Scripts } instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ShellScripts
.EXAMPLE
    (Test-ShellScripts -PassThru).Issues
#>
function Test-ShellScripts {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $ShellCheckExclude = @('automation/*/assets/scripts/dotnet-install.sh'),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $repositoryRoot = Get-RepositoryRoot
    $scripts = [System.Collections.Generic.List[string]]::new()
    foreach ($tracked in @(Get-GitTrackedPath '.')) {
        if ($tracked.EndsWith('.sh', [System.StringComparison]::Ordinal) -or $tracked.EndsWith('.bats', [System.StringComparison]::Ordinal)) {
            $scripts.Add($tracked)
        }
    }
    $importer = [Catzc.Base.Engines.ExecutionEngines]::Bash.ImporterEntry
    if (-not $scripts.Contains($importer) -and (Test-Path -LiteralPath (Join-Path $repositoryRoot $importer) -PathType Leaf)) {
        $scripts.Add($importer)
    }
    $scripts.Sort([System.StringComparer]::Ordinal)

    $executable = [System.Collections.Generic.HashSet[string]]::new([string[]]@(Get-GitTrackedPath '.' -Executable), [System.StringComparer]::Ordinal)
    $tracked = [System.Collections.Generic.HashSet[string]]::new([string[]]@(Get-GitTrackedPath '.'), [System.StringComparer]::Ordinal)
    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($script in $scripts) {
        $full = Join-Path $repositoryRoot $script
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
            continue
        }
        $bytes = [System.IO.File]::ReadAllBytes($full)
        if ($bytes -contains 13) {
            $issues.Add("${script}: CRLF line endings — bash reads the carriage return as part of the command; the file must be LF (.gitattributes *.sh eol=lf)")
        }
        # A script with a shebang is meant to run directly, which on Unix needs the executable bit in git; a sourced file
        # (importer.sh, a shellcheck directive instead of a shebang) does not.
        $shebang = $bytes.Length -ge 2 -and $bytes[0] -eq 35 -and $bytes[1] -eq 33
        if ($shebang -and $tracked.Contains($script) -and -not $executable.Contains($script)) {
            $issues.Add("${script}: has a shebang but is not executable in git (mode 100644) — run: git update-index --chmod=+x $script")
        }
    }

    $analysed = @($scripts | Where-Object {
            $path = $_
            -not @($ShellCheckExclude | Where-Object { $path -like $_ }).Count
        })
    if ($analysed.Count -gt 0) {
        $shellcheck = Resolve-ToolExecutable -Tool shellcheck
        if (-not ($shellcheck.Found -and $shellcheck.VersionOk)) {
            throw "Test-ShellScripts needs ShellCheck at the tools.yml pin '$($shellcheck.Required)' (found: $($shellcheck.Version ?? 'none')). Run Install-Shellcheck."
        }
        $quoted = ($analysed | ForEach-Object { "`"$_`"" }) -join ' '
        # --format=gcc prints one '<file>:<line>:<column>: <severity>: <message> [SC<code>]' line per finding; exit 1
        # means findings, anything above it means ShellCheck itself failed.
        $check = Invoke-Executable "`"$($shellcheck.Path)`" --format=gcc --external-sources $quoted" -WorkingDirectory $repositoryRoot -PassThru -NoAssert -Silent
        if ($check.ExitCode -notin 0, 1) {
            throw "ShellCheck could not check the shell scripts (exit $($check.ExitCode)):`n$($check.Full)"
        }
        foreach ($line in ($check.Output -split '\r?\n')) {
            if ($line -match '^(?<file>.+?):(?<rest>\d+:\d+: .+)$') {
                $issues.Add("$($Matches['file'].Replace('\', '/')):$($Matches['rest'])")
            }
        }
    }

    Write-QualityGateReport -Subject shell-scripts -Title Test-ShellScripts -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Scripts = $scripts.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
