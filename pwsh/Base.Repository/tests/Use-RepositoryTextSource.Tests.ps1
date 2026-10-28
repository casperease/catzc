Describe 'Use-RepositoryTextSource' -Tag 'L0', 'logic' {
    It 'holds the source for the script block alone and returns its output' {
        $inside = Use-RepositoryTextSource -Name widget -Path 'gadget.yml' -Text @{ 'gadget.yml' = 'k: v' } -ScriptBlock {
            (Get-RepositoryTextSource).Name
        }
        $inside | Should -BeExactly 'widget'
        Get-RepositoryTextSource | Should -BeNullOrEmpty
    }

    It 'restores the outer source after a nested one, and after a throw' {
        Use-RepositoryTextSource -Name widget -Path @() -Text @{} -ScriptBlock {
            Use-RepositoryTextSource -Name gadget -Path @() -Text @{} -ScriptBlock { (Get-RepositoryTextSource).Name } |
                Should -BeExactly 'gadget'
            (Get-RepositoryTextSource).Name | Should -BeExactly 'widget'
        }
        { Use-RepositoryTextSource -Name widget -Path @() -Text @{} -ScriptBlock { throw 'widget broke' } } |
            Should -Throw 'widget broke'
        Get-RepositoryTextSource | Should -BeNullOrEmpty
    }

    It 'refuses a text for a path the source does not list' {
        { Use-RepositoryTextSource -Name widget -Path 'gadget.yml' -Text @{ 'sprocket.yml' = 'k: v' } -ScriptBlock { } } |
            Should -Throw "*'sprocket.yml' has a text but is not a path of source 'widget'*"
    }
}
