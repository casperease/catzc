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

    # Every other generator's targets, each declared once in its module's generated.yml.
    foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
        foreach ($target in (Get-Config -Config generated -Module $owner.Module).targets) {
            $target
        }
    }
}
