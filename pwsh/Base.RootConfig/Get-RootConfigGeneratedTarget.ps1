function Get-RootConfigGeneratedTarget {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Name', Justification = 'Every expander takes the writer row''s name and class; this one names its generators from rootconfig.yml.')]
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Class
    )

    $classOf = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
        foreach ($row in (Get-Config -Config generated -Module $owner.Module).writers) {
            $classOf[$row.name] = $row.class
        }
    }

    # A copied root config is Build-RootConfig's; a rendered one is its generator's, in the class of its own row if it has one.
    foreach ($file in (Get-Config -Config rootconfig).files.Where({ $_.optIn })) {
        $generator = $file.generator ? $file.generator : 'Build-RootConfig'
        $generatorClass = $classOf.ContainsKey($generator) ? $classOf[$generator] : $Class
        [Catzc.Base.Variants.GeneratedTarget]::new($file.target, $generator, $generatorClass, [bool] $file.committed)
    }
}
