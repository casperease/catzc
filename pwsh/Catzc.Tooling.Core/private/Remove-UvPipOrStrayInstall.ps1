<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/private/Remove-UvPipOrStrayInstall.ps1
    folder: private
    name: remove-uv-pip-or-stray-install
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Remove-UvPipOrStrayInstall.ps1.md](docs/references/pwsh/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md)"
    cites:
      - ADR-AUTO-REMOVE-ELEVATIONFOLLOWSMECHANISM
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
