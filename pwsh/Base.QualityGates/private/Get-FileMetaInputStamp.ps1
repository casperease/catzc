function Get-FileMetaInputStamp {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    # The engine and its registries decide every head, so a change to either re-imprints every file.
    $modulesRoot = Get-CatzcModulesRoot
    $engine = Get-InputStamp -Path ([Catzc.Base.QualityGates.FileMetaConfig]::EngineInputs($modulesRoot)) -Root $modulesRoot
    $parts = [ordered]@{}
    foreach ($path in $File) {
        $full = [System.IO.Path]::GetFullPath($path)
        $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
        $fileParts = [System.Collections.Generic.List[string]]::new()
        $fileParts.Add("engine:$engine")
        $parts[$relative] = @($full, $fileParts)
    }
    $stamps = @{}
    foreach ($pair in $parts.Values) {
        $stamps[$pair[0]] = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($pair[1] -join "`n")))
    }
    $stamps
}
