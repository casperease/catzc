<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.RootConfig/tests/New-GitAttributes.Tests.ps1
    folder: tests
    name: new-git-attributes-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-AUTO-ASSETDEP#3
---
#>

Describe 'New-GitAttributes' -Tag 'L0', 'logic' {
    BeforeAll {
        function script:New-Registry {
            param($Kinds)
            [Catzc.Base.Globs.FileKindsConfig]::new([ordered]@{ kinds = $Kinds })
        }

        function script:Set-Template {
            param([string] $Text)
            $script:templatePath = Join-Path $TestDrive 'template.attributes'
            [System.IO.File]::WriteAllText($script:templatePath, $Text)
        }

        Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.RootConfig { Join-Path $TestDrive 'template.attributes' }
        Mock Assert-PathExist -ModuleName Catzc.Base.RootConfig { }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig {
            [Catzc.Base.Globs.FileKindsConfig]::new([ordered]@{ kinds = [ordered]@{
                        widget   = [ordered]@{
                            definition = 'A widget.'
                            subkinds   = [ordered]@{
                                cog = [ordered]@{ definition = 'A cog.'; files = @('widgets/cogs/**'); git = @{ attributes = @('catzc-cog'); why = 'Cogs are data.' } }
                            }
                            files      = @('widgets/**', 'extras/**')
                            git        = @{ attributes = @('catzc-widget', 'eol=lf'); why = 'Widgets are data on purpose.' }
                        }
                        sprocket = [ordered]@{ definition = 'A sprocket.'; files = @('sprockets/**') }
                    }
                })
        }
    }

    It 'replaces the placeholder with a why comment and one line per glob, subkind first, in registry order' {
        Set-Template "# head`n{{file-kind-attributes}}`n# tail`n"
        $text = New-GitAttributes
        $text | Should -BeExactly "# head`n# catzc: Cogs are data.`nwidgets/cogs/** catzc-cog`n`n# catzc: Widgets are data on purpose.`nwidgets/** catzc-widget eol=lf`nextras/** catzc-widget eol=lf`n# tail`n"
    }

    It 'leaves a kind with no git entry out' {
        Set-Template "{{file-kind-attributes}}`n"
        New-GitAttributes | Should -Not -Match 'sprocket'
    }

    It 'wraps a long why at the comment width, each line a comment' {
        Mock Get-Config -ModuleName Catzc.Base.RootConfig {
            [Catzc.Base.Globs.FileKindsConfig]::new([ordered]@{ kinds = [ordered]@{
                        widget = [ordered]@{ definition = 'A widget.'; files = @('w/**'); git = @{ attributes = @('catzc-widget'); why = (('word ' * 60).Trim()) } }
                    }
                })
        }
        Set-Template "{{file-kind-attributes}}`n"
        $lines = (New-GitAttributes) -split "`n"
        $comments = @($lines | Where-Object { $_ -match '^#' })
        $comments.Count | Should -BeGreaterThan 1
        $comments | ForEach-Object { $_.Length | Should -BeLessOrEqual 118 }
        $lines | Should -Contain 'w/** catzc-widget'
    }

    It 'renders the template unchanged but for the placeholder when no kind has a git entry' {
        Mock Get-Config -ModuleName Catzc.Base.RootConfig {
            [Catzc.Base.Globs.FileKindsConfig]::new([ordered]@{ kinds = [ordered]@{ sprocket = [ordered]@{ definition = 'A sprocket.'; files = @('s/**') } } })
        }
        Set-Template "a`n{{file-kind-attributes}}`nb`n"
        New-GitAttributes | Should -BeExactly "a`n`nb`n"
    }

    It 'rejects a template without the placeholder, or with it twice' {
        Set-Template "no placeholder here`n"
        { New-GitAttributes } | Should -Throw '*exactly once, found 0*'
        Set-Template "{{file-kind-attributes}}`n{{file-kind-attributes}}`n"
        { New-GitAttributes } | Should -Throw '*exactly once, found 2*'
    }
}

Describe 'New-GitAttributes — shipped assets/root/.gitattributes' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP#3' {
    It 'renders the shipped template through the shipped file-kinds registry with the placeholder filled' {
        $text = New-GitAttributes
        $text | Should -Not -Match '\{\{'
        $text | Should -Match '(?m)^automation/\.compiled/\*\* binary$'
        $text | Should -Match '(?m)^\S+ .*catzc-'
    }
}
