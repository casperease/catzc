function Invoke-GitCommit {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $Message,

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $Message -ErrorText 'Invoke-GitCommit: the commit message must not be empty or whitespace.'
    Assert-False $Message.Contains('"') -ErrorText "Invoke-GitCommit: the commit message must not contain a double quote (got: $Message)."

    $quotedPaths = foreach ($item in $Path) {
        "`"$item`""
    }
    $pathSpec = $quotedPaths -join ' '
    $addCommand = "git add -A -- $pathSpec"
    $commitCommand = "git commit -m `"$Message`" -- $pathSpec"

    if ($DryRun) {
        return @($addCommand, $commitCommand)
    }

    # Nothing changed under the given paths -> nothing to do (the idempotent no-op).
    if (-not (Test-GitPathChanged $Path)) {
        return
    }

    Invoke-Executable $addCommand -PassThru | Out-Null
    Invoke-Executable $commitCommand -PassThru | Out-Null
    Get-GitCurrentCommit
}
