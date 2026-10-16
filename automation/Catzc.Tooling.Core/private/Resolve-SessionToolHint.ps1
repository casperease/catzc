<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/private/Resolve-SessionToolHint.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHint.ps1.md
      test: automation/Catzc.Tooling.Core/tests/Resolve-SessionToolHint.Tests.ps1
  config:
    synopsis: Points the current session at a tool installed outside the installer layer, using its declared hints.
    description: |-
      When a configured tool is not resolvable on PATH but tools.yml gives it session_path_hints (e.g. node's
      nvm-for-windows symlink %ProgramFiles%\nodejs), this prepends the first hint directory that actually
      contains the command to $env:PATH for THIS session only, then returns the resolved command. Session-only,
      never persistent — the installer layer owns the registry PATH. Returns $null when the tool has no hints or
      none resolve.
    parameters:
      Config: The tool's ToolConfig (from Get-ToolConfig).
---
#>

function Resolve-SessionToolHint {
    [OutputType([System.Management.Automation.CommandInfo])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config
    )

    foreach ($hint in $Config.session_path_hints) {
        $dir = [System.Environment]::ExpandEnvironmentVariables($hint)
        if ([string]::IsNullOrWhiteSpace($dir) -or -not (Test-Path -LiteralPath $dir)) {
            continue
        }

        $names = @($Config.command) +
        (@($env:PATHEXT -split ';') | Where-Object { $_ } | ForEach-Object { "$($Config.command)$_" })
        $present = $false
        foreach ($n in $names) {
            if (Test-Path -LiteralPath (Join-Path $dir $n)) {
                $present = $true
                break
            }
        }
        if (-not $present) {
            continue
        }

        $sep = [System.IO.Path]::PathSeparator
        if (($env:PATH -split $sep) -notcontains $dir) {
            $env:PATH = "$env:PATH$sep$dir"
            Write-Message "Session PATH: appended '$dir' so $($Config.command) resolves (session_path_hints)"
        }
        return Get-Command $Config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
    }

    return $null
}
