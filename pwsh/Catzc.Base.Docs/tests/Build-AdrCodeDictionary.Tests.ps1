<#
---
catzc:
  immutable:
    with_body_sha: "5c4f320ec152"
  edges:
    code: pwsh/Catzc.Base.Docs/Build-AdrCodeDictionary.ps1
    cites:
      - ADR-AUTO-ASSETDEP-COVEREDBYREALTEST
      - ADR-REPO-ADRCODE-DOMAINSEGMENT
      - ADR-REPO-ADRCODE-NAMEDNOTNUMBERED
---
#>

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

    It 'writes the rule headings of every registered kind' -Tag 'ADR-REPO-ADRCODE-DOMAINSEGMENT' {
        $shared = $script:fixture
        try {
            $script:fixture = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                    kinds   = [ordered]@{ ADR = [ordered]@{ name = 'Architecture Decision Record'; shared = $true }; GDR = [ordered]@{ name = 'Gadget Decision Record' } }
                    domains = [ordered]@{
                        gizmo = [ordered]@{
                            kind = 'GDR'; role = 'axioms'; description = 'The gizmo axioms.'; depends_on = @(); stack = 'PRIN'; concern = @('build')
                            rulesets = [ordered]@{ 'gizmo-lever' = [ordered]@{ external = 'GDR-LEVER' } }
                        }
                    }
                })
            [void][System.IO.Directory]::CreateDirectory((Join-Path $script:root 'docs/adr/gizmo'))
            [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/adr/gizmo/gizmo-lever.md'), "# Lever`n`n## Rules: GDR-LEVER`n`n### Rule GDR-LEVER-TILTS`n")
            Build-AdrCodeDictionary -Silent | Out-Null
            $text = [System.IO.File]::ReadAllText((Join-Path $script:root '.cspell/adr-codes.txt'))
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
        Build-AdrCodeDictionary -Silent | Out-Null
        (Build-AdrCodeDictionary -PassThru -Silent).Changed | Should -BeFalse
        Remove-Item -LiteralPath (Join-Path $script:root '.cspell/adr-codes.txt')
        (Build-AdrCodeDictionary -DryRun -PassThru -Silent).Changed | Should -BeTrue
        Join-Path $script:root '.cspell/adr-codes.txt' | Should -Not -Exist
    }
}

Describe 'Build-AdrCodeDictionary — shipped configs/adrs.yml' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'finds the domain registry it names as its source in the loaded module' {
        $registry = [System.IO.File]::ReadAllText((Get-CatzcModuleRoot 'configs/adrs.yml' -Module Catzc.Base.Docs)) | ConvertFrom-Yaml -Ordered
        @($registry['domains'].Keys).Count | Should -BeGreaterThan 0
    }
}
