Describe 'Get-EngineCaseTable' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:table = Join-Path $TestDrive 'widget-cases.yml'
        Set-Content -LiteralPath $script:table -Value @'
subject: widget start
cases:
  - case: starts
    pwsh: { command: Start-Widget, expect: allow }
    bash: { command: start-widget, expect: allow }
    zsh: { command: start-widget, expect: allow }
  - case: pwsh only
    pwsh: { command: Get-Gadget, expect: allow }
    bash: "n/a: bash has no gadget"
    zsh: "n/a: zsh has no gadget"
'@
    }

    It 'returns one -ForEach-shaped row per case and engine' {
        $rows = @(Get-EngineCaseTable $table)
        $rows.Count | Should -Be 6
        $rows[0].Case | Should -Be 'starts'
        $rows[0].Engine | Should -Be 'pwsh'
        $rows[0].Fields.command | Should -Be 'Start-Widget'
        $rows[4].NotApplicable | Should -Be 'bash has no gadget'
    }

    It 'filters to one engine' {
        @(Get-EngineCaseTable $table -Engine bash).Engine | Should -Be @('bash', 'bash')
    }

    It 'skips the n/a cells with -Applicable' {
        @(Get-EngineCaseTable $table -Applicable).Count | Should -Be 4
        @(Get-EngineCaseTable $table -Engine bash -Applicable).Case | Should -Be 'starts'
    }

    It 'resolves a relative path against the repository root, never the current directory' {
        Mock Resolve-RepoPath -ModuleName Catzc.Tooling.Core { $script:table }
        @(Get-EngineCaseTable 'widget-cases.yml').Count | Should -Be 6
        Should -Invoke Resolve-RepoPath -ModuleName Catzc.Tooling.Core -Times 1 -Exactly -ParameterFilter { $Path -eq 'widget-cases.yml' }
    }

    It 'throws for a table that breaks the shape, naming the problem' {
        $broken = Join-Path $TestDrive 'broken-cases.yml'
        Set-Content -LiteralPath $broken -Value @(
            'subject: widget'
            'cases:'
            '  - case: c'
            '    pwsh: { command: x }'
        )
        { Get-EngineCaseTable $broken } | Should -Throw '*the bash column must be a map*'
    }
}

Describe 'Get-EngineCaseTable — every shipped engine case table' -Tag 'L1', 'integrity' {
    BeforeDiscovery {
        # Every per-engine fixture table in the repository: tests/assets/engine-cases/*.yml in any module.
        $root = Get-CatzcModulesRoot
        # A case table sits five levels below pwsh/ (module, tests, assets, engine-cases, file); vendored modules are pruned by the walk.
        $script:tables = @(Get-ChildPath $root -File -Filter '*.yml' -Depth 5 |
                Where-Object {
                    $folder = [System.IO.Path]::GetDirectoryName($_)
                    [System.IO.Path]::GetFileName($folder) -eq 'engine-cases' -and [System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName($folder)) -eq 'assets'
                } |
                ForEach-Object { @{ Name = [System.IO.Path]::GetFileName($_); Path = $_ } })
    }

    It 'finds at least one table' -ForEach @(@{ Found = $tables.Count }) {
        $Found | Should -BeGreaterThan 0
    }

    It '<Name> fills every engine column or names why not' -ForEach $tables {
        { Get-EngineCaseTable $Path } | Should -Not -Throw
    }
}
