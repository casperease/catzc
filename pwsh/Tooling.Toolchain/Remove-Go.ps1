function Remove-Go {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '',
        Justification = '-InstallDir defaults to the go on PATH when that one is off-config, else the machine-wide folder, a decision over a command lookup and a config check that a declared default cannot hold (ADR-PWSH-PARAM-RESOLUTIONORDER)')]
    param(
        [Parameter(Position = 0)]
        [string] $InstallDir,

        [switch] $Force
    )

    $config = Get-ToolConfig -Tool 'go'
    $machineDefault = 'C:\Program Files\Go'

    # The default target is the go on PATH when that one is off-config, else the machine-wide folder; go.exe sits in the install's bin.
    if (-not $InstallDir) {
        $InstallDir = $machineDefault
        $command = Get-Command go -CommandType Application -ErrorAction Ignore | Select-Object -First 1
        if ($command) {
            $onPath = Split-Path (Split-Path $command.Source -Parent) -Parent
            if (-not (Test-ExpectedPackageManager -Config $config -Path $onPath)) {
                $InstallDir = $onPath
            }
        }
    }

    Remove-OffConfigInstall -Config $config -Label 'Go' -Tool 'Go' -InstallDir $InstallDir `
        -MachineFolders $machineDefault, 'C:\Program Files (x86)\Go' -ProductPattern '^Go Programming Language\b' `
        -ExtraPathDirs 'bin' -EnvironmentVariables 'GOROOT' -Force:$Force
}
