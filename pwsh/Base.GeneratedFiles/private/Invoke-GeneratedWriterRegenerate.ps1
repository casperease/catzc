function Invoke-GeneratedWriterRegenerate {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Variants.GeneratedWriterRow] $Writer,

        [Parameter(Mandatory)]
        [Catzc.Base.Variants.GeneratedWriterRow[]] $Writers,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # The command line's first word names a tool of tools.yml and the rest are its arguments, so no free text is ever evaluated.
    $line = $Writer.regenerate.Trim()
    $tool = ($line -split '\s+', 2)[0]
    if ($null -eq (Get-Config -Config tools)[$tool]) {
        throw "Restore-Generated: the writer '$($Writer.name)' regenerates with '$tool', which tools.yml does not declare."
    }
    # The managed tool by its path, never a bare name off PATH.
    $probe = Resolve-ToolExecutable -Tool $tool
    if (-not $probe.Found) {
        throw "Restore-Generated: the writer '$($Writer.name)' regenerates with '$tool', which is not installed. Install it with its Install- command."
    }
    $arguments = $line.Substring($tool.Length)

    $paths = [string[]] @()
    if ($line.Contains('{path}') -or $line.Contains('{paths}')) {
        # The outputs are gone after a roll-off, so the paths come from the git index and the disk, never from a walk of the outputs alone.
        $globs = [string[]] @($Writer.outputs | ForEach-Object path)
        $folders = [string[]] @($globs | ForEach-Object { [Catzc.Base.Objects.GlobPattern]::new($_).LiteralPrefix } | ForEach-Object { $_ ? $_ : '.' })
        $candidates = [string[]] @(@(Get-GitTrackedPath -Path $folders) + @((Get-GeneratedWriterInputFile -InputGlob $globs -RepositoryRoot $RepositoryRoot).File))
        $paths = [string[]] @(Get-GeneratedWriterOutputPath -WriterRow $Writer -Writers $Writers -Path $candidates | ForEach-Object { "`"$_`"" })
    }
    $runs = if ($line.Contains('{paths}')) {
        # One run takes every path, so a writer that pays a start-up per run pays it once.
        if ($paths.Count -gt 0) {
            $arguments.Replace('{paths}', $paths -join ' ')
        }
    }
    elseif ($line.Contains('{path}')) {
        foreach ($path in $paths) {
            $arguments.Replace('{path}', $path)
        }
    }
    else {
        $arguments
    }
    foreach ($run in @($runs)) {
        $command = "`"$($probe.Path)`"$run"
        $result = Invoke-Executable $command -WorkingDirectory $RepositoryRoot -PassThru -NoAssert -Silent
        if ($result.ExitCode -ne 0) {
            throw "Restore-Generated: the writer '$($Writer.name)' failed (exit $($result.ExitCode)): $command`n$($result.Full)"
        }
    }
}
