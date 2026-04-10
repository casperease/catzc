Describe 'Show-Cats' -Tag 'L0', 'logic' {
    It 'prints the overview with no argument, without reading the getters' {
        Mock Get-CatsAdrIndex -ModuleName Catzc.Base.Docs
        Mock Get-CatsModules -ModuleName Catzc.Base.Docs
        { Show-Cats } | Should -Not -Throw
        Should -Invoke Get-CatsAdrIndex -ModuleName Catzc.Base.Docs -Times 0
        Should -Invoke Get-CatsModules -ModuleName Catzc.Base.Docs -Times 0
    }

    It 'routes the adr area to Get-CatsAdrIndex' {
        Mock Get-CatsAdrIndex -ModuleName Catzc.Base.Docs { @() }
        Show-Cats adr
        Should -Invoke Get-CatsAdrIndex -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'routes an adr query through Get-CatsAdrRules for each match' {
        Mock Get-CatsAdrIndex -ModuleName Catzc.Base.Docs {
            @([pscustomobject]@{ Code = 'ADR-ALPHA'; Title = 'alpha-thing'; Path = 'principles/alpha-thing.md' })
        }
        Mock Get-CatsAdrRules -ModuleName Catzc.Base.Docs { @([pscustomobject]@{ Id = 'ADR-ALPHA:1'; Summary = 's' }) }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs { 'TestDrive:/fake.md' }
        Show-Cats adr alpha
        Should -Invoke Get-CatsAdrRules -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'routes the module area to Get-CatsModules' {
        Mock Get-CatsModules -ModuleName Catzc.Base.Docs { @() }
        Show-Cats module
        Should -Invoke Get-CatsModules -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'routes the verbs area to Get-CatsModules' {
        Mock Get-CatsModules -ModuleName Catzc.Base.Docs { @() }
        Show-Cats verbs
        Should -Invoke Get-CatsModules -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'throws on an unknown area' {
        { Show-Cats bogus } | Should -Throw '*unknown area*'
    }
}
