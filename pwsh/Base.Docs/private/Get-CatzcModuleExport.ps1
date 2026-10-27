function Get-CatzcModuleExport {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    # A module folder drops its namespace, so a loaded module is matched to its folder by where it loaded from, never by name.
    $all = @(Get-Module)
    # Folder = module, one level deep; Get-Module also reports function .ps1 files, so only an entry directly in the folder counts.
    $loaded = foreach ($folder in @(Get-ChildPath -Path $ModulesRoot -Depth 1 -Directory)) {
        $name = [System.IO.Path]::GetFileName("$folder".TrimEnd('\', '/'))
        if ($name.StartsWith('.')) {
            continue
        }
        $full = [System.IO.Path]::GetFullPath("$folder").TrimEnd('\', '/')
        foreach ($module in $all) {
            if (-not $module.Path) {
                continue
            }
            $from = [System.IO.Path]::GetFullPath([System.IO.Path]::GetDirectoryName($module.Path)).TrimEnd('\', '/')
            if ($from -ieq $full -and [System.IO.Path]::GetExtension($module.Path) -ne '.ps1') {
                $module
            }
        }
    }

    $ret = foreach ($module in ($loaded | Sort-Object Name -Unique)) {
        [pscustomobject]@{
            Module    = $module.Name
            Functions = @($module.ExportedFunctions.Keys | Sort-Object)
        }
    }

    $ret = @($ret)
    , $ret
}
