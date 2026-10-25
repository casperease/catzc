Describe 'New-Solution' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-CatzcModulesFolder -ModuleName Catzc.Base.TypesSystem { 'pwsh' }
    }

    It 'lists the types project and every hook, each hook nested under .claude/hooks' {
        Mock Get-AgentHookName -ModuleName Catzc.Base.TypesSystem { , [string[]] @('Gadget-Hook', 'Widget-Hook') }
        $solution = New-Solution
        $solution | Should -Match ([regex]::Escape('"Catzc.Types", "pwsh\.internal\assets\Catzc.Types.csproj"'))
        foreach ($hook in 'Gadget-Hook', 'Widget-Hook') {
            $projectId = "$(ConvertTo-Guid "$($hook.Replace('-', ' ').ToLowerInvariant()) hook project")".ToUpperInvariant()
            # Gadget-Hook and Widget-Hook carry no inner capital, so the sentence is the name's words as written.
            $hooksId = "$(ConvertTo-Guid 'claude hooks folder')".ToUpperInvariant()
            $solution | Should -Match ([regex]::Escape("`"$hook`", `".claude\hooks\$hook\$hook.csproj`", `"{$projectId}`""))
            $solution | Should -Match ([regex]::Escape("{$projectId} = {$hooksId}"))
            $solution | Should -Match ([regex]::Escape("{$projectId}.Debug|Any CPU.Build.0"))
        }
    }

    It 'keeps the ids the solution has always carried' {
        Mock Get-AgentHookName -ModuleName Catzc.Base.TypesSystem { , [string[]] @('Assert-BashTimeout', 'Record-AgentWrite') }
        $solution = New-Solution
        $solution | Should -Match 'CA72C000-700E-5000-0000-EC7000000000'
        $solution | Should -Match 'A55E0700-BA50-710E-0070-000000000000'
        $solution | Should -Match '0EC00D00-A6E0-7000-0017-E00000000000'
        $solution | Should -Match 'C1A0DE00-0000-5000-F01D-E00000000000'
    }

    It 'leaves the folders out when there is no hook' {
        Mock Get-AgentHookName -ModuleName Catzc.Base.TypesSystem { , [string[]] @() }
        $solution = New-Solution
        $solution | Should -Not -Match 'NestedProjects'
        $solution | Should -Not -Match '"hooks"'
        $solution | Should -Match '(?m)^EndGlobal$'
    }
}
