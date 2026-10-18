function Import-VendoredPester {
    [CmdletBinding()]
    param()

    $pesterPath = Join-Path (Get-CatzcModulesRoot) '.vendor/Pester'
    $versionPath = @(Get-ChildPath $pesterPath -Directory -Depth 1 -PruneVendor $false)
    Assert-True ($versionPath.Count -eq 1) -ErrorText "Import-VendoredPester: expected one vendored Pester version under '$pesterPath', found $($versionPath.Count)."
    $vendoredBase = [System.IO.Path]::GetFullPath($versionPath[0])

    $loaded = @(Get-Module Pester)
    if (@($loaded | Where-Object { [System.IO.Path]::GetFullPath($_.ModuleBase) -eq $vendoredBase }).Count -gt 0) {
        return
    }

    $replaced = ''
    if ($loaded.Count -gt 0) {
        $replaced = "; replaced $(($loaded | ForEach-Object { "Pester $($_.Version) from '$($_.ModuleBase)'" }) -join ', ')"
        Remove-Module -Name Pester -Force
    }
    $pester = Import-Module $pesterPath -Scope Global -Force -PassThru | Select-Object -First 1
    Write-Message "Loaded vendor module Pester $($pester.Version) from '$pesterPath'$replaced"
}
