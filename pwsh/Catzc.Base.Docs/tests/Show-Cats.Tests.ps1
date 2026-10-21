<#
---
catzc:
  immutable:
    with_body_sha: "8732c1f0c6ab"
  edges:
    code: pwsh/Catzc.Base.Docs/Show-Cats.ps1
---
#>

Describe 'Show-Cats' -Tag 'L0', 'logic' {
    It 'prints the overview with no argument, without reading the getters' {
        Mock Get-CatsDrsIndex -ModuleName Catzc.Base.Docs
        Mock Get-CatsModules -ModuleName Catzc.Base.Docs
        { Show-Cats } | Should -Not -Throw
        Should -Invoke Get-CatsDrsIndex -ModuleName Catzc.Base.Docs -Times 0
        Should -Invoke Get-CatsModules -ModuleName Catzc.Base.Docs -Times 0
    }

    It 'routes the adr area to Get-CatsDrsIndex' {
        Mock Get-CatsDrsIndex -ModuleName Catzc.Base.Docs { @() }
        Show-Cats adr
        Should -Invoke Get-CatsDrsIndex -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'routes an adr query through Get-CatsDrsRules for each match' {
        Mock Get-CatsDrsIndex -ModuleName Catzc.Base.Docs {
            @([pscustomobject]@{ Code = 'ADR-ALPHA'; Title = 'alpha-thing'; Path = 'principles/alpha-thing.md' })
        }
        Mock Get-CatsDrsRules -ModuleName Catzc.Base.Docs { @([pscustomobject]@{ Id = 'ADR-ALPHA-BETA-TURN'; Summary = 's' }) }
        Mock Get-CatsRuleEnforcers -ModuleName Catzc.Base.Docs { @{} }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs { 'TestDrive:/fake.md' }
        Show-Cats adr alpha
        Should -Invoke Get-CatsDrsRules -ModuleName Catzc.Base.Docs -Times 1
    }

    It 'looks up the enforcers for a matched ADR query' {
        Mock Get-CatsDrsIndex -ModuleName Catzc.Base.Docs {
            @([pscustomobject]@{ Code = 'ADR-ALPHA'; Title = 'alpha-thing'; Path = 'principles/alpha-thing.md' })
        }
        Mock Get-CatsDrsRules -ModuleName Catzc.Base.Docs { @([pscustomobject]@{ Id = 'ADR-ALPHA-BETA-TURN'; Summary = 's' }) }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs { 'TestDrive:/fake.md' }
        Mock Get-CatsRuleEnforcers -ModuleName Catzc.Base.Docs { @{} }
        Show-Cats adr alpha
        Should -Invoke Get-CatsRuleEnforcers -ModuleName Catzc.Base.Docs -Times 1
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
