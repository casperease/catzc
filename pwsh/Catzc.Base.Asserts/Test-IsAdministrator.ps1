<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Asserts/Test-IsAdministrator.ps1
    name: test-is-administrator
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    docs: "[Test-IsAdministrator.ps1.md](docs/references/pwsh/catzc-base-asserts/Test-IsAdministrator.ps1.md)"
---
#>

function Test-IsAdministrator {
    [OutputType([bool])]
    param()

    if ($IsWindows) {
        $user = [Security.Principal.WindowsIdentity]::GetCurrent()
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole(
            [Security.Principal.WindowsBuiltinRole]::Administrator
        )
    }
    else {
        # Root or has passwordless sudo (CI agents, containers)
        if ((id -u) -eq '0') {
            return $true
        }
        try {
            $null = sudo -n true 2>&1
            $LASTEXITCODE -eq 0
        }
        catch {
            $false
        }
    }
}
