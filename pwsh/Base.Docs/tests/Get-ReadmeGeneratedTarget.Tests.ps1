Describe 'Get-ReadmeGeneratedTarget' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'readme' } {
            [pscustomobject]@{ patterns = @([pscustomobject]@{ glob = 'widget/*' }); mappings = @([pscustomobject]@{ folder = 'gadget' }) }
        }
    }

    It 'answers a README per pattern and per mapping, by the given writer in the given class' {
        $rows = @(Get-ReadmeGeneratedTarget -Name 'Build-Sprocket' -Class 'untracked' | ForEach-Object { "$($_.path)|$($_.generator)|$($_.class)" })
        $rows | Should -Be @(
            'widget/*/README.md|Build-Sprocket|untracked'
            'gadget/README.md|Build-Sprocket|untracked'
        )
    }
}
