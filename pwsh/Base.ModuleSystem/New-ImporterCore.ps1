function New-ImporterCore {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    # The core is the module that decides the mix, this one, and every module it is declared to need.
    $core = $ExecutionContext.SessionState.Module.Name
    $closure = @(Get-ModuleDependencyClosure -Module $core)

    $folderOf = @{}
    foreach ($module in Get-CatzcModule -EngineTrack -RepositoryRoot $RepositoryRoot) {
        $folderOf[$module.name] = [System.IO.Path]::GetFileName($module.root.TrimEnd('/', '\'))
    }

    $folders = [System.Collections.Generic.List[string]]::new()
    foreach ($name in $closure) {
        if (-not $folderOf.ContainsKey($name)) {
            throw "New-ImporterCore: module '$name' of the core's closure has no folder in the code root."
        }
        $folders.Add($folderOf[$name])
    }
    $folders.Sort([System.StringComparer]::Ordinal)

    ($folders -join "`n") + "`n"
}
