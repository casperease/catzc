<#
.SYNOPSIS
    Reports the installation status of all registered tools.
.DESCRIPTION
    Reads tool definitions from configs/tools.yml and checks each tool's
    presence, version, package manager, and install scope on the current
    machine. Returns status objects for programmatic use and writes a summary.
    Idempotent — safe to run at any time, read-only.
.EXAMPLE
    Get-ToolsStatus
.EXAMPLE
    Get-ToolsStatus | Where-Object Status -ne 'OK'
#>
function Get-ToolsStatus {
    [CmdletBinding()]
    param()

    $allTools = Get-Config -Config tools

    Write-Message 'Getting status of tools'

    # --- Batch slow operations up front ---

    # Single winget list call instead of one per tool (~3s saved per winget tool).
    $wingetCache = $null
    if ($IsWindows -and (Test-Command winget)) {
        $wingetResult = Invoke-Executable 'winget list --accept-source-agreements --disable-interactivity' -PassThru -NoAssert -Silent
        $wingetCache = $wingetResult.Full
    }

    # Parallel version probes — each spawns a subprocess, so run them concurrently.
    # Only probe tools that are on PATH (missing tools skip the version check).
    $versionJobs = @{}
    foreach ($toolName in $allTools.Keys) {
        $config = $allTools[$toolName]
        if (Test-Command $config.command) {
            # Split the configured version-probe command line into executable + args with PowerShell's
            # tokenizer (it honours quoted arguments, e.g. pyspark's -c "import pyspark; ..."), so the
            # probe runs via the call operator instead of Invoke-Expression.
            $tokens = [System.Management.Automation.PSParser]::Tokenize($config.version_command, [ref]$null) |
                Where-Object { $_.Type -notin 'NewLine', 'StatementSeparator', 'Comment' }
            $versionExe = $tokens[0].Content
            $versionArgs = @($tokens | Select-Object -Skip 1 | ForEach-Object { $_.Content })
            $versionJobs[$toolName] = Start-ThreadJob -ScriptBlock {
                $ErrorActionPreference = 'Continue'
                $exe = $using:versionExe
                $probeArgs = $using:versionArgs
                & $exe @probeArgs 2>&1
            }
        }
    }

    # Collect all version probe results (blocks until all complete).
    $versionResults = @{}
    foreach ($toolName in $versionJobs.Keys) {
        $config = $allTools[$toolName]
        $output = $versionJobs[$toolName] | Receive-Job -Wait -AutoRemoveJob
        $full = ($output | ForEach-Object {
                if ($_ -is [System.Management.Automation.ErrorRecord]) {
                    $_.Exception.Message
                }
                else {
                    [string]$_
                }
            }) -join [Environment]::NewLine
        if ($full -match $config.version_pattern) {
            $versionResults[$toolName] = $Matches['ver']
        }
    }

    # --- Per-tool status (now fast — no subprocesses) ---

    $ret = foreach ($toolName in $allTools.Keys) {
        $config = $allTools[$toolName]

        # Windows-only tools (winget) do not exist elsewhere — skip them off Windows so they are not reported
        # as Missing on macOS/Linux.
        if ($config.windows_only -and -not $IsWindows) {
            continue
        }

        $command = Get-ToolCommandSuffix -Tool $toolName

        # Mirror Test-ExpectedPackageManager check order:
        # SystemProvided → ScriptInstall → uv → platform-specific → pip → npm → unknown
        $expectedManager = if ($config.system_provided) {
            'system'
        }
        elseif ($config.script_install) {
            'script'
        }
        elseif ($config.uv_tool -or $config.uv_python) {
            'uv'
        }
        elseif ($IsWindows -and $config.winget_id) {
            'winget'
        }
        elseif ($IsMacOS -and $config.brew_formula) {
            'brew'
        }
        elseif ($IsLinux -and $config.apt_package) {
            'apt'
        }
        elseif ($config.pip_package) {
            'pip'
        }
        elseif ($config.npm_package) {
            'npm'
        }
        else {
            'unknown'
        }

        # Tool not on PATH — nothing more to check
        if (-not (Test-Command $config.command)) {
            [Catzc.Tooling.Provisioning.ToolStatus]::new($toolName, "$($config.version).x", $null, 'Missing', $null, $null, $null, "Run Install-$command")
            continue
        }

        $location = (Get-Command $config.command).Source
        $installed = $versionResults[$toolName]

        $versionOk = $installed -and $installed.StartsWith($config.version)
        $managedByExpected = Test-ExpectedPackageManager -Config $config -WingetListCache $wingetCache
        $manager = if ($managedByExpected) {
            $expectedManager
        }
        else {
            'other'
        }
        $scope = Get-InstallScope -Config $config -Location $location

        $status = $null
        $action = $null

        if ($versionOk -and $managedByExpected) {
            # Right version, right manager — scope doesn't matter. If winget
            # installed Python machine-wide, it works and we control it.
            $status = 'OK'
            $action = 'None'
        }
        elseif ($versionOk) {
            # Right version but installed outside our manager — usable as-is
            $status = 'Usable'
            $hasRemove = [bool](Get-Command "Remove-$command" -ErrorAction SilentlyContinue)
            $action = if ($hasRemove) {
                "Works, but not managed by $expectedManager. To migrate: Remove-$command -Force (destructive — deletes '$location'), then Install-$command"
            }
            else {
                "Works, but not managed by $expectedManager. Recommend: uninstall from '$location', then Install-$command"
            }
        }
        elseif ($managedByExpected) {
            # Wrong version but our manager controls it — easy fix
            $status = 'WrongVersion'
            $action = "Run Install-$command -Force"
        }
        else {
            # Wrong version AND installed outside our manager. Installing via
            # $expectedManager would succeed but the existing binary on Machine PATH
            # would shadow it — the user would still run the old version.
            $status = 'WrongVersion'
            $hasRemove = [bool](Get-Command "Remove-$command" -ErrorAction SilentlyContinue)
            $action = if ($hasRemove) {
                "Shadows any new install. Run Remove-$command -Force (destructive — deletes '$location' and cleans PATH), then Install-$command"
            }
            else {
                "Installed outside $expectedManager at '$location' — this binary shadows any new install. Uninstall it first, then Install-$command"
            }
        }

        [Catzc.Tooling.Provisioning.ToolStatus]::new($toolName, "$($config.version).x", $installed, $status, $location, $manager, $scope, $action)
    }

    # Chocolatey check — not a tools.yml tool, but a package manager
    # that should not be present (see ADR: use-proper-package-managers).
    # Only report if actually found — no noise when absent.
    if ($IsWindows -and (Test-Command choco)) {
        $ret += [Catzc.Tooling.Provisioning.ToolStatus]::new('Chocolatey', $null, 'present', 'Unwanted', (Get-Command choco).Source, $null, $null, 'Run Uninstall-Chocolatey')
    }

    # One-line summary via Write-Message
    $summary = ($ret | ForEach-Object {
            $label = switch ($_.Status) {
                'OK' {
                    'ok'
                }
                'Usable' {
                    'usable'
                }
                'WrongVersion' {
                    'wrong version'
                }
                'Missing' {
                    'missing'
                }
                'Unwanted' {
                    'unwanted'
                }
            }
            "$($_.Tool) $label"
        }) -join ', '
    Write-Message $summary

    $ret
}
