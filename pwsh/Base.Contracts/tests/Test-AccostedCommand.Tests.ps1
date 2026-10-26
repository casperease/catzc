Describe 'Test-AccostedCommand' -Tag 'L0', 'logic', 'ADR-AUTO-ACCOSTED-ACCOSTEDONEREADER' {
    BeforeAll {
        $script:contract = {
            param([string] $Name, [hashtable] $Specs)
            $parameters = @(foreach ($key in $Specs.Keys) {
                    [Catzc.Base.Contracts.ContractParameter]::Parse($key, $Specs[$key])
                })
            [pscustomobject]@{ Name = $Name; parameters = $parameters; Signature = "$Name(...)" }
        }
        $script:find = {
            param([string] $Call)
            @(Test-AccostedCommand -Call $Call -Where 'widget-act: action.call' -RepositoryRoot 'widget-root')
        }
    }

    BeforeEach {
        Mock Get-CommandContract -ModuleName Catzc.Base.Contracts {
            & $script:contract 'get_widget' @{ path = 'string!'; depth = 'int' }
            & $script:contract 'set_widget' @{ path = 'string!' }
        }
    }

    It 'passes a call whose arguments fit, mutating verbs included' {
        @(& $script:find '{"get_widget": {"path": "widgets/a.wdg", "depth": 2}}').Count | Should -Be 0
        @(& $script:find '{"set_widget": {"path": "widgets/a.wdg"}}').Count | Should -Be 0
    }

    It 'reads the contracts from the given root' {
        $null = & $script:find '{"get_widget": {"path": "a"}}'
        Should -Invoke Get-CommandContract -ModuleName Catzc.Base.Contracts -Times 1 -Exactly -ParameterFilter { $RepositoryRoot -eq 'widget-root' }
    }

    It 'finds <Case>, naming where' -ForEach @(
        @{ Case = 'a command no contract names'; Call = '{"get_gizmo": {"path": "a"}}'; Message = "widget-act: action.call: 'get_gizmo' is no contracted command*" }
        @{ Case = 'an unknown parameter'; Call = '{"get_widget": {"path": "a", "colour": "red"}}'; Message = "*'get_widget' has no parameter 'colour'*" }
        @{ Case = 'a missing mandatory parameter'; Call = '{"get_widget": {"depth": 1}}'; Message = "*misses its mandatory parameter 'path'*" }
        @{ Case = 'a value of the wrong type'; Call = '{"get_widget": {"path": "a", "depth": "deep"}}'; Message = "*'depth' takes int*'deep' is not one*" }
    ) {
        $findings = @(& $script:find $Call)
        $findings.Count | Should -Be 1
        $findings[0] | Should -BeLike $Message
    }
}
