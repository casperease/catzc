function Get-FileMetaInputStamp {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File
    )

    # The engine and its registries decide every head, so a change to either re-imprints every file.
    $modulesRoot = Get-CatzcModulesRoot
    $engine = Get-InputStamp -Path ([Catzc.Base.QualityGates.FileMetaConfig]::EngineInputs($modulesRoot)) -Root $modulesRoot
    # Every file's stamp is the engine's, so it is hashed once.
    $digest = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes("engine:$engine")))
    $stamps = @{}
    foreach ($path in $File) {
        $stamps[[System.IO.Path]::GetFullPath($path)] = $digest
    }
    $stamps
}
