<#
---
catzc:
  immutable:
    with_body_sha: "7f20e3ce8bc9"
  edges:
    code: pwsh/Catzc.Base.Flow/types/TruthStoresConfig.cs
    cites:
      - ADR-THES-STORES-THREEKINDS
---
#>

Describe 'TruthStoresConfig' -Tag 'L0', 'logic' {
    It 'defaults to the repository with the Azure DevOps configuration as its projection, and Azure DevOps runtime as a fact source' -Tag 'ADR-THES-STORES-THREEKINDS' {
        $config = [Catzc.Base.Flow.TruthStoresConfig]::new(@{})
        @($config.stores.name) | Should -Be @('repository', 'azure-devops', 'azure-devops-runtime')
        @($config.stores.kind) | Should -Be @('version-controlled-repository', 'state-machine', 'fact-source')
        @($config.stores[0].projections) | Should -Be @('azure-devops-configuration')
        $config.stores[2].owner | Should -BeExactly 'azure-devops'
    }

    It 'holds the three kinds of truth store and no other' {
        @([Catzc.Base.Flow.TruthStoresConfig]::Kinds) | Should -Be @('version-controlled-repository', 'fact-source', 'state-machine')
    }

    It 'reads a configured map in declared order, with a repository''s projections' {
        $config = [Catzc.Base.Flow.TruthStoresConfig]::new(@{ stores = [ordered]@{
                    'widget-repository' = @{ kind = 'version-controlled-repository'; projections = @('widget-gitops') }
                    'widget-itsm'       = @{ kind = 'state-machine'; url = 'https://itsm.widget.example' }
                    'widget-runtime'    = @{ kind = 'fact-source'; url = 'https://runtime.widget.example'; owner = 'widget-itsm' }
                }
            })
        @($config.stores.name) | Should -Be @('widget-repository', 'widget-itsm', 'widget-runtime')
        @($config.stores[0].projections) | Should -Be @('widget-gitops')
        @($config.stores[1].projections).Count | Should -Be 0
        $config.stores[2].url | Should -BeExactly 'https://runtime.widget.example'
    }

    It 'rejects <case>' -ForEach @(
        @{ case = 'an unknown top-level key'; Raw = @{ gadgets = @{} }; expect = "*unknown key 'gadgets'*" }
        @{ case = 'an empty map'; Raw = @{ stores = @{} }; expect = '*non-empty map*' }
        @{ case = 'a name not in kebab case'; Raw = @{ stores = @{ 'Widget_Store' = @{ kind = 'state-machine' } } }; expect = '*not kebab-case*' }
        @{ case = 'a store that is not a map'; Raw = @{ stores = @{ 'widget-store' = 'gadget' } }; expect = '*must be a map*' }
        @{ case = 'an unknown store key'; Raw = @{ stores = @{ 'widget-store' = @{ kind = 'state-machine'; colour = 'red' } } }; expect = "*unknown key 'colour'*" }
        @{ case = 'the adjacent store as a kind'; Raw = @{ stores = @{ 'widget-store' = @{ kind = 'adjacent-store' } } }; expect = "*kind 'adjacent-store' is not one of*" }
        @{ case = 'a URL that is not absolute http'; Raw = @{ stores = @{ 'widget-store' = @{ kind = 'state-machine'; url = 'widget.example' } } }; expect = '*not an absolute http or https URL*' }
        @{ case = 'a fact source with no owner'; Raw = @{ stores = @{ 'widget-runtime' = @{ kind = 'fact-source' } } }; expect = '*names the state machine that owns it*' }
        @{ case = 'an owner that is not a state machine'; Raw = @{ stores = [ordered]@{ 'widget-repository' = @{ kind = 'version-controlled-repository' }; 'widget-runtime' = @{ kind = 'fact-source'; owner = 'widget-repository' } } }; expect = "*owner 'widget-repository' is not a state machine*" }
        @{ case = 'projections on a store that is not a repository'; Raw = @{ stores = @{ 'widget-itsm' = @{ kind = 'state-machine'; projections = @('widget-gitops') } } }; expect = '*only a version-controlled repository lists projections*' }
        @{ case = 'projections that are not a list'; Raw = @{ stores = @{ 'widget-repository' = @{ kind = 'version-controlled-repository'; projections = 'widget-gitops' } } }; expect = '*projections must be a list*' }
        @{ case = 'a projection not in kebab case'; Raw = @{ stores = @{ 'widget-repository' = @{ kind = 'version-controlled-repository'; projections = @('Widget_GitOps') } } }; expect = "*projection 'Widget_GitOps' is not kebab-case*" }
    ) {
        { [Catzc.Base.Flow.TruthStoresConfig]::new($Raw) } | Should -Throw $expect
    }
}
