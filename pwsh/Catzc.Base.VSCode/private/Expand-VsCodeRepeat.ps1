<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/private/Expand-VsCodeRepeat.ps1.md"
  header: "generated"
---
#>

function Expand-VsCodeRepeat {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $Contributes
    )

    $expanded = [ordered]@{}
    foreach ($name in $Contributes.Keys) {
        if ($name -ne 'repeat') {
            $expanded[$name] = $Contributes[$name]
        }
    }
    if (-not $Contributes.Contains('repeat')) {
        return $expanded
    }

    $read = {
        param($Item, [string] $Key)
        if ($Item -is [System.Collections.IDictionary]) {
            $Item[$Key]
        }
        else {
            $Item.$Key
        }
    }
    # Each source: the declared leading items, the items of a config's list, then the declared trailing items, as { value, title, position }.
    $sources = @{}
    foreach ($name in $Contributes['repeat'].Keys) {
        $source = $Contributes['repeat'][$name]
        foreach ($required in 'config', 'list', 'key') {
            if (-not $source.Contains($required)) {
                throw "Expand-VsCodeRepeat: repeat '$name' names no $required."
            }
        }
        $items = @($source['first'] | Where-Object { $null -ne $_ }) + @(& $read (Get-Config -Config $source['config']) $source['list']) +
        @($source['plus'] | Where-Object { $null -ne $_ })
        # A source that names a where field keeps only the items that carry a value for it (the languages with a tag).
        if ($source.Contains('where')) {
            $items = @($items | Where-Object { & $read $_ $source['where'] })
        }
        $position = 0
        $sources[$name] = @(foreach ($item in $items) {
                $position++
                [pscustomobject]@{
                    Value    = "$(& $read $item $source['key'])"
                    Title    = if ($source.Contains('title')) {
                        "$(& $read $item $source['title'])"
                    }
                    else {
                        ''
                    }
                    Position = $position
                }
            })
    }

    $fill = $null
    $fill = {
        param($Node, [string] $Name, $Item)
        if ($Node -is [string]) {
            return $Node.Replace("{$Name.title}", $Item.Title).Replace("{$Name.position}", "$($Item.Position)").Replace("{$Name}", $Item.Value)
        }
        if ($Node -is [System.Collections.IDictionary]) {
            $copy = [ordered]@{}
            foreach ($key in $Node.Keys) {
                if ($key -ne 'repeat') {
                    $copy[$key] = & $fill $Node[$key] $Name $Item
                }
            }
            return $copy
        }
        if ($Node -is [System.Collections.IList]) {
            return , @(foreach ($entry in $Node) {
                    & $fill $entry $Name $Item
                })
        }
        $Node
    }
    # A list entry that names a repeat becomes one entry per item of its source, in source order.
    $repeatList = {
        param($List)
        $out = [System.Collections.Generic.List[object]]::new()
        foreach ($entry in $List) {
            $name = if ($entry -is [System.Collections.IDictionary] -and $entry.Contains('repeat')) {
                "$($entry['repeat'])"
            }
            if (-not $name) {
                $out.Add($entry)
                continue
            }
            if (-not $sources.ContainsKey($name)) {
                throw "Expand-VsCodeRepeat: an entry repeats '$name', which the repeat block does not declare."
            }
            foreach ($item in $sources[$name]) {
                $out.Add((& $fill $entry $name $item))
            }
        }
        , $out
    }
    if ($expanded.Contains('commands')) {
        $expanded['commands'] = & $repeatList $expanded['commands']
    }
    if ($expanded.Contains('menus')) {
        $menus = [ordered]@{}
        foreach ($place in $expanded['menus'].Keys) {
            $menus[$place] = & $repeatList $expanded['menus'][$place]
        }
        $expanded['menus'] = $menus
    }
    $expanded
}
