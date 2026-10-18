Describe 'Build-AdrCodeDictionary' -Tag 'L0', 'logic', 'ADR-REPO-ADRCODE-NAMEDNOTNUMBERED' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{
                            'widget-spinner' = [ordered]@{ external = 'ADR-WI-SPINNER' }
                            'widget-gadget'  = [ordered]@{ external = 'ADR-WI-GADGET' }
                        }
                    }
                }
            })
    }

    BeforeEach {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        [void][System.IO.Directory]::CreateDirectory((Join-Path $root 'docs/adr/widget'))
        [System.IO.File]::WriteAllText((Join-Path $root 'docs/adr/widget/widget-spinner.md'),
            "# Spinner`n`n## Rules: ADR-WI-SPINNER`n`n### Rule ADR-WI-SPINNER-SPINS`n`n### Rule ADR-WI-SPINNER:2`n`n``````text`n### Rule ADR-WI-SPINNER-HIDDEN`n```````n")
        [System.IO.File]::WriteAllText((Join-Path $root 'docs/adr/widget/widget-gadget.md'), "# Gadget`n`n## Rules: ADR-WI-GADGET`n")
        $script:root = $root
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'adrs' } { $script:fixture }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs -ParameterFilter { $Path -eq 'docs/adr' } { Join-Path $script:root 'docs/adr' }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Docs { $script:root }
        Mock Write-Message -ModuleName Catzc.Base.Docs { }
    }

    It 'writes every segment of every code and rule heading, lower-cased, unique and sorted' {
        $result = Build-AdrCodeDictionary -PassThru
        $result.Changed | Should -BeTrue
        $text = [System.IO.File]::ReadAllText((Join-Path $script:root '.cspell/adr-codes.txt'))
        $words = @($text -split "`n" | Where-Object { $_ -match '^[a-z0-9]+$' })
        $words | Should -Be @('adr', 'gadget', 'hidden', 'spinner', 'spins', 'wi')
        $result.WordCount | Should -Be 6
    }

    It 'leaves the file alone on a second run, and writes nothing under -DryRun' {
        Build-AdrCodeDictionary -Silent | Out-Null
        (Build-AdrCodeDictionary -PassThru -Silent).Changed | Should -BeFalse
        Remove-Item -LiteralPath (Join-Path $script:root '.cspell/adr-codes.txt')
        (Build-AdrCodeDictionary -DryRun -PassThru -Silent).Changed | Should -BeTrue
        Join-Path $script:root '.cspell/adr-codes.txt' | Should -Not -Exist
    }
}

Describe 'Build-AdrCodeDictionary — shipped configs/adrs.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'finds the domain registry it stamps in the loaded module' {
        $registry = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/adrs.yml' -Module Catzc.Base.Docs)) | ConvertFrom-Yaml -Ordered
        @($registry['domains'].Keys).Count | Should -BeGreaterThan 0
    }
}
