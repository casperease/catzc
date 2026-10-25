Describe 'Get-TruthStore' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.Flow -ParameterFilter { $Config -eq 'truth-stores' } {
            [Catzc.Base.Flow.TruthStoresConfig]::new(@{ stores = [ordered]@{
                        'widget-repository' = @{ kind = 'version-controlled-repository' }
                        'widget-itsm'       = @{ kind = 'state-machine'; url = 'https://itsm.widget.example' }
                        'widget-runtime'    = @{ kind = 'fact-source'; url = 'https://runtime.widget.example'; owner = 'widget-itsm' }
                    }
                })
        }
    }

    It 'emits every store in declared order' -Tag 'TDR-ONETRUTH-TRUTHISQUERYABLE' {
        (Get-TruthStore).name | Should -Be @('widget-repository', 'widget-itsm', 'widget-runtime')
    }

    It 'filters by name and by kind' {
        $store = Get-TruthStore -Name widget-runtime
        $store | Should -BeOfType ([Catzc.Base.Flow.TruthStore])
        $store.owner | Should -BeExactly 'widget-itsm'
        (Get-TruthStore -StoreKind state-machine, version-controlled-repository).name | Should -Be @('widget-repository', 'widget-itsm')
    }

    Context 'the contract samples' {
        It 'the <name> sample validates against its schema' -ForEach @(
            @{ name = 'actionable-fact' }
            @{ name = 'junction-inbound' }
            @{ name = 'junction-outbound' }
        ) {
            $folder = Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/catzc.base.flow'
            $schema = [System.IO.File]::ReadAllText((Join-Path $folder "$name.schema.json"))
            [System.IO.File]::ReadAllText((Join-Path $folder "$name.sample.json")) | Test-Json -Schema $schema | Should -BeTrue
        }
    }
}
