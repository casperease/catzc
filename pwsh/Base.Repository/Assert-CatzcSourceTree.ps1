function Assert-CatzcSourceTree {
    [CmdletBinding()]
    param(
        [string] $Command
    )

    if ((Get-CatzcRunMode) -eq 'source') {
        return
    }

    $commandName = $Command
    if (-not $commandName) {
        $caller = (Get-PSCallStack)[1]
        $commandName = $caller.Command
    }

    throw "$commandName runs in catzc's source tree only; this session runs a built Catzc package ($(Get-CatzcModulesRoot)). Load catzc's own repository with importer.ps1 to use it."
}
