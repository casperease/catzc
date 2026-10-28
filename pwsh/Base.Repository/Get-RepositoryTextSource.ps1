function Get-RepositoryTextSource {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    $source = $ExecutionContext.SessionState.PSVariable.GetValue('script:repositoryTextSource')
    if ($null -ne $source) {
        $source
    }
}
