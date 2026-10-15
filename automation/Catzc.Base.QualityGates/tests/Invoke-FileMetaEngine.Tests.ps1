Describe 'Invoke-FileMetaEngine' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3', 'ADR-REPO-CODEMETA#3' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'engine-repository'
        $carriers = [Catzc.Base.Languages.FileCarriersConfig]::new(@{
                carriers = [ordered]@{
                    powershell = @{ carrier = 'comment-head'; line = '#' }
                    markdown   = @{ carrier = 'front-matter' }
                }
            })
        $script:head = $carriers.Find('powershell')
        $script:front = $carriers.Find('markdown')
        $script:config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{
                kinds = [ordered]@{
                    'file-path'   = @{ keys = @('path') }
                    'module-name' = @{ keys = @('module'); files = @('automation/**') }
                    visibility    = @{ keys = @('visibility'); files = @('automation/**/*.ps1') }
                }
            })
        $script:run = {
            param($Entries)
            $script:engineEntries = $Entries
            Mock Get-FileMetaScope { $script:engineEntries } -ModuleName Catzc.Base.QualityGates
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Config = $script:config } {
                param($Root, $Config)
                Invoke-FileMetaEngine -RepositoryRoot $Root -Config $Config
            }
        }
    }

    BeforeEach {
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'automation/Catzc.Widget/private')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'automation/Catzc.Widget/Get-Gadget.ps1'), "function Get-Gadget { }`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'automation/Catzc.Widget/private/Get-Sprocket.ps1'), "function Get-Sprocket { }`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# Widget`n")
        $script:entries = @(
            [pscustomobject]@{ Path = 'automation/Catzc.Widget/Get-Gadget.ps1'; Carrier = $script:head }
            [pscustomobject]@{ Path = 'automation/Catzc.Widget/private/Get-Sprocket.ps1'; Carrier = $script:head }
        )
    }

    It 'writes the head of a function file from the kinds that apply to it, in the registry''s order' {
        $result = & $script:run $script:entries
        $result.FileCount | Should -Be 2
        $result.Files.Count | Should -Be 2
        $result.Files[0].Findings[0].Kind | Should -Be 'Drift'
        $result.Files[0].Fixed | Should -BeExactly "# catzc:`n#   path: automation/Catzc.Widget/Get-Gadget.ps1`n#   module: Catzc.Widget`n#   visibility: public`n`nfunction Get-Gadget { }`n"
        $result.Files[1].Fixed | Should -BeLike "*#   visibility: private`n`nfunction Get-Sprocket { }`n"
    }

    It 'finds nothing to change once the head is written' {
        $first = & $script:run $script:entries
        foreach ($file in $first.Files) {
            [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot $file.Path), $file.Fixed)
        }
        $second = & $script:run $script:entries
        $second.FileCount | Should -Be 2
        $second.Files.Count | Should -Be 0
    }

    It 'reports a head key no kind owns, and leaves that file''s text as written' {
        $text = "# catzc:`n#   colour: red`n`nfunction Get-Gadget { }`n"
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'automation/Catzc.Widget/Get-Gadget.ps1'), $text)
        $result = & $script:run $script:entries[0]
        $result.Files[0].Findings.Kind | Should -Be @('UnownedHead')
        $result.Files[0].Findings[0].Actual | Should -Be 'catzc head.colour'
        $result.Files[0].Fixed | Should -BeExactly $text
    }

    It 'handles a Markdown file in the same run, with its own carrier' {
        $mixed = $script:entries + [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }
        $result = & $script:run $mixed
        $result.FileCount | Should -Be 3
        $markdown = $result.Files | Where-Object Path -EQ 'docs/widget.md'
        $markdown.Fixed | Should -BeLike "---`ncatzc:`n  derived:`n    path: docs/widget.md*---*# Widget*"
        $markdown.Fixed | Should -Not -BeLike '*module:*' -Because 'the module kind lists automation/** only'
    }

    It 'imprints nothing and reports nothing for an empty scope' {
        $result = & $script:run @()
        $result.FileCount | Should -Be 0
        @($result.Files).Count | Should -Be 0
    }
}
