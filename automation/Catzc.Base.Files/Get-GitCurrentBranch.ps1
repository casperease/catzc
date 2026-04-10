<#
.SYNOPSIS
    Returns the current git branch name (or 'HEAD' when detached).
.EXAMPLE
    Get-GitCurrentBranch
#>
function Get-GitCurrentBranch {
    param()
    $ret = Invoke-Executable 'git rev-parse --abbrev-ref HEAD' -PassThru -Silent
    $ret.Output.Trim()
}
