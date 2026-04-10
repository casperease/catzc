<#
.SYNOPSIS
    Returns the current git commit hash (full 40-char SHA).
.EXAMPLE
    Get-GitCurrentCommit
#>
function Get-GitCurrentCommit {
    param()
    $ret = Invoke-Executable 'git rev-parse HEAD' -PassThru -Silent
    $ret.Output.Trim()
}
