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

    foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
        foreach ($writer in (Get-Config -Config generated -Module $owner.Module).writers.Where({ -not $_.expands })) {
            foreach ($output in $writer.outputs) {
                [Catzc.Base.Variants.GeneratedTarget]::new($output.path, $writer.name)
            }
        }
    }
}
