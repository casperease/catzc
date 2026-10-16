<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-ShellScripts.ps1
    name: test-shell-scripts
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/Test-ShellScripts.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
    adrs:
      - ADR-AUTO-BASH#6
      - ADR-AUTO-ENGINE#2
  config:
    synopsis: |-
      Quality gate: checks every shell script the repository holds — LF line endings, the executable bit, and ShellCheck or
      zsh's syntax check on the repository's own.
    description: |-
      The POSIX engines read a carriage return as part of the command, so a shell script with CRLF line endings does not run
      ([ADR-AUTO-ENGINE#2](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine2): the POSIX engines require LF;
      [ADR-AUTO-BASH#6](/docs/adr/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash6): every shell script takes these checks).
      The scope is every tracked *.sh, *.bats and *.zsh file plus the root importer.sh (a committed root-config copy that is
      regenerated on import). The vendored bats-core runner (<Bash root>/.vendor/bats-core/, BashConfig.BatsFolder) is mostly
      Bash scripts without an extension; every tracked file in it takes the LF check only, since it is third-party code the
      repository runs but does not own (upstream ships its sourced lib/*.bash with a shebang and mode 100644). Four checks:

        LF          every file in scope: a carriage return anywhere is one issue (.gitattributes pins the shell scripts to
                    eol=lf, so a re-checkout fixes a stale working copy; a CRLF file in the index needs re-adding);
        executable  every tracked file in scope that starts with a shebang must be stored executable (git mode 100755,
                    Get-GitTrackedPath -ExecutableOnly), since it is meant to run directly; a sourced file has no shebang;
        ShellCheck  every *.sh, *.bats and importer.sh except -ShellCheckExclude (vendored third-party scripts): each finding
                    is one issue, '<file>:<line>:<column>: <severity>: <message> [SC<code>]', from the pinned ShellCheck
                    (tools.yml `shellcheck`, Install-Shellcheck), run by its path;
        zsh -n      every *.zsh, in place of ShellCheck, which does not read zsh: zsh parses the file without running it
                    (-n, NO_EXEC; -f, no startup files), and each line it reports is one issue, from the pinned zsh
                    (tools.yml `zsh`, Install-Zsh), run by its path.

      Ends with Write-QualityGateReport: the report lands in out/test-shell-scripts/, and the gate throws once listing every
      issue (or returns the result with -PassThru). Throws with "Run Install-Shellcheck" when ShellCheck at the pin is
      missing and there is a script for it, and with "Run Install-Zsh" when zsh at the pin is missing and there is a *.zsh
      file. Needs the source tree (Assert-SourceTree).
    parameters:
      ShellCheckExclude: |-
        Repository-relative wildcard paths ShellCheck skips: vendored third-party scripts, which are LF-checked but not
        analysed. Default: the vendored dotnet-install.sh. A *.zsh file never goes to ShellCheck.
      OutputFolder: The report base folder. Defaults to Write-QualityGateReport's (out/test-shell-scripts).
      PassThru: Return the gate result { Subject; IssueCount; Issues; ReportPath; Scripts } instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-ShellScripts
      - (Test-ShellScripts -PassThru).Issues
---
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
        foreach ($extension in '.sh', '.bats', '.zsh') {
            if ($tracked.EndsWith($extension, [System.StringComparison]::Ordinal)) {
                $scripts.Add($tracked)
            }
        }
    }
    $importer = [Catzc.Base.Engines.ExecutionEngines]::Bash.ImporterEntry
    if (-not $scripts.Contains($importer) -and (Test-Path -LiteralPath (Join-Path $repositoryRoot $importer) -PathType Leaf)) {
        $scripts.Add($importer)
    }
    $scripts.Sort([System.StringComparer]::Ordinal)

    $executable = [System.Collections.Generic.HashSet[string]]::new([string[]]@(Get-GitTrackedPath '.' -ExecutableOnly), [System.StringComparer]::Ordinal)
    $tracked = [System.Collections.Generic.HashSet[string]]::new([string[]]@(Get-GitTrackedPath '.'), [System.StringComparer]::Ordinal)
    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($script in $scripts) {
        $full = Join-Path $repositoryRoot $script
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
            continue
        }
        $bytes = [System.IO.File]::ReadAllBytes($full)
        if ($bytes -contains 13) {
            $issues.Add("${script}: CRLF line endings — the shell reads the carriage return as part of the command; the file must be LF (.gitattributes eol=lf)")
        }
        $shebang = $bytes.Length -ge 2 -and $bytes[0] -eq 35 -and $bytes[1] -eq 33
        if ($shebang -and $tracked.Contains($script) -and -not $executable.Contains($script)) {
            $issues.Add("${script}: has a shebang but is not executable in git (mode 100644) — run: git update-index --chmod=+x $script")
        }
    }

    # The vendored bats-core runner: the LF check only (third-party code, run but not owned).
    $batsFolder = "$((Get-Config -Config bash).ResolveRoot($repositoryRoot))/$([Catzc.Base.Languages.BashConfig]::BatsFolder)/"
    $vendoredRunner = @($tracked | Where-Object { $_.StartsWith($batsFolder, [System.StringComparison]::Ordinal) } | Sort-Object)
    foreach ($file in $vendoredRunner) {
        $full = Join-Path $repositoryRoot $file
        if ((Test-Path -LiteralPath $full -PathType Leaf) -and ([System.IO.File]::ReadAllBytes($full) -contains 13)) {
            $issues.Add("${file}: CRLF line endings — the shell reads the carriage return as part of the command; the file must be LF (.gitattributes eol=lf)")
        }
    }

    $zshScripts = @($scripts | Where-Object { $_.EndsWith('.zsh', [System.StringComparison]::Ordinal) })
    $analysed = @($scripts | Where-Object {
            $path = $_
            -not $path.EndsWith('.zsh', [System.StringComparison]::Ordinal) -and -not @($ShellCheckExclude | Where-Object { $path -like $_ }).Count
        })
    if ($analysed.Count -gt 0) {
        $shellcheck = Resolve-ToolExecutable -Tool shellcheck
        if (-not ($shellcheck.Found -and $shellcheck.VersionOk)) {
            throw "Test-ShellScripts needs ShellCheck at the tools.yml pin '$($shellcheck.Required)' (found: $($shellcheck.Version ?? 'none')). Run Install-Shellcheck."
        }
        $quoted = ($analysed | ForEach-Object { "`"$_`"" }) -join ' '
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

    if ($zshScripts.Count -gt 0) {
        $zsh = Resolve-ToolExecutable -Tool zsh
        if (-not ($zsh.Found -and $zsh.VersionOk)) {
            throw "Test-ShellScripts needs zsh at the tools.yml pin '$($zsh.Required)' (found: $($zsh.Version ?? 'none')). Run Install-Zsh."
        }
        foreach ($script in $zshScripts) {
            $check = Invoke-Executable "`"$($zsh.Path)`" -f -n `"$script`"" -WorkingDirectory $repositoryRoot -PassThru -NoAssert -Silent
            if ($check.ExitCode -eq 0) {
                continue
            }
            if ($check.ExitCode -ne 1) {
                throw "zsh could not check '$script' (exit $($check.ExitCode)):`n$($check.Full)"
            }
            if (-not $check.Full.Trim()) {
                $issues.Add("${script}: zsh -n reports a syntax error (exit 1) and prints no detail")
                continue
            }
            foreach ($line in ($check.Full -split '\r?\n')) {
                if (-not $line.Trim()) {
                    continue
                }
                # zsh names the file as it was given ('<file>:<line>: <message>'); a line without it gets the file prefixed.
                $issue = if ($line.StartsWith("${script}:", [System.StringComparison]::Ordinal)) {
                    $line
                }
                else {
                    "${script}: $line"
                }
                $issues.Add($issue)
            }
        }
    }

    Write-QualityGateReport -Subject shell-scripts -Title Test-ShellScripts -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Scripts = $scripts.Count; VendoredRunnerFiles = $vendoredRunner.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
