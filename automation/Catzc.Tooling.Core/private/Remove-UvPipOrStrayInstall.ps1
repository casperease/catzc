<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Core/private/Remove-UvPipOrStrayInstall.ps1
    folder: private
    name: remove-uv-pip-or-stray-install
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md
    cites:
      - ADR-AUTO-REMOVE#6
---
#>

function Remove-UvPipOrStrayInstall {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config,

        [Parameter(Mandatory, Position = 1)]
        [string] $Source
    )

    # pip shadow in the uv-managed Python — the uv-scoped uninstall, never a foreign system pip.
    $pipName = if ($Config.pip_package) {
        $Config.pip_package
    }
    else {
        $Config.command
    }
    if (Test-Command uv) {
        $show = Invoke-Executable "uv pip show --system $pipName" -PassThru -NoAssert -Silent
        if ($show.Output) {
            Invoke-Executable "uv pip uninstall --system $pipName"
            return $true
        }
    }

    if ([System.IO.File]::Exists($Source)) {
        Write-Message "Removing stray '$($Config.command)' at '$Source'"
        [System.IO.File]::Delete($Source)
        return $true
    }

    Write-Message "Nothing off-config to remove for '$($Config.command)'"
    $false
}
