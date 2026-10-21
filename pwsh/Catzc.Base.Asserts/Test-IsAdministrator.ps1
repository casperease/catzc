<#
---
catzc:
  immutable:
    with_body_sha: "640a8ba6f736"
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
