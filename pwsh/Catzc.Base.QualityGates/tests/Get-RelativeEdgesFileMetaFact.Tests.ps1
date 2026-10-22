<#
---
catzc:
  immutable:
    with_body_sha: f548886d698e
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Get-RelativeEdgesFileMetaFact.ps1
    cites:
      - ADR-REPO-FILEMETA-FEWLINKS
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
---
#>

Describe 'Get-RelativeEdgesFileMetaFact' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-FEWLINKS', 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
    BeforeAll {
        $script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{
                    'widget-test'     = [ordered]@{ definition = 'A widget test.'; files = @('widgets/Catzc.*/tests/*.Tests.ps1') }
                    'widget-function' = [ordered]@{ definition = 'A widget function.'; files = @('widgets/Catzc.*/*.ps1', 'widgets/Catzc.*/private/*.ps1') }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'file-kinds' } { $script:kinds }

        $script:relations = @(
            @{ name = 'docs'; link = '[{leaf}]({relative_path})'; rules = @(@{ paths = @('{page}') }) }
            @{ name = 'test'; rules = @(@{ classes = @('widget-function'); paths = @('widgets/{module}/tests/{stem}.Tests.ps1') }) }
            @{ name = 'source'; rules = @(@{ classes = @('widget-test'); paths = @('widgets/{module}/{stem}.ps1', 'widgets/{module}/private/{stem}.ps1') }) }
        )

        function script:Get-Kind {
            param($Relations = $script:relations)
            [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                    kinds = [ordered]@{ 'relative-edges' = @{ section = 'edges'; keys = @($Relations | ForEach-Object { $_['name'] }); settings = @{ relations = $Relations } } }
                }).kinds[0]
        }

        function script:Get-Relatives {
            param([string] $Path, $Kind = (Get-Kind))
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = $Kind; Path = $Path; Root = $TestDrive } {
                param($Kind, $Path, $Root)
                $mockRoot = $Root
                Mock Get-RepositoryRoot { $mockRoot }
                # The fixture modules live under widgets/, which is no track of the shipped registry; the resolver's own tests prove the real rule.
                Mock Get-PathModule { [pscustomobject]@{ name = (($Path -replace '\\', '/') -split '/')[1]; type = 'widget-folder' } }
                Mock Get-CommentPage { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widgets/*'; docs = 'docs/{kebab}' }) }).PageFor($Path) }
                # An edge no rule fills is an empty string, which the block leaves out; these cases look at the edges that are there.
                $edges = Get-RelativeEdgesFileMetaFact -State ([pscustomobject]@{}) -Path $Path -Kind $Kind
                $found = [ordered]@{}
                foreach ($key in $edges.Keys) {
                    if ($edges[$key]) {
                        $found[$key] = $edges[$key]
                    }
                }
                $found
            }
        }

        function script:New-File {
            param([string] $Relative)
            $full = Join-Path $TestDrive $Relative
            New-Item -ItemType Directory -Path (Split-Path $full) -Force | Out-Null
            Set-Content -LiteralPath $full -Value 'x'
        }
    }

    It 'names the comment page as a link from the file''s own folder and the test of a function file, in the order declared, when both exist' {
        New-File 'widgets/Catzc.Gadget/Get-Cog.ps1'
        New-File 'widgets/Catzc.Gadget/tests/Get-Cog.Tests.ps1'
        New-File 'docs/catzc-gadget/Get-Cog.ps1.md'
        $relatives = Get-Relatives 'widgets/Catzc.Gadget/Get-Cog.ps1'
        @($relatives.Keys) | Should -Be @('docs', 'test')
        $relatives['docs'] | Should -BeExactly '[Get-Cog.ps1.md](../../docs/catzc-gadget/Get-Cog.ps1.md)'
        $relatives['test'] | Should -BeExactly 'widgets/Catzc.Gadget/tests/Get-Cog.Tests.ps1'
    }

    It 'links the page from a file one folder below its module' {
        New-File 'widgets/Catzc.Gadget/private/Get-Bolt.ps1'
        New-File 'docs/catzc-gadget/private/Get-Bolt.ps1.md'
        (Get-Relatives 'widgets/Catzc.Gadget/private/Get-Bolt.ps1')['docs'] | Should -BeExactly '[Get-Bolt.ps1.md](../../../docs/catzc-gadget/private/Get-Bolt.ps1.md)'
    }

    It 'keeps {path} for a link that wants the repository-relative path' {
        New-File 'widgets/Catzc.Gadget/Get-Nut.ps1'
        New-File 'docs/catzc-gadget/Get-Nut.ps1.md'
        $rooted = Get-Kind @(@{ name = 'docs'; link = '[{leaf}]({path})'; rules = @(@{ paths = @('{page}') }) })
        (Get-Relatives 'widgets/Catzc.Gadget/Get-Nut.ps1' $rooted)['docs'] | Should -BeExactly '[Get-Nut.ps1.md](docs/catzc-gadget/Get-Nut.ps1.md)'
    }

    It 'names the first source candidate that exists for a test file' {
        New-File 'widgets/Catzc.Gadget/private/Get-Sprocket.ps1'
        New-File 'widgets/Catzc.Gadget/tests/Get-Sprocket.Tests.ps1'
        $relatives = Get-Relatives 'widgets/Catzc.Gadget/tests/Get-Sprocket.Tests.ps1'
        @($relatives.Keys) | Should -Be @('source')
        $relatives['source'] | Should -BeExactly 'widgets/Catzc.Gadget/private/Get-Sprocket.ps1'
    }

    It 'applies a rule only to the classes it names' {
        New-File 'widgets/Catzc.Gadget/tests/Get-Spring.Tests.ps1'
        (Get-Relatives 'widgets/Catzc.Gadget/tests/Get-Spring.Tests.ps1').Contains('test') | Should -BeFalse -Because 'a test file is no widget-function'
    }

    It 'gives every key of the kind, an empty string for an edge no rule fills' {
        New-File 'widgets/Catzc.Gadget/Get-Alone.ps1'
        $edges = InModuleScope Catzc.Base.QualityGates -Parameters @{ Kind = (Get-Kind); Root = $TestDrive } {
            param($Kind, $Root)
            $mockRoot = $Root
            Mock Get-RepositoryRoot { $mockRoot }
            Mock Get-PathModule { [pscustomobject]@{ name = 'Catzc.Gadget'; type = 'widget-folder' } }
            Mock Get-CommentPage { [Catzc.Base.CodeMeta.CommentPagesConfig]::new(@{ pages = @(@{ source = 'widgets/*'; docs = 'docs/{kebab}' }) }).PageFor($Path) }
            Get-RelativeEdgesFileMetaFact -State ([pscustomobject]@{}) -Path 'widgets/Catzc.Gadget/Get-Alone.ps1' -Kind $Kind
        }
        @($edges.Keys) | Should -Be @('docs', 'test', 'source')
        @($edges.Values | Where-Object { $_ }).Count | Should -Be 0
    }

    It 'gives a relation without a link template its bare repository-relative path' {
        New-File 'widgets/Catzc.Gadget/Get-Gear.ps1'
        New-File 'docs/catzc-gadget/Get-Gear.ps1.md'
        $bare = Get-Kind @(@{ name = 'docs'; rules = @(@{ paths = @('{page}') }) })
        (Get-Relatives 'widgets/Catzc.Gadget/Get-Gear.ps1' $bare)['docs'] | Should -BeExactly 'docs/catzc-gadget/Get-Gear.ps1.md'
    }

    It 'leaves a relation out when its file does not exist, so the map can be empty' {
        New-File 'widgets/Catzc.Gadget/Get-Lonely.ps1'
        (Get-Relatives 'widgets/Catzc.Gadget/Get-Lonely.ps1').Count | Should -Be 0
    }

    It 'refuses more than eight relations' {
        $many = 1..9 | ForEach-Object { @{ name = "relation$_"; rules = @(@{ paths = @('nowhere') }) } }
        { Get-Relatives 'widgets/Catzc.Gadget/Get-Cog.ps1' (Get-Kind $many) } | Should -Throw '*at most 8 are allowed*'
    }

    It 'rejects a relation without rules' {
        { Get-Relatives 'widgets/Catzc.Gadget/Get-Cog.ps1' (Get-Kind @(@{ name = 'docs' })) } | Should -Throw "*entries need 'name' and 'rules'*"
    }
}
