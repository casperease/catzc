function Remove-Dotnet {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string] $InstallDir = (Resolve-DotnetRemovalTarget),

        [switch] $Force
    )

    Remove-OffConfigInstall -Config (Get-ToolConfig -Tool 'dotnet') -Label '.NET' -Tool 'Dotnet' -InstallDir $InstallDir `
        -MachineFolders 'C:\Program Files\dotnet', 'C:\Program Files (x86)\dotnet' `
        -ProductPattern '^Microsoft (ASP\.NET Core|\.NET|Windows Desktop Runtime)\b|^Microsoft\.NET\.' `
        -EnvironmentVariables 'DOTNET_ROOT' -Force:$Force
}
