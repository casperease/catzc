function Get-GitWorkspace {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    "$(Get-Variant -Name git_workspace)"
}
