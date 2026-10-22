function Get-FileMetaEngineStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $QualityGatesBase = (Get-Module -Name Catzc.Base.QualityGates).ModuleBase,

        [string] $LanguagesBase = (Get-Module -Name Catzc.Base.Languages).ModuleBase
    )

    # The engine's inputs are read from the loaded modules, so a fixture tree hashes the same code and registries the run uses.
    $paths = [System.Collections.Generic.List[string]]::new()
    $paths.Add((Join-Path $QualityGatesBase 'configs/file-meta.yml'))
    $paths.Add((Join-Path $LanguagesBase 'configs/file-carriers.yml'))
    foreach ($file in 'Format-FileMeta.ps1', 'Get-FileMetaFact.ps1', 'private/Invoke-FileMetaEngine.ps1') {
        $paths.Add((Join-Path $QualityGatesBase $file))
    }
    # Every fact processor is found by its name, as the engine finds it, so a new or edited processor changes the stamp.
    foreach ($folder in $QualityGatesBase, (Join-Path $QualityGatesBase 'private')) {
        if ([System.IO.Directory]::Exists($folder)) {
            foreach ($processor in [System.IO.Directory]::GetFiles($folder, 'Get-*FileMetaFact.ps1')) {
                $paths.Add($processor)
            }
        }
    }
    foreach ($type in 'FileMetaConfig.cs', 'FileMetaKind.cs', 'FileHeadPolicy.cs', 'HeadPolicy.cs') {
        $paths.Add((Join-Path $QualityGatesBase "types/$type"))
    }
    Get-InputStamp -Path ([string[]] @($paths | Sort-Object -Unique)) -Root $QualityGatesBase
}
