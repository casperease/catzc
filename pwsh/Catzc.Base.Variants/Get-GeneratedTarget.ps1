function Get-GeneratedTarget {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    param()

    # The root configs this repository renders: each opted-in rootconfig.yml target, by its generator; a target copied from its source
    # asset has none of its own, and Build-RootConfig is what writes it.
    foreach ($file in (Get-Config -Config rootconfig).files.Where({ $_.optIn })) {
        [Catzc.Base.Variants.GeneratedTarget]::new($file.target, ($file.generator ? $file.generator : 'Build-RootConfig'))
    }

    # The READMEs Build-Readme renders: one per folder a readme.yml pattern or mapping names.
    $readme = Get-Config -Config readme
    foreach ($pattern in $readme.patterns) {
        [Catzc.Base.Variants.GeneratedTarget]::new("$($pattern.glob)/README.md", 'Build-Readme')
    }
    foreach ($mapping in $readme.mappings) {
        [Catzc.Base.Variants.GeneratedTarget]::new("$($mapping.folder)/README.md", 'Build-Readme')
    }

    # The comment pages Format-Code's comment imprint writes: one tree per page root comment-pages.yml declares, a `{kebab}` root one
    # folder per module. The pages are the tool's, so they are generated like the READMEs (the user, 2026-10-25).
    $pageRoots = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($page in (Get-Config -Config comment-pages).pages) {
        $root = $page.docs -replace '\{[^}]+\}', '*'
        if ($pageRoots.Add($root)) {
            [Catzc.Base.Variants.GeneratedTarget]::new("$root/**", 'Format-Code')
        }
    }

    # Every other generator's targets, each declared once in its module's generated.yml.
    foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
        foreach ($target in (Get-Config -Config generated -Module $owner.Module).targets) {
            $target
        }
    }
}
