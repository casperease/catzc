function Get-ContractLayoutFindings {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $contractsRoot = Join-Path $RepositoryRoot 'contracts'
    if (-not [System.IO.Directory]::Exists($contractsRoot)) {
        return
    }

    $current = [Catzc.Base.Contracts.ContractLayout]::CurrentVersion
    $provided = [Catzc.Base.Contracts.ContractLayout]::ProvidedRoot
    $local = "$((Get-Config -Config exporter).direct_install_version)"
    $layout = [Catzc.Base.Contracts.ContractLayout]::new((Get-Config -Config folder-walk))
    foreach ($rootFolder in $layout.Folders($contractsRoot)) {
        $root = [System.IO.Path]::GetFileName($rootFolder)
        foreach ($versionFolder in $layout.Folders($rootFolder)) {
            $version = [System.IO.Path]::GetFileName($versionFolder)
            if ($version -cnotmatch '^[0-9]+\.[0-9]+\.[0-9]+$' -or $version -ceq $current) {
                continue
            }
            $name = "contracts/$root/$version/"
            if ($version -ceq $local) {
                "$name is the local build version, which names a build made on a devbox and is never a contract folder (ADR-REPO-CONTRACT-CURRENTVERSION)."
            }
            elseif ([int] $version.Split('.')[0] -eq 0) {
                "$name is neither the current version $current nor a release; the current contracts live in $current, and 0.0.0 is never a folder (ADR-REPO-CONTRACT-CURRENTVERSION)."
            }
            elseif ($root -cne $provided) {
                "$name is a release folder under the vendor root '$root'; only $provided releases, and a vendor root follows its vendor in $current (ADR-REPO-CONTRACT-KEPTWHILEPINNED)."
            }
        }
    }
}
