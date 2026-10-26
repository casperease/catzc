function Find-ShadowingCommand {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Command
    )

    # Off Windows a process PATH is not built from a machine and a user part, so nothing shadows by order.
    if (-not $IsWindows) {
        return $null
    }

    # The order a GUI app, VS Code among them, builds its PATH in: the machine entries first, then the user's.
    $entries = @(((Get-EnvironmentPath -Scope Machine), (Get-EnvironmentPath -Scope User)) -join ';' -split ';' | Where-Object { $_ })
    $extensions = @('') + @(($env:PATHEXT ? $env:PATHEXT : '.COM;.EXE;.BAT;.CMD') -split ';' | Where-Object { $_ })
    foreach ($entry in $entries) {
        $folder = [System.Environment]::ExpandEnvironmentVariables($entry)
        foreach ($extension in $extensions) {
            $candidate = Join-Path $folder "$Command$extension"
            if ([System.IO.File]::Exists($candidate)) {
                return [System.IO.Path]::GetFullPath($candidate)
            }
        }
    }
    $null
}
