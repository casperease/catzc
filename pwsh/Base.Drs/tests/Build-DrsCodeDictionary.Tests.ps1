Describe 'Build-DrsCodeDictionary' -Tag 'L0', 'logic', 'ADR-REPO-DRSCODE-NAMEDNOTNUMBERED' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
                kinds   = [ordered]@{ WDR = [ordered]@{ name = 'Widget Decision Record'; shared = $true } }
                domains = [ordered]@{
                    widget = [ordered]@{
                        kind = 'WDR'; code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{
                            'widget-spinner' = [ordered]@{ external = 'WDR-WI-SPINNER' }
                            'widget-gadget'  = [ordered]@{ external = 'WDR-WI-GADGET' }
                        }
                    }
                }
            })
    }

    BeforeEach {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        [void][System.IO.Directory]::CreateDirectory((Join-Path $root 'docs/drs/widget'))
        [System.IO.File]::WriteAllText((Join-Path $root 'docs/drs/widget/widget-spinner.md'),
            "# Spinner`n`n## Rules: WDR-WI-SPINNER`n`n### Rule WDR-WI-SPINNER-SPINS`n`n### Rule WDR-WI-SPINNER:2`n`n``````text`n### Rule WDR-WI-SPINNER-HIDDEN`n```````n")
        [System.IO.File]::WriteAllText((Join-Path $root 'docs/drs/widget/widget-gadget.md'),
            "# Gadget`n`n## Rules: WDR-WI-GADGET`n")
        $script:root = $root
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs' } { $script:fixture }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Drs -ParameterFilter { $Path -eq 'docs/drs' } { Join-Path $script:root 'docs/drs' }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Drs { $script:root }
        Mock Write-Message -ModuleName Catzc.Base.Drs { }
        # The fixture root is no git checkout, so the generated head reads no file as tracked.
        Import-InternalModule TestKit
        Set-GitTrackedPathMock
    }

    It 'writes every segment of every code and rule heading, lower-cased, unique and sorted' {
        $result = Build-DrsCodeDictionary -PassThru
        $result.Changed | Should -BeTrue
        $text = [System.IO.File]::ReadAllText((Join-Path $script:root '.cspell/drs-codes.txt'))
        $words = @($text -split "`n" | Where-Object { $_ -match '^[a-z0-9]+$' })
        $words | Should -Be @('gadget', 'hidden', 'spinner', 'spins', 'wdr', 'wi')
        $result.WordCount | Should -Be 6
    }

    It 'writes the rule headings of every registered kind' -Tag 'ADR-REPO-DRSCODE-DOMAINSEGMENT' {
        $shared = $script:fixture
        try {
            $script:fixture = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
                    kinds   = [ordered]@{ WDR = [ordered]@{ name = 'Widget Decision Record'; shared = $true }; GDR = [ordered]@{ name = 'Gadget Decision Record' } }
                    domains = [ordered]@{
                        gizmo = [ordered]@{
                            kind = 'GDR'; role = 'axioms'; description = 'The gizmo axioms.'; depends_on = @(); stack = 'PRIN'; concern = @('build')
                            rulesets = [ordered]@{ 'gizmo-lever' = [ordered]@{ external = 'GDR-LEVER' } }
                        }
                    }
                })
            [void][System.IO.Directory]::CreateDirectory((Join-Path $script:root 'docs/drs/gizmo'))
            [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/drs/gizmo/gizmo-lever.md'),
                "# Lever`n`n## Rules: GDR-LEVER`n`n### Rule GDR-LEVER-TILTS`n")
            Build-DrsCodeDictionary -Silent | Out-Null
            $text = [System.IO.File]::ReadAllText((Join-Path $script:root '.cspell/drs-codes.txt'))
            $words = @($text -split "`n" | Where-Object { $_ -match '^[a-z0-9]+$' })
            foreach ($word in 'gdr', 'lever', 'tilts') {
                $words | Should -Contain $word
            }
        }
        finally {
            $script:fixture = $shared
        }
    }

    It 'leaves the file alone on a second run, and writes nothing under -DryRun' {
        Build-DrsCodeDictionary -Silent | Out-Null
        (Build-DrsCodeDictionary -PassThru -Silent).Changed | Should -BeFalse
        Remove-Item -LiteralPath (Join-Path $script:root '.cspell/drs-codes.txt')
        (Build-DrsCodeDictionary -DryRun -PassThru -Silent).Changed | Should -BeTrue
        Join-Path $script:root '.cspell/drs-codes.txt' | Should -Not -Exist
    }
}

Describe 'Build-DrsCodeDictionary — shipped configs/drs.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'finds the domain registry it names as its source in the loaded module' {
        $registry = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/drs.yml' -Module Catzc.Base.Drs)) |
            ConvertFrom-Yaml -Ordered
        @($registry['domains'].Keys).Count | Should -BeGreaterThan 0
    }
}
