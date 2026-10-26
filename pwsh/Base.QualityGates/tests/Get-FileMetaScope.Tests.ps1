Describe 'Get-FileMetaScope' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-KINDSCOPE' {
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
                }
            })
        $script:resolver = [Catzc.Base.QualityGates.FileCarrierResolver]::new($carriers, $languages)
        $script:scope = {
            param([string[]] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Resolver = $script:resolver; Path = $Path } {
                param($Root, $Resolver, $Path)
                @(Get-FileMetaScope -RepositoryRoot $Root -Path $Path -Resolver $Resolver)
            }
        }
    }

    BeforeEach {
        Mock Get-GitTrackedPath {
            'widgets/Widget/get.wdg', 'widgets/Widget/tests/get.wdg', 'widgets/Widget/assets/vendor.wdg', 'docs/read.gdg', 'docs/own.gdg',
            'docs/value.stp', 'docs/spin.cog', 'docs/plain.txt', 'docs/other.wdg', 'docs/table.dat', 'docs/image.pic'
        } -ModuleName Catzc.Base.QualityGates
        Mock Get-GitAttributeValue {
            @{
                'widgets/Widget/assets/vendor.wdg' = @{ 'linguist-vendored' = 'set' }
                'docs/own.gdg'                     = @{ 'catzc-meta' = 'unset' }
            }
        } -ModuleName Catzc.Base.QualityGates
    }

    It 'keeps the tracked files with a carrier that no exclude, exemption or opt-out takes out' {
        $found = & $script:scope
        $found.Path | Should -Be @('widgets/Widget/get.wdg', 'docs/read.gdg', 'docs/other.wdg', 'docs/table.dat')
    }

    It 'hands each file its carrier entry, a property carrier included' {
        $found = & $script:scope
        $found[0].Carrier.id | Should -BeExactly 'widget'
        $found[1].Carrier.id | Should -BeExactly 'gadget'
        $found[3].Carrier.carrier | Should -Be ([Catzc.Base.Languages.CarrierKind]::Property)
    }

    It 'keeps a file no imprint kind selects, so the imprint can empty the head an earlier shape left on it' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        $script:fileKinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{ 'read-doc' = [ordered]@{ definition = 'A document to read.'; files = @('docs/read.gdg') } }
            })
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'file-kinds' } { $script:fileKinds }
        $found = & $script:scope
        $found.Path | Should -Be @('widgets/Widget/get.wdg', 'docs/read.gdg', 'docs/other.wdg', 'docs/table.dat') -Because 'no kind narrows the scope'
        ($found | Where-Object Path -EQ 'docs/read.gdg').Class | Should -Be 'read-doc'
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

    Context 'a file named in -Path' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        BeforeEach {
            [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/new.gdg'), "# New`n")
        }

        It 'leaves out a named file git does not track: an untracked authored file carries no head' {
            Mock Get-GitTrackedPath { } -ModuleName Catzc.Base.QualityGates
            @(& $script:scope (Join-Path $script:widgetRoot 'docs/new.gdg')).Count | Should -Be 0
            Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { @($Path) -contains 'docs/new.gdg' }
        }

        It 'takes a named file once git tracks it' {
            Mock Get-GitTrackedPath { 'docs/new.gdg' } -ModuleName Catzc.Base.QualityGates
            (& $script:scope (Join-Path $script:widgetRoot 'docs/new.gdg')).Path | Should -Be @('docs/new.gdg')
        }
    }
}
