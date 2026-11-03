function Resolve-RootConfigSource {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    if ((Get-CatzcRunMode) -ne 'build') {
        return Resolve-RepoPath $Path
    }

    # <code track>/<module folder>/<child path>: a built root holds the module folder under the code root, with the namespace on it.
    $part = $Path.Replace('\', '/').Split('/', 3)
    Assert-True ($part.Count -eq 3) -ErrorText "Resolve-RootConfigSource: '$Path' is not <code track>/<module folder>/<child path>."
    $moduleFolder = if ($part[1].StartsWith('.')) {
        Join-Path (Get-CatzcModulesRoot) $part[1]
    }
    else {
        Resolve-CodeModuleFolder $part[1]
    }
    Assert-NotNull $moduleFolder -ErrorText "Resolve-RootConfigSource: the built root holds no module folder for '$Path'."
    Join-Path $moduleFolder $part[2]
}
