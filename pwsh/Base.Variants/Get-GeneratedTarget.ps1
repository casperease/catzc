function Get-GeneratedTarget {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    param()

    # Each opted-in root config is Build-RootConfig's target, copied or rendered.
    foreach ($file in (Get-Config -Config rootconfig).files.Where({ $_.optIn })) {
        [Catzc.Base.Variants.GeneratedTarget]::new($file.target,
            ($file.generator ? $file.generator : 'Build-RootConfig'))
    }

    # The READMEs Build-Readme renders: one per folder a readme.yml pattern or mapping names.
    $readme = Get-Config -Config readme
    foreach ($pattern in $readme.patterns) {
        [Catzc.Base.Variants.GeneratedTarget]::new("$($pattern.glob)/README.md", 'Build-Readme')
    }
    foreach ($mapping in $readme.mappings) {
        [Catzc.Base.Variants.GeneratedTarget]::new("$($mapping.folder)/README.md", 'Build-Readme')
    }

    # The comment pages are Format-Code's output, one tree per page root.
    $pageRoots = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($page in (Get-Config -Config comment-pages).pages) {
        if ($pageRoots.Add($page.docs)) {
            [Catzc.Base.Variants.GeneratedTarget]::new("$($page.docs)/**", 'Format-Code')
        }
    }

    # Every other generator's targets, each declared once in its module's generated.yml.
    foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
        foreach ($target in (Get-Config -Config generated -Module $owner.Module).targets) {
            $target
        }
    }
}
