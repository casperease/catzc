Describe 'Get-RepositoryTextSource' -Tag 'L0', 'logic' {
    It 'returns nothing outside a source, so a reader keeps to the working tree' {
        Get-RepositoryTextSource | Should -BeNullOrEmpty
    }

    It 'returns the active source''s name and its paths in ordinal order' {
        $source = Use-RepositoryTextSource -Name widget -Path 'gadget.yml', 'Gadget.yml', 'alpha.yml' -Text @{} -ScriptBlock {
            Get-RepositoryTextSource
        }
        $source.Name | Should -BeExactly 'widget'
        $source.Path | Should -Be @('Gadget.yml', 'alpha.yml', 'gadget.yml')
    }
}
