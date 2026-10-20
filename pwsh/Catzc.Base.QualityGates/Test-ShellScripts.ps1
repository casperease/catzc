<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Test-ShellScripts.ps1
    name: test-shell-scripts
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
    docs: "[Test-ShellScripts.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-ShellScripts.ps1.md)"
    cites:
      - ADR-AUTO-BASH-SHELLSCRIPTSCHECKED
      - ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE
---
#>

function Test-ShellScripts {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $ShellCheckExclude = @("$(Get-CatzcModulesFolder)/*/assets/scripts/dotnet-install.sh"),

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
