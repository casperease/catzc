<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-FileMetaScope.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Get-FileMetaScope.ps1
    adrs:
      - ADR-REPO-FILEMETA#5
---
#>

Describe 'Get-FileMetaScope' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#5' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        $languages = [Catzc.Base.Languages.LanguagesConfig]::new(@{
                languages = [ordered]@{
                    widget = @{ extensions = @('.wdg'); no_formatter = 'widgets are never formatted' }
                    gadget = @{ extensions = @('.gdg'); no_formatter = 'gadgets are never formatted' }
                    cog    = @{ extensions = @('.cog'); no_formatter = 'cogs are never formatted' }
                    stamp  = @{ extensions = @('.stp'); no_formatter = 'a stamp is written whole' }
                    data   = @{ extensions = @('.dat'); no_formatter = 'data is never formatted' }
                }
            })
        $carriers = [Catzc.Base.Languages.FileCarriersConfig]::new(@{
                carriers = [ordered]@{
                    widget = @{ carrier = 'comment-head'; line = '#'; exclude = @{ '**/tests/**' = 'a test carries no head' } }
                    gadget = @{ carrier = 'front-matter' }
                    stamp  = @{ carrier = 'none'; reason = 'written whole' }
                    data   = @{ carrier = 'property'; property = '//' }
                    image  = @{ files = @('**/*.pic'); carrier = 'sidecar'; sidecar = '{base}.md' }
                }
            })
        $script:resolver = [Catzc.Base.QualityGates.FileCarrierResolver]::new($carriers, $languages)
        $script:config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'file-path' = @{ keys = @('path') } } })
        $script:scope = {
            param([string[]] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Config = $script:config; Resolver = $script:resolver; Path = $Path } {
                param($Root, $Config, $Resolver, $Path)
                @(Get-FileMetaScope -RepositoryRoot $Root -Path $Path -Config $Config -Resolver $Resolver)
            }
        }
    }

    BeforeEach {
        Mock Get-GitTrackedPath {
            'automation/Widget/get.wdg', 'automation/Widget/tests/get.wdg', 'automation/Widget/assets/vendor.wdg', 'docs/read.gdg', 'docs/own.gdg',
            'docs/value.stp', 'docs/spin.cog', 'docs/plain.txt', 'docs/other.wdg', 'docs/table.dat', 'docs/image.pic'
        } -ModuleName Catzc.Base.QualityGates
        Mock Get-GitAttributeValue {
            @{
                'automation/Widget/assets/vendor.wdg' = @{ 'linguist-vendored' = 'set' }
                'docs/own.gdg'                        = @{ 'catzc-meta' = 'unset' }
            }
        } -ModuleName Catzc.Base.QualityGates
    }

    It 'keeps the tracked files with a carrier that no exclude, exemption or opt-out takes out' {
        $found = & $script:scope
        $found.Path | Should -Be @('automation/Widget/get.wdg', 'docs/read.gdg', 'docs/other.wdg', 'docs/table.dat', 'docs/image.pic')
    }

    It 'hands each file its carrier entry, a property or a sidecar carrier included' {
        $found = & $script:scope
        $found[0].Carrier.id | Should -BeExactly 'widget'
        $found[1].Carrier.id | Should -BeExactly 'gadget'
        $found[3].Carrier.carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::Property)
        $found[4].Carrier.carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::Sidecar)
    }

    It 'leaves out a file whose class has no carrier, a carrier of none, and a file no imprint kind selects' {
        $narrow = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{ 'file-path' = @{ keys = @('path'); select = @(@{ classes = @('read-doc') }) } }
            })
        $fileKinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{ 'read-doc' = [ordered]@{ definition = 'A document to read.'; files = @('docs/read.gdg') } }
            })
        $found = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Config = $narrow; Resolver = $script:resolver; FileKinds = $fileKinds } {
            param($Root, $Config, $Resolver, $FileKinds)
            Mock Get-Config { $FileKinds } -ParameterFilter { $Config -eq 'file-kinds' }
            @(Get-FileMetaScope -RepositoryRoot $Root -Config $Config -Resolver $Resolver)
        }
        $found.Path | Should -Be @('docs/read.gdg')
    }

    It 'asks .gitattributes about the exempt classes and the opt-out for the candidates only' {
        & $script:scope | Out-Null
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            'catzc-meta' -in $Attribute -and 'docs/plain.txt' -notin $Path -and 'docs/spin.cog' -notin $Path -and 'docs/value.stp' -notin $Path
        }
    }

    It 'narrows to a -Path inside the repository, repository-relative' {
        & $script:scope (Join-Path $script:widgetRoot 'docs') | Out-Null
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter { $Path -eq 'docs' }
    }

    It 'refuses a -Path outside the repository' {
        { & $script:scope $TestDrive } | Should -Throw '*outside the repository*'
    }

    It 'returns nothing, without asking git about attributes, when no tracked file is a candidate' {
        Mock Get-GitTrackedPath { 'docs/plain.txt' } -ModuleName Catzc.Base.QualityGates
        @(& $script:scope).Count | Should -Be 0
        Should -Invoke Get-GitAttributeValue -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
