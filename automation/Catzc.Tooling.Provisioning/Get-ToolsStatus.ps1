<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/Get-ToolsStatus.ps1
    kind: function
    module: Catzc.Tooling.Provisioning
    visibility: public
---
#>

<#
.SYNOPSIS
    Reports the installation status of all registered tools.
.DESCRIPTION
    Read-only and idempotent: it only observes the machine, so it is safe to run at any time.
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md#comment1)
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

    # A bare name on PATH may not be the tool (bash on Windows is the WSL launcher), so candidate paths locate it first.
    # [comment:2](/docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md#comment2)
    $versionJobs = @{}
    foreach ($toolName in $allTools.Keys) {
        $config = $allTools[$toolName]
        if (-not $config.HasProbes() -and (Test-Command $config.command)) {
            # The tokenizer keeps quoted arguments whole, so the probe runs via the call operator, not a string eval.
            # [comment:3](/docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md#comment3)
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

        # Off Windows a Windows-only tool would otherwise be reported as Missing, so it is skipped.
        # [comment:4](/docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md#comment4)
        if ($config.windows_only -and -not $IsWindows) {
            continue
        }

        $command = Get-ToolCommandSuffix -Tool $toolName

        # The branch order must match Test-ExpectedPackageManager, or the two disagree on the expected manager.
        # [comment:5](/docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md#comment5)
        $expectedManager = if ($config.system_provided) {
            'system'
        }
        elseif ($config.script_install) {
            'script'
        }
        elseif ($config.msys2_url -and $IsWindows) {
            'msys2'
        }
        elseif ($config.uv_tool -or $config.uv_python -or $config.uv_venv) {
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
        elseif ($config.msys2_url) {
            'system'
        }
        else {
            'unknown'
        }

        $probe = if ($config.HasProbes()) {
            Test-Tool $toolName -PassThru
        }
        else {
            $null
        }

        # Tool not found — nothing more to check
        $found = if ($probe) {
            $probe.Found
        }
        else {
            Test-Command $config.command
        }
        if (-not $found) {
            $missingAction = if ($expectedManager -eq 'system') {
                'Provided by the platform, not the toolchain — install it (bash on Windows: Install-Git)'
            }
            else {
                "Run Install-$command"
            }
            [Catzc.Tooling.Provisioning.ToolStatus]::new($toolName, "$($config.version).x", $null, 'Missing', $null, $null, $null, $missingAction)
            continue
        }

        if ($probe) {
            $location = $probe.Path
            $installed = $probe.Version
        }
        else {
            $location = (Get-Command $config.command).Source
            $installed = $versionResults[$toolName]
        }

        $versionOk = $installed -and $installed.StartsWith($config.version)
        # Judged at the location this status reports: a tool located by its candidate paths need not be on PATH.
        $managedByExpected = Test-ExpectedPackageManager -Config $config -WingetListCache $wingetCache -Path $location
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
            # Install scope is ignored here: a machine-wide install by the right manager still works and is ours.
            # [comment:6](/docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md#comment6)
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
            # Installing via our manager would not help: the old binary on Machine PATH would still shadow the new one.
            # [comment:7](/docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md#comment7)
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

    # Chocolatey is no tools.yml tool but an unwanted package manager, so it is reported only when actually found.
    # [comment:8](/docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md#comment8)
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
