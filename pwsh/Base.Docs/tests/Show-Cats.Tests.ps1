Describe 'Show-Cats' -Tag 'L0', 'logic' {
    It 'prints the overview with no argument, without reading the getters' {
        Mock Get-DrsIndex -ModuleName Catzc.Base.Docs
        Mock Get-CatzcModules -ModuleName Catzc.Base.Docs
        { Show-Cats } | Should -Not -Throw
        Should -Invoke Get-DrsIndex -ModuleName Catzc.Base.Docs -Times 0
        Should -Invoke Get-CatzcModules -ModuleName Catzc.Base.Docs -Times 0
    }

    It 'routes the adr area to Get-DrsIndex' {
        Mock Get-DrsIndex -ModuleName Catzc.Base.Docs { @() }
        Show-Cats adr
        Should -Invoke Get-DrsIndex -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'routes an adr query through Get-DrsRules for each match' {
        Mock Get-DrsIndex -ModuleName Catzc.Base.Docs {
            @([pscustomobject]@{ Code = 'ADR-ALPHA'; Title = 'alpha-thing'; Path = 'principles/alpha-thing.md' })
        }
        Mock Get-DrsRules -ModuleName Catzc.Base.Docs { @([pscustomobject]@{ Id = 'ADR-ALPHA-BETA-TURN'; Summary = 's' }) }
        Mock Get-RuleEnforcers -ModuleName Catzc.Base.Docs { @{} }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs { 'TestDrive:/fake.md' }
        Show-Cats adr alpha
        Should -Invoke Get-DrsRules -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'looks up the enforcers for a matched ADR query' {
        Mock Get-DrsIndex -ModuleName Catzc.Base.Docs {
            @([pscustomobject]@{ Code = 'ADR-ALPHA'; Title = 'alpha-thing'; Path = 'principles/alpha-thing.md' })
        }
        Mock Get-DrsRules -ModuleName Catzc.Base.Docs { @([pscustomobject]@{ Id = 'ADR-ALPHA-BETA-TURN'; Summary = 's' }) }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs { 'TestDrive:/fake.md' }
        Mock Get-RuleEnforcers -ModuleName Catzc.Base.Docs { @{} }
        Show-Cats adr alpha
        Should -Invoke Get-RuleEnforcers -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'routes the module area to Get-CatzcModules' {
        Mock Get-CatzcModules -ModuleName Catzc.Base.Docs { @() }
        Show-Cats module
        Should -Invoke Get-CatzcModules -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'routes the verbs area to Get-CatzcModules' {
        Mock Get-CatzcModules -ModuleName Catzc.Base.Docs { @() }
        Show-Cats verbs
        Should -Invoke Get-CatzcModules -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'throws on an unknown area' {
        { Show-Cats bogus } | Should -Throw '*unknown area*'
    }
}
