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
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'track-types' } {
            [Catzc.Base.Variants.TrackTypesConfig]::new([ordered]@{ track_types = [ordered]@{
                        'widget-works' = [ordered]@{ definition = 'A widget cluster.'; role = 'holder' }
                    }
                })
        }
        Mock Get-Track -ModuleName Catzc.Base.RootConfig { }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'rootconfig' } {
            [pscustomobject]@{ files = @(
                    [pscustomobject]@{ target = 'widget.cfg'; committed = $true }
                    [pscustomobject]@{ target = 'gadget.cfg'; committed = $false }
                    [pscustomobject]@{ target = 'tools/cog.lock'; committed = $true }
                )
            }
        }
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'generated-files' } {
            [pscustomobject]@{ writers = [ordered]@{
                    'Build-Widget' = [pscustomobject]@{ outputs = @('docs/widget.md', '**/GADGET.md') }
                }
            }
        }
        $script:roots = "{{generated-files}}`n"
        $script:generated = "/docs/widget.md linguist-generated`n**/GADGET.md linguist-generated`n/widget.cfg linguist-generated`n/tools/cog.lock linguist-generated`n"
    }

    It 'replaces the placeholder with a why comment and one line per glob, subkind first, in registry order' {
        Set-Template "# head`n{{file-kind-attributes}}`n# tail`n$script:roots"
        $text = New-GitAttributes
        $text | Should -BeExactly "# head`n# catzc: Cogs are data.`nwidgets/cogs/** catzc-cog`n`n# catzc: Widgets are data on purpose.`nwidgets/** catzc-widget eol=lf`nextras/** catzc-widget eol=lf`n# tail`n$script:generated"
    }

    It 'marks every writer output, then every committed root config, generated, root-anchored unless it spans folders, and leaves an uncommitted root out' -Tag 'PDR-ONELIVE-ONEVERSION', 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
        Set-Template "{{file-kind-attributes}}`n$script:roots"
        $text = New-GitAttributes
        $text | Should -BeLike "*`n$script:generated"
        $text | Should -Not -Match 'gadget\.cfg'
    }

    It 'gives the attributes a track type declares to every place of each track of that type, after the kinds' {
        Mock Get-Config -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Config -eq 'track-types' } {
            [Catzc.Base.Variants.TrackTypesConfig]::new([ordered]@{ track_types = [ordered]@{
                        'widget-works' = [ordered]@{ definition = 'A widget cluster.'; role = 'holder' }
                        'gadget-shelf' = [ordered]@{
                            definition = 'A gadget holder.'; role = 'holder'
                            git = [ordered]@{ attributes = @('catzc-gadget'); why = 'Gadgets wait here unchecked.' }
                        }
                    }
                })
        }
        Mock Get-Track -ModuleName Catzc.Base.RootConfig {
            [pscustomobject]@{ name = 'widgets'; type = 'widget-works'; places = @('widgets') }
            [pscustomobject]@{ name = '.gadgets'; type = 'gadget-shelf'; places = @('.gadgets', 'spare-gadgets') }
        }
        Set-Template "{{file-kind-attributes}}`n$script:roots"
        $text = New-GitAttributes
        $text | Should -BeLike "*extras/** catzc-widget eol=lf`n`n# catzc: Gadgets wait here unchecked.`n.gadgets/** catzc-gadget`nspare-gadgets/** catzc-gadget`n*"
        $text | Should -Not -Match 'widgets/\*\* catzc-gadget'
    }

    It 'leaves a kind with no git entry out' {
        Set-Template "{{file-kind-attributes}}`n$script:roots"
        New-GitAttributes | Should -Not -Match 'sprocket'
    }

    It 'wraps a long why at the comment width, each line a comment' {
        Mock Get-Config -ModuleName Catzc.Base.RootConfig {
            [Catzc.Base.Globs.FileKindsConfig]::new([ordered]@{ kinds = [ordered]@{
                        widget = [ordered]@{ definition = 'A widget.'; files = @('w/**'); git = @{ attributes = @('catzc-widget'); why = (('word ' * 60).Trim()) } }
                    }
                })
        }
        Set-Template "{{file-kind-attributes}}`n$script:roots"
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
        Set-Template "a`n{{file-kind-attributes}}`nb`n$script:roots"
        New-GitAttributes | Should -BeExactly "a`n`nb`n$script:generated"
    }

    It 'rejects a template without a placeholder, or with one twice' {
        Set-Template "no placeholder here`n$script:roots"
        { New-GitAttributes } | Should -Throw '*exactly once, found 0*'
        Set-Template "{{file-kind-attributes}}`n{{file-kind-attributes}}`n$script:roots"
        { New-GitAttributes } | Should -Throw '*exactly once, found 2*'
        Set-Template "{{file-kind-attributes}}`n"
        { New-GitAttributes } | Should -Throw "*'{{generated-files}}' exactly once*"
    }
}

Describe 'New-GitAttributes — shipped assets/root/.gitattributes-template' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'renders the shipped template through the shipped file-kinds registry with the placeholder filled' {
        $text = New-GitAttributes
        $text | Should -Not -Match '\{\{'
        $text | Should -Match '(?m)^pwsh/\.compiled/\*\* binary$'
        $text | Should -Match '(?m)^\S+ .*catzc-'
        foreach ($root in @((Get-Config -Config rootconfig).files | Where-Object { $_.committed })) {
            $text | Should -Match "(?m)^/$([regex]::Escape($root.target)) linguist-generated$" -Because "$($root.target) is a committed root config"
        }
        foreach ($writer in (Get-Config -Config generated-files).writers.Values) {
            foreach ($output in @($writer.outputs)) {
                $line = if ($output.StartsWith('**/')) {
                    $output
                }
                else {
                    "/$output"
                }
                $text | Should -Match "(?m)^$([regex]::Escape($line)) linguist-generated$" -Because "$output is a declared writer output"
            }
        }
    }
}
