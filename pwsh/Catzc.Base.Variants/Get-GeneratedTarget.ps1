<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Get-GeneratedTarget.ps1.md"
  header: "generated"
---
#>

function Get-GeneratedTarget {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    param()

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
