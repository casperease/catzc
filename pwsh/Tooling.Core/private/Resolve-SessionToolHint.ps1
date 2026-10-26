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

        # PATHEXT is empty on Unix, so only the bare name is probed there, plus the executable extensions on Windows.
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

        # The hint dir is appended, so one that also holds a python.exe (an az uv-venv Scripts dir) cannot shadow the managed python.
        $sep = [System.IO.Path]::PathSeparator
        if (($env:PATH -split $sep) -notcontains $dir) {
            $env:PATH = "$env:PATH$sep$dir"
            Write-Message "Session PATH: appended '$dir' so $($Config.command) resolves (session_path_hints)"
        }
        # -First 1, since the command may now resolve in several PATH dirs and an array's .Source would break the [string] -Location binding.
        return Get-Command $Config.command -CommandType Application -ErrorAction Ignore | Select-Object -First 1
    }

    return $null
}
