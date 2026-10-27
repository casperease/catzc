function Resolve-SharedConfigPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    $shared = @((Get-Config -Config editor-claims).shared_configs)
    Assert-True ($shared -ccontains $Name) -ErrorText "'$Name' is not a shared config, so it takes no editor claim (editor-claims.yml shared_configs: $($shared -join ', '))."
    # The file is found the way Get-Config finds it, so a claim names the one file every session's next import reads.
    $paths = @(Get-Config -Config $Name -ListOwners | ForEach-Object { $_.Path } | Where-Object { $_ })
    Assert-True ($paths.Count -eq 1) -ErrorText "Shared config '$Name' resolves to $($paths.Count) files, so no one file can be claimed."
    Assert-PathExist $paths[0] -PathType Leaf
    $paths[0]
}
