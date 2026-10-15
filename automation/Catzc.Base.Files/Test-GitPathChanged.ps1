<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Test-GitPathChanged.ps1
    kind: gate-function
    module: Catzc.Base.Files
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether anything under the given repository paths differs from HEAD.
.DESCRIPTION
    The one changed-paths question that the committer's no-op and its policy callers both ask, so it lives once.
.PARAMETER Path
    The repository-relative, '/'-separated paths (files or folders) to check.
.OUTPUTS
    [bool]
.EXAMPLE
    Test-GitPathChanged 'automation/.compiled'
.EXAMPLE
    Test-GitPathChanged 'automation/.compiled', 'out'
#>
function Test-GitPathChanged {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path
    )

    $quotedPaths = foreach ($item in $Path) {
        "`"$item`""
    }
    $status = Invoke-Executable "git status --porcelain -- $($quotedPaths -join ' ')" -PassThru -Silent
    -not [string]::IsNullOrWhiteSpace($status.Output)
}
