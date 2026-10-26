Describe 'Get-RepositoryFilter — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:filters = @(Get-RepositoryFilter)
        $script:tracked = @(Get-TrackedFile)
        # A filter's sets read through the repository's own GlobSet: an include matches and no exclude does.
        $script:globSets = {
            param([object[]] $Sets)
            foreach ($set in $Sets) {
                [Catzc.Base.Globs.GlobSet]::new('filter-set', 'd', 'loose-fileset', [string[]]@($set.include),
                    [string[]]@($set.exclude), @(), @(), -1, $null)
            }
        }
    }

    It 'resolves every declared filter, in order, to at least one include/exclude set' {
        @($script:filters.name) | Should -Be @((Get-Config -Config filters).filters.ForEach({ $_.name }))
        foreach ($filter in $script:filters) {
            @($filter.sets).Count | Should -BeGreaterThan 0 -Because "filter '$($filter.name)' selects something"
            foreach ($set in $filter.sets) {
                @($set.include).Count |
                    Should -BeGreaterThan 0 -Because "every set of '$($filter.name)' includes something"
            }
        }
    }

    It 'carries an aspect''s sets as the aspect model holds them, its excludes included' {
        $aspects = Get-AspectGlobSet
        $live = $script:filters.Where({ $_.name -ceq 'live' })[0]
        @($live.sets).Count | Should -Be @($aspects['live']).Count
        $tests = $script:filters.Where({ $_.name -ceq 'tests' })[0]
        @($tests.sets).Where({ @($_.exclude).Count -gt 0 }).Count |
            Should -BeGreaterThan 0 -Because 'a module''s tests set is the unit minus its live patterns'
    }

    It 'gives the pipeline and workflow definitions their own filter and keeps them out of the vendor tools' {
        $claims = {
            param([string] $Filter, [string] $Path)
            $sets = & $script:globSets @($script:filters.Where({ $_.name -ceq $Filter })[0].sets)
            $sets.Where({ $_.Matches($Path) }, 'First').Count -gt 0
        }
        foreach ($path in '.github/workflows/ci.yaml', '.ado/pipelines/ci-pwsh.yaml') {
            & $claims 'pipelines' $path | Should -BeTrue -Because "'$path' is a pipeline definition"
            & $claims 'tools' $path |
                Should -BeFalse -Because "'$path' belongs to its own track, not to the vendor settings around it"
        }
        & $claims 'tools' '.github/README.md' | Should -BeTrue -Because 'the rest of .github stays vendor settings'
        & $claims 'infrastructure' 'infrastructure/modules/data-factory.bicep' | Should -BeTrue
        & $claims 'code' 'infrastructure/modules/data-factory.bicep' |
            Should -BeTrue -Because 'the Bicep tree stays live'
        & $claims 'code' '.github/workflows/ci.yaml' |
            Should -BeTrue -Because 'the workflows are live, as the Bicep tree is'
    }

    It 'gives the configuration part of everything as code its own filter, through the config file kind, and keeps it live' {
        $claims = {
            param([string] $Filter, [string] $Path)
            $sets = & $script:globSets @($script:filters.Where({ $_.name -ceq $Filter })[0].sets)
            $sets.Where({ $_.Matches($Path) }, 'First').Count -gt 0
        }
        foreach ($path in 'pwsh/Catzc.Base.Globs/configs/filters.yml',
            'infrastructure/templates/discovery/configuration/apex/nsub.yml',
            'python/catzc_diagrams/configs/drawio.yml') {
            & $claims 'configs' $path | Should -BeTrue -Because "'$path' is configuration"
            & $claims 'live' $path | Should -BeTrue -Because "'$path' stays live"
            & $claims 'code' $path | Should -BeFalse -Because "'$path' is configuration, not code"
        }
        & $claims 'configs' 'pwsh/Catzc.Base.Globs/Get-RepositoryFilter.ps1' |
            Should -BeFalse -Because 'a function is code, not configuration'
        { Get-RepositoryFilter -Name code | Out-Null } | Should -Not -Throw
    }

    It 'splits the live aspect: code is its executable part by extension, live is all of it, and neither takes a test' {
        $claims = {
            param([string] $Filter, [string] $Path)
            $sets = & $script:globSets @($script:filters.Where({ $_.name -ceq $Filter })[0].sets)
            $sets.Where({ $_.Matches($Path) }, 'First').Count -gt 0
        }
        foreach ($path in 'pwsh/Catzc.Base.Globs/Get-RepositoryFilter.ps1',
            'pwsh/Catzc.Base.Globs/types/FiltersConfig.cs', 'js/catzc-track-lamps/extension.js',
            'infrastructure/modules/data-factory.bicep') {
            & $claims 'code' $path | Should -BeTrue -Because "'$path' is live code"
            & $claims 'live' $path | Should -BeTrue -Because "'$path' is live"
        }
        foreach ($path in 'js/catzc-track-lamps/assets/code-on.svg', 'pwsh/Catzc.Base.Globs/configs/filters.yml') {
            & $claims 'code' $path | Should -BeFalse -Because "'$path' is live but no code"
            & $claims 'live' $path | Should -BeTrue -Because "'$path' is live"
        }
        foreach ($filter in 'code', 'live') {
            & $claims $filter 'pwsh/Catzc.Base.Globs/tests/Get-RepositoryFilter.Tests.ps1' |
                Should -BeFalse -Because 'a test is the tests aspect'
        }
    }

    It 'gives the contracts their own lamp, apart from every other track''s live files' {
        $contract = @($script:tracked.Where({ $_ -like 'contracts/*/*/*' -and $_ -notlike '*/tests/*' }))[0]
        $contract | Should -Not -BeNullOrEmpty -Because 'the repository holds a frozen contract'
        $sets = { param([string] $Filter) & $script:globSets @($script:filters.Where({ $_.name -ceq $Filter })[0].sets) }
        (& $sets 'contracts').Where({ $_.Matches($contract) }, 'First').Count |
            Should -Be 1 -Because "'$contract' is the contracts track's"
        foreach ($filter in 'code', 'live') {
            (& $sets $filter).Where({ $_.Matches($contract) }, 'First').Count |
                Should -Be 0 -Because "the $filter lamp leaves the contracts to their own lamp"
        }
    }

    It 'claims every tracked file by at least one filter' {
        $sets = @($script:filters.ForEach({ & $script:globSets @($_.sets) }))
        $unclaimed = $script:tracked.Where({ $path = $_; $sets.Where({ $_.Matches($path) }, 'First').Count -eq 0 })
        $unclaimed |
            Should -BeNullOrEmpty -Because "every file belongs to a filter (first: $(@($unclaimed | Select-Object -First 5) -join ', '))"
    }

    It 'refuses a filter name that is not declared' {
        { Get-RepositoryFilter -Name widgets } | Should -Throw -ExpectedMessage "*no filter 'widgets'*"
    }
}
