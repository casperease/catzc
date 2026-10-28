function Use-RepositoryTextSource {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Text,

        [Parameter(Mandatory)]
        [scriptblock] $ScriptBlock
    )

    $listed = [System.Collections.Generic.HashSet[string]]::new($Path, [System.StringComparer]::Ordinal)
    foreach ($loaded in $Text.Keys) {
        Assert-True ($listed.Contains([string] $loaded)) -ErrorText "Use-RepositoryTextSource: '$loaded' has a text but is not a path of source '$Name'."
    }
    $sorted = [string[]] @($Path)
    [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
    $previous = $ExecutionContext.SessionState.PSVariable.GetValue('script:repositoryTextSource')
    $script:repositoryTextSource = @{ Name = $Name; Path = $sorted; Listed = $listed; Text = $Text }
    try {
        & $ScriptBlock
    }
    finally {
        $script:repositoryTextSource = $previous
    }
}
