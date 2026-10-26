function Invoke-Prettier {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    if ($File.Count -eq 0) {
        return , [string[]] @()
    }
    if (-not (Test-Command 'prettier')) {
        throw 'Prettier is not installed. Install it with:  Install-Prettier   (or: npm install -g prettier), then re-run Format-Code.'
    }

    $changed = [System.Collections.Generic.List[string]]::new()
    $checks = @(foreach ($batch in @(Split-CommandLineBatch -Item $File)) {
            $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
            "prettier --list-different $quoted"
        })
    # Each batch is its own node start, so the checks run side by side; the lists come back in batch order.
    foreach ($list in @(Invoke-ExecutableParallel -Command $checks -NoAssert -Silent)) {
        if ($list.ExitCode -gt 1) {
            throw "Prettier failed (exit $($list.ExitCode)): $($list.Full)"
        }
        # --list-different prints one differing path per line; strip any ANSI colour first.
        $plain = $list.Output -replace '\x1b\[[0-9;]*m', ''
        foreach ($line in ($plain -split '\r?\n')) {
            if ($line.Trim() -and $line -notmatch '^\[') {
                $changed.Add([System.IO.Path]::GetFullPath($line.Trim(), (Get-RepositoryRoot)))
            }
        }
    }

    if ($changed.Count -gt 0 -and -not $DryRun) {
        foreach ($batch in @(Split-CommandLineBatch -Item $changed.ToArray())) {
            $quoted = ($batch | ForEach-Object { "`"$_`"" }) -join ' '
            $write = Invoke-Executable "prettier --write $quoted" -PassThru -NoAssert -Silent
            if ($write.ExitCode -ne 0) {
                throw "Prettier failed (exit $($write.ExitCode)): $($write.Full)"
            }
        }
    }

    , [string[]] $changed.ToArray()
}
