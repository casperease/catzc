Describe 'Get-AgentFrontMatter' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#1' {
    BeforeAll {
        function Write-AgentFixture {
            param([string] $Name, [string[]] $Text)
            $path = Join-Path $TestDrive $Name
            [System.IO.File]::WriteAllText($path, ($Text -join "`n") + "`n")
            $path
        }
    }

    It 'returns the front-matter keys in file order, with a folded description' {
        $path = Write-AgentFixture 'widget.md' @('---', 'name: widget', 'description: >', '  The widget agent.', '  Do NOT use it for gadgets.', 'tools: Read, Edit', '---', '', '# Widget')
        $result = InModuleScope Catzc.Base.Docs -Parameters @{ Path = $path } { Get-AgentFrontMatter -Path $Path }
        @($result.Keys) | Should -Be @('name', 'description', 'tools')
        $result['name'] | Should -Be 'widget'
        $result['description'] | Should -Be "The widget agent. Do NOT use it for gadgets.`n"
        $result['tools'] | Should -Be 'Read, Edit'
    }

    It 'throws when the first line is not ---' {
        $path = Write-AgentFixture 'gadget.md' "# Gadget`n"
        { InModuleScope Catzc.Base.Docs -Parameters @{ Path = $path } { Get-AgentFrontMatter -Path $Path } } |
            Should -Throw '*has no front matter*'
    }

    It 'throws when the front matter has no closing ---' {
        $path = Write-AgentFixture 'gadget.md' @('---', 'name: gadget')
        { InModuleScope Catzc.Base.Docs -Parameters @{ Path = $path } { Get-AgentFrontMatter -Path $Path } } |
            Should -Throw '*no closing ---*'
    }

    It 'throws when the front matter is not valid YAML' {
        $path = Write-AgentFixture 'gadget.md' @('---', 'name: [gadget', '---')
        { InModuleScope Catzc.Base.Docs -Parameters @{ Path = $path } { Get-AgentFrontMatter -Path $Path } } |
            Should -Throw '*not valid YAML*'
    }

    It 'throws when the front matter is not a mapping' {
        $path = Write-AgentFixture 'gadget.md' "---`n- gadget`n---`n"
        { InModuleScope Catzc.Base.Docs -Parameters @{ Path = $path } { Get-AgentFrontMatter -Path $Path } } |
            Should -Throw '*not a mapping*'
    }

    It 'throws when the front matter is empty' {
        $path = Write-AgentFixture 'gadget.md' "---`n---`n"
        { InModuleScope Catzc.Base.Docs -Parameters @{ Path = $path } { Get-AgentFrontMatter -Path $Path } } |
            Should -Throw '*not a mapping*'
    }
}
