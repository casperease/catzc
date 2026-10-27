Describe 'Security-group flows: the compiled discovery template' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:folder = InModuleScope Catzc.Azure.Templates {
            # Its own folder, so a concurrent build of the same template never swaps the files read here.
            @(Build-Bicep discovery -OutputFolder (Join-Path (Get-PSDrive TestDrive).Root 'discovery'))[-1]
        }
        $script:main = [System.IO.File]::ReadAllText((Join-Path $script:folder 'main.json'))
        $script:parameterFiles = @(Get-ChildItem -LiteralPath $script:folder -Filter 'parameters.*.json')
    }

    # The evaluator does not yet resolve the toObject and indexed map lambdas the rules are built with, so the rule set is proven by the
    # declared flows every slot receives and the template's binding of them.
    It 'passes every slot the declared flows, no wider than the landing zone needs' {
        $declared = (Get-Config -Config network).nsg_flows
        $script:parameterFiles.Count | Should -BeGreaterThan 0
        foreach ($file in $script:parameterFiles) {
            $flows = @(([System.IO.File]::ReadAllText($file.FullName) | ConvertFrom-Json -AsHashtable).parameters.nsgFlows.value)
            @($flows.name) | Should -Be @($declared.name) -Because "$($file.Name) carries the network.yml flows"
            foreach ($flow in $flows) {
                $flow.from | Should -BeIn @('same-subnet', 'workload', 'shared-services') -Because "flow $($flow.name) names its source by role, never the whole network"
            }
        }
    }

    It 'replaces the blanket virtual-network allow with the declared flows, then a deny of the network and the internet' {
        $script:main | Should -Not -Match 'allow-virtual-network-inbound' -Because 'no rule allows the whole network'
        foreach ($binding in "'deny-virtual-network-inbound'", "'deny-internet-inbound'", 'concat(variables(''flowRules'')[', "parameters('nsgFlows')") {
            $script:main | Should -Match ([regex]::Escape($binding.Trim("'"))) -Because "the template holds $binding"
        }
    }
}
