BeforeAll {
    Import-InternalModule TestKit
    Import-InternalModule Builder
}

Describe 'Get-BuildSourceInput' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive 'widget-repo'
        foreach ($folder in 'widgets/Widget/types', 'widgets/Gadget/types', 'widgets/.internal') {
            [System.IO.Directory]::CreateDirectory((Join-Path $script:root $folder)) | Out-Null
        }
        $script:invoke = {
            param([string[]] $Module, [bool] $All)
            InModuleScope Catzc.Internal.Builder -Parameters @{ Root = $script:root; Module = $Module; All = $All } {
                Mock Get-ModuleNamespace { '' }
                Mock Get-Config -ParameterFilter { $Config -eq 'dependencies' } {
                    [pscustomobject] @{ modules = @{ Widget = @('Gadget', 'python/widget-tool') } }
                }
                Mock Get-Config -ParameterFilter { $Config -eq 'languages' } {
                    [pscustomobject] @{ languages = @(
                            [pscustomobject] @{ name = 'python'; package = [pscustomobject] @{ command = 'Export-WidgetModule' } }
                            [pscustomobject] @{ name = 'markdown'; package = $null }
                        )
                    }
                }
                Mock Get-Track {
                    [pscustomobject] @{ name = 'python'; type = 'modules'; languages = @('python'); places = @('python') }
                    [pscustomobject] @{ name = 'notes'; type = 'modules'; languages = @('markdown'); places = @('notes') }
                    [pscustomobject] @{ name = 'gadgets'; type = 'docs'; languages = @('python'); places = @('gadgets') }
                }
                Get-BuildSourceInput -RepositoryRoot $Root -SourceRoot (Join-Path $Root 'widgets') -Module $Module -AllLanguageModule:$All
            }
        }
    }

    It 'lists the selected module folder, never an unselected one' {
        $inputs = & $script:invoke @('Widget') $false
        $inputs | Should -Contain 'widgets/Widget/'
        $inputs | Should -Not -Contain 'widgets/Gadget/'
    }

    It 'lists the types folder of every module, selected or not' {
        $inputs = & $script:invoke @('Widget') $false
        $inputs | Should -Contain 'widgets/Widget/types/'
        $inputs | Should -Contain 'widgets/Gadget/types/'
        $inputs | Should -Not -Contain 'widgets/.internal/types/'
    }

    It 'lists the internal folder, the vendor folder, the engine modules, the tools pin and the overlay fragments' {
        $inputs = & $script:invoke @('Widget') $false
        foreach ($expected in 'widgets/.internal/', 'widgets/.vendor/', 'widgets/Catzc.Base.Config/', 'widgets/Catzc.Base.Languages/',
            'widgets/Catzc.Base.Execution/configs/tools.yml', '.catzc/widgets/') {
            $inputs | Should -Contain $expected
        }
    }

    It 'lists the analyzer and the bats runner only when the selection holds the gates module' {
        $without = & $script:invoke @('Widget') $false
        $with = & $script:invoke @('Widget', 'Catzc.Base.QualityGates') $false
        $without | Should -Not -Contain 'widgets/.scriptanalyzer/'
        $without | Should -Not -Contain 'bash/.vendor/bats-core/'
        $with | Should -Contain 'widgets/.scriptanalyzer/'
        $with | Should -Contain 'bash/.vendor/bats-core/'
    }

    It 'lists the language module paths a selected module declares, and no whole language track' {
        $inputs = & $script:invoke @('Widget') $false
        $inputs | Should -Contain 'python/widget-tool/'
        $inputs | Should -Not -Contain 'python/'
        $inputs | Should -Not -Contain 'widgets/python/widget-tool/'
    }

    It 'lists every place of a packaged language track when the selection is the whole repository' {
        $inputs = & $script:invoke @('Gadget') $true
        $inputs | Should -Contain 'python/'
        $inputs | Should -Not -Contain 'notes/'
        $inputs | Should -Not -Contain 'gadgets/'
        $inputs | Should -Not -Contain 'python/widget-tool/'
    }

    It 'returns its inputs ordinally sorted' {
        $inputs = [string[]] @(& $script:invoke @('Widget') $false)
        $sorted = [string[]] $inputs.Clone()
        [System.Array]::Sort($sorted, [System.StringComparer]::Ordinal)
        $inputs | Should -Be $sorted
    }
}
