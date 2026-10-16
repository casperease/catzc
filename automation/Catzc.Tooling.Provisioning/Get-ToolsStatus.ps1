<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Provisioning/Get-ToolsStatus.ps1
    name: get-tools-status
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-tooling-provisioning/Get-ToolsStatus.ps1.md
    test: automation/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1
  config:
    synopsis: Reports the installation status of all registered tools.
    description: |-
      Reads tool definitions from configs/tools.yml and checks each tool's
      presence, version, package manager, and install scope on the current
      machine. Returns status objects for programmatic use and writes a summary.
      Idempotent — safe to run at any time, read-only.
    examples:
      - Get-ToolsStatus
      - Get-ToolsStatus | Where-Object Status -ne 'OK'
---
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

    $versionJobs = @{}
    foreach ($toolName in $allTools.Keys) {
        $config = $allTools[$toolName]
        if (-not $config.HasProbes() -and (Test-Command $config.command)) {
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

        if ($config.windows_only -and -not $IsWindows) {
            continue
        }

        $command = Get-ToolCommandSuffix -Tool $toolName

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
