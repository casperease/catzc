<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md"
  header: "generated"
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
