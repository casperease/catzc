function Get-GeneratedTarget {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    param()

    $rows = @(foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
            (Get-Config -Config generated -Module $owner.Module).writers
        })
    $classOf = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    foreach ($row in $rows) {
        $classOf[$row.name] = $row.class
    }

    # Each expanding config answers its instances once, however many rows point at it.
    $expanded = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($row in $rows) {
        if (-not $row.expands) {
            foreach ($output in $row.outputs) {
                [Catzc.Base.Variants.GeneratedTarget]::new($output.path, $row.name, $row.class)
            }
            continue
        }
        if (-not $expanded.Add($row.expands)) {
            continue
        }
        switch -CaseSensitive ($row.expands) {
            'rootconfig' {
                # A copied root config is Build-RootConfig's; a rendered one is its generator's, in the class of its own row if it has one.
                foreach ($file in (Get-Config -Config rootconfig).files.Where({ $_.optIn })) {
                    $generator = $file.generator ? $file.generator : 'Build-RootConfig'
                    $class = $classOf.ContainsKey($generator) ? $classOf[$generator] : $row.class
                    [Catzc.Base.Variants.GeneratedTarget]::new($file.target, $generator, $class)
                }
            }
            'readme' {
                $readme = Get-Config -Config readme
                foreach ($pattern in $readme.patterns) {
                    [Catzc.Base.Variants.GeneratedTarget]::new("$($pattern.glob)/README.md", $row.name, $row.class)
                }
                foreach ($mapping in $readme.mappings) {
                    [Catzc.Base.Variants.GeneratedTarget]::new("$($mapping.folder)/README.md", $row.name, $row.class)
                }
            }
            # A comment page is authored (ADR-REPO-COMMENTS-PAGEISAUTHORED), so the config that maps them answers no target.
            'comment-pages' {
            }
            default {
                throw "Get-GeneratedTarget: writer '$($row.name)' expands '$($row.expands)', which names no config it knows (rootconfig, readme, comment-pages)."
            }
        }
    }
}
