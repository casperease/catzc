Describe 'Get-GeneratedWriterOrder' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:owners = @(
            [pscustomobject] @{ Module = 'Widget' }
            [pscustomobject] @{ Module = 'Gadget' }
        )
        $script:configs = @{
            Widget = [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{ writers = [ordered]@{
                        'Build-Widget' = [ordered]@{ class = 'rollable'; inputs = @('gadget/index.md'); outputs = @('widget/index.md') }
                    }
                })
            Gadget = [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{ writers = [ordered]@{
                        'Build-Gadget' = [ordered]@{ class = 'rollable'; inputs = @('gadget.yml'); outputs = @('gadget/index.md') }
                    }
                })
        }
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.GeneratedFiles -ParameterFilter { $ListOwners } { $script:owners }
        Mock Get-Config -ModuleName Catzc.Base.GeneratedFiles -ParameterFilter { -not $ListOwners } { $script:configs[$Module] }
    }

    It 'reads every module that owns a generated.yml and renders the writers in graph order across modules' {
        $order = InModuleScope Catzc.Base.GeneratedFiles { Get-GeneratedWriterOrder }
        @($order | ForEach-Object name) | Should -Be @('Build-Gadget', 'Build-Widget')
        Should -Invoke Get-Config -ModuleName Catzc.Base.GeneratedFiles -ParameterFilter { $Config -eq 'generated' -and $ListOwners } -Times 1 -Exactly
    }

    It 'answers no writer when no module owns a generated.yml' {
        Mock Get-Config -ModuleName Catzc.Base.GeneratedFiles -ParameterFilter { $ListOwners } { }
        @(InModuleScope Catzc.Base.GeneratedFiles { Get-GeneratedWriterOrder }) | Should -HaveCount 0
    }
}
