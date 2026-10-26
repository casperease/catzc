function Get-ModuleNamespace {
    # The module namespace the modules root's track declares (DDR-TRACK-MODULENAMESPACE), read before the types load.
    [CmdletBinding()]
    [OutputType([string])]
    param(
        # The modules root; its folder name is the track's name, and its variants config sits one module down.
        [Parameter(Mandatory)]
        [string] $ModulesRoot
    )

    $root = [System.IO.Path]::GetFullPath($ModulesRoot)
    if (-not (Test-Path variable:script:moduleNamespaces)) {
        $script:moduleNamespaces = @{}
    }
    if ($script:moduleNamespaces.ContainsKey($root)) {
        return $script:moduleNamespaces[$root]
    }

    # The bootstrap reads the declaration as text, one level, like the folder walk (ADR-PWSH-ENUM-EARLYLOADINGCODE): the track's entry
    # under tracks:, in its flow or block form, and its namespace key; none found means no namespace.
    $namespace = ''
    # A built bundle is no track place: its folders carry the full names PowerShell's module path needs, so it has no namespace.
    if ([System.IO.File]::Exists([System.IO.Path]::Combine($root, 'Import-Catzc.ps1'))) {
        $script:moduleNamespaces[$root] = $namespace
        return $namespace
    }
    $track =[System.IO.Path]::GetFileName($root.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar))
    $configs = @(foreach ($module in [System.IO.Directory]::GetDirectories($root)) {
            $path = [System.IO.Path]::Combine($module, 'configs', 'variants.yml')
            if ([System.IO.File]::Exists($path)) {
                $path
            }
        })
    if ($configs.Count -eq 1) {
        $text = [System.IO.File]::ReadAllText($configs[0])
        $entry = [regex]::Match($text, "(?ms)^  $([regex]::Escape($track)):(?<body>.*?)(?=^  \S|^\S|\z)")
        if ($entry.Success) {
            $declared = [regex]::Match($entry.Groups['body'].Value, '(?m)\bnamespace:\s*(?<name>[A-Z][A-Za-z0-9]*(?:\.[A-Z][A-Za-z0-9]*)*)')
            if ($declared.Success) {
                $namespace = $declared.Groups['name'].Value
            }
        }
    }
    $script:moduleNamespaces[$root] = $namespace
    $namespace
}
