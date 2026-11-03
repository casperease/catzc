function Assert-SourceTree {
    [CmdletBinding()]
    param(
        [string] $Command
    )

    if ((Get-CatzcRunMode) -eq 'source') {
        return
    }

    $variantsPath = [System.IO.Path]::Combine((Get-RepositoryRoot), '.catzc', 'configs', 'variants.yml')
    if ([System.IO.File]::Exists($variantsPath)) {
        $variants = [System.IO.File]::ReadAllText($variantsPath) | ConvertFrom-Yaml
        if ($variants -is [System.Collections.IDictionary] -and $variants.Contains('tracks') -and $variants['tracks'] -is [System.Collections.IDictionary] -and $variants['tracks'].Count -gt 0) {
            return
        }
    }

    $commandName = $Command
    if (-not $commandName) {
        $caller = (Get-PSCallStack)[1]
        $commandName = $caller.Command
    }

    throw "$commandName works on the tracks of the working root, and '$(Get-RepositoryRoot)' declares none beyond the engine's own pwsh. A consumer declares its own tracks under 'tracks' in .catzc/configs/variants.yml (ADR-AUTO-CONSUMER-OWNTRACKS)."
}
