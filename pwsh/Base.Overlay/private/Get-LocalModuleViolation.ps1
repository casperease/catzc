function Get-LocalModuleViolation {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $RelativePath
    )

    # A folder never spells the modules track's namespace: the folder resolves to its full name, and the bundle names the fix.
    $name = [System.IO.Path]::GetFileName($Path)
    $namespace = (Get-Track -Name pwsh).namespace
    if ($namespace -and $name.StartsWith("$namespace.", [System.StringComparison]::OrdinalIgnoreCase)) {
        $short = $name.Substring($namespace.Length + 1)
        $full = [Catzc.Base.Variants.VariantTrack]::FullNameIn($namespace, $short)
        if (Get-Module -Name $full) {
            "${RelativePath}: a folder never spells the $namespace namespace; spell it $short to override $full"
        }
        else {
            "${RelativePath}: the $namespace namespace is reserved, and the bundle has no module $full; is it a missing bundle module, or a typo?"
        }
        return
    }

    $privateFolderName = (Get-Config -Config languages).FolderOf('private-function')
    $functionFiles = [System.Collections.Generic.List[string]]::new()
    # A violation anywhere in the module must surface, so the walk prunes nothing, a vendor folder included.
    $files = [string[]] @(Get-ChildPath $Path -File -Depth 64 -Exclude @() -PruneVendor $false)
    [System.Array]::Sort($files, [System.StringComparer]::Ordinal)
    foreach ($file in $files) {
        $relative = [System.IO.Path]::GetRelativePath($Path, $file).Replace('\', '/')
        $segments = $relative.Split('/')
        $isFolderFunction = $segments.Count -eq 1 -or ($segments.Count -eq 2 -and $segments[0] -ceq $privateFolderName)
        $isFunctionFile = $isFolderFunction -and $relative.EndsWith('.ps1',
            [System.StringComparison]::OrdinalIgnoreCase)
        if ($isFunctionFile) {
            $functionFiles.Add($file)
            foreach ($violation in @(Get-FunctionFileViolation -Path $file -RelativePath "$RelativePath/$relative")) {
                $violation
            }
        }
        elseif ($segments[0] -ceq 'types') {
            "${RelativePath}/${relative}: a local module carries no types/; a bundle compiles no C#"
        }
        elseif (-not (($segments.Count -eq 2 -and $segments[0] -ceq 'configs' -and $relative.EndsWith('.yml',
                        [System.StringComparison]::Ordinal)) -or
                ($segments.Count -ge 2 -and $segments[0] -cin 'assets', 'tests'))) {
            "${RelativePath}/${relative}: not part of a module; a local module holds <Function>.ps1, $privateFolderName/<Function>.ps1, configs/<config>.yml, assets/<path> and tests/<path>"
        }
    }
    if ($functionFiles.Count -eq 0) {
        "${RelativePath}: a local module has at least one function file"
    }

    foreach ($file in $functionFiles) {
        if ([System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($file)) -ceq $privateFolderName) {
            continue
        }
        $public = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $existing = Get-Command -Name $public -ErrorAction Ignore | Where-Object { $_.ModuleName -ne $name } |
            Select-Object -First 1
        if ($existing) {
            "${RelativePath}: public function $public takes the name of a command already loaded$(if ($existing.ModuleName) { " from $($existing.ModuleName)" }); to replace a bundled function, override it in its module's folder"
        }
    }
}
