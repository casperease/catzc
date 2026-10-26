function Test-BuildSourceDirty {
    # .SYNOPSIS
    #     Returns whether the source root differs from its commit: a modified, staged, deleted or untracked file.
    # .DESCRIPTION
    #     Content decides, not stat data: a checkout with other line endings is still the same commit.
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot
    )

    $changed = Invoke-Executable 'git --no-optional-locks diff --quiet HEAD -- .' -WorkingDirectory $SourceRoot -PassThru -Silent -NoAssert
    if ($changed.ExitCode -ne 0) {
        return $true
    }
    $untracked = Invoke-Executable 'git --no-optional-locks ls-files --others --exclude-standard -- .' -WorkingDirectory $SourceRoot -PassThru -Silent
    -not [string]::IsNullOrWhiteSpace([string] $untracked.Output)
}
