function Get-VsCodeSession {
    [CmdletBinding()]
    [OutputType([Catzc.Base.VSCode.VscodeSession])]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot),

        [string] $LogRoot = (Join-Path ([System.Environment]::GetFolderPath('ApplicationData')) 'Code/logs')
    )

    Assert-IsRunningInVsCode

    Import-InternalModule Types
    $types = Get-LoadedTypeDrift -ModulesRoot $ModulesRoot

    $builds = [System.Collections.Generic.List[string]]::new()
    $held = [System.Collections.Generic.List[string]]::new()
    $compiled = Join-Path $ModulesRoot '.compiled'
    if (Test-Path -LiteralPath $compiled -PathType Container) {
        foreach ($dll in Get-ChildPath $compiled -File -Filter 'Catzc.Types.*.dll' -Depth 1) {
            $name = Split-Path $dll -Leaf
            $builds.Add($name)
            $holders = @(Get-FileLockingProcess $dll)
            if ($holders.Count) {
                $held.Add("$name held by $(($holders | ForEach-Object { $_.ToString() }) -join ', ')")
            }
        }
    }

    $contributed = @(Get-ChildItem env: | Where-Object {
            $_.Name -like 'VSCODE_*' -or $_.Name -like 'TERM_PROGRAM*' -or $_.Name -like 'COPILOT_*' -or $_.Name -like 'PYDEVD_*' -or
            $_.Name -in 'GIT_ASKPASS', 'PYTHONSTARTUP', 'BUNDLED_DEBUGPY_PATH'
        } | ForEach-Object Name | Sort-Object)

    $logSession = $null
    $logLines = @()
    if (Test-Path -LiteralPath $LogRoot -PathType Container) {
        $newest = Get-ChildPath $LogRoot -Directory -Depth 1 | Sort-Object { Split-Path $_ -Leaf } -Descending | Select-Object -First 1
        if ($newest) {
            $logSession = $newest
            $log = Get-ChildPath $newest -File -Filter 'PowerShell.log' -Depth 4 | Select-Object -First 1
            if ($log) {
                $logLines = @(Get-Content -LiteralPath $log | Where-Object { $_ -match 'Starting|started with PID|terminated|stopped' } | Select-Object -Last 6)
            }
        }
    }

    [Catzc.Base.VSCode.VscodeSession]::new(
        $Host.Name, $PID, $types.LoadedHash, $types.SourceHash, [bool] $types.Current, [string[]] @($types.Drift), [string[]] $builds.ToArray(),
        [string[]] $held.ToArray(), [string[]] $contributed, $logSession, [string[]] $logLines)
}
