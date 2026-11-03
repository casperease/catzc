function Get-TestFileModule {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $modulesRoot = [System.IO.Path]::Combine((Get-RepositoryRoot), (Get-CatzcModulesFolder))
    if (-not $Path.StartsWith($modulesRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        $folder = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
        foreach ($testFolder in @(Get-LanguageTestFolders)) {
            if ($testFolder.Folder -eq $folder) {
                return $testFolder.Module
            }
        }
        $trackModule = Get-TrackModuleName $Path
        if ($trackModule) {
            return $trackModule
        }
        throw "'$Path' is neither under $modulesRoot nor a language test folder (Get-LanguageTestFolders), nor under a place of a consumer modules track (Get-TrackModuleName)."
    }
    $relative = $Path.Substring($modulesRoot.Length).TrimStart('\', '/')
    ($relative -split '[\\/]')[0]
}
