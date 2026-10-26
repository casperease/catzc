function Get-GuidScanFiles {
    [CmdletBinding()]
    param()

    # The scan's universe and exclusions are the source repository's layout.
    Assert-SourceTree

    $tracked = Get-GitTrackedPath '.'

    $binaryExtensions = @('.dll', '.exe', '.png', '.jpg', '.jpeg', '.gif', '.ico', '.gz', '.zip', '.pdf', '.woff',
        '.woff2', '.ttf')
    $registryFile = ConvertTo-RepoRelativePath (Get-CatzcModuleRoot 'configs/guids.yml')
    $modulesFolder = Get-CatzcModulesFolder

    foreach ($file in $tracked) {
        if ($file.StartsWith("$modulesFolder/.vendor/")) {
            continue
        }
        if ($file.StartsWith("$modulesFolder/.compiled/")) {
            continue
        }
        if ($file -eq $registryFile) {
            continue
        }
        $extension = [System.IO.Path]::GetExtension($file).ToLowerInvariant()
        if ($extension -in $binaryExtensions) {
            continue
        }
        $file
    }
}
