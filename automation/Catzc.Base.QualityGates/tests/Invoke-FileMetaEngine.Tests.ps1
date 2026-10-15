<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Invoke-FileMetaEngine.Tests.ps1
    kind: pester-test
---
#>

Describe 'Invoke-FileMetaEngine' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3', 'ADR-REPO-CODEMETA#3' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'engine-repository'
        $carriers = [Catzc.Base.Languages.FileCarriersConfig]::new(@{
                carriers = [ordered]@{
                    powershell = @{ carrier = 'comment-head'; block = @('<#', '#>') }
                    markdown   = @{ carrier = 'front-matter' }
                    json       = @{ carrier = 'property'; property = '//'; strip = @('GENERATED FILE') }
                    picture    = @{ files = @('**/*.pic'); carrier = 'sidecar'; sidecar = '{base}.md' }
                }
            })
        $script:head = $carriers.Find('powershell')
        $script:front = $carriers.Find('markdown')
        $script:property = $carriers.Find('json')
        $script:sidecar = $carriers.Find('picture')
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
        $result.Files[0].Fixed | Should -BeExactly "<#`n---`ncatzc:`n  derived:`n    path: automation/Catzc.Widget/Get-Gadget.ps1`n    module: Catzc.Widget`n    visibility: public`n---`n#>`n`nfunction Get-Gadget { }`n"
        $result.Files[1].Fixed | Should -BeLike "*    visibility: private`n---`n#>`n`nfunction Get-Sprocket { }`n"
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
        $text = "<#`n---`ncatzc:`n  derived:`n    colour: red`n---`n#>`n`nfunction Get-Gadget { }`n"
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'automation/Catzc.Widget/Get-Gadget.ps1'), $text)
        $result = & $script:run $script:entries[0]
        $result.Files[0].Findings.Kind | Should -Be @('UnownedHead')
        $result.Files[0].Findings[0].Actual | Should -Be 'catzc.derived.colour'
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

    It 'imprints a JSON file''s block as its first property, and finds nothing to change once it is written' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.json'), "{`n  `"name`": `"widget`"`n}`n")
        $entry = [pscustomobject]@{ Path = 'docs/widget.json'; Carrier = $script:property }
        $first = & $script:run @($entry)
        $first.Files[0].Findings[0].Kind | Should -Be 'Drift'
        $first.Files[0].Fixed | Should -BeExactly "{`n  `"//`": `"catzc:\n  derived:\n    path: docs/widget.json`",`n  `"name`": `"widget`"`n}`n"

        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.json'), $first.Files[0].Fixed)
        @((& $script:run @($entry)).Files).Count | Should -Be 0
    }

    It 'replaces an old banner a property carrier strips, and reports a foreign value of the property' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/banner.json'), "{`n  `"//`": `"GENERATED FILE - do not edit.`",`n  `"name`": `"widget`"`n}`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/note.json'), "{`n  `"//`": `"a note someone wrote`"`n}`n")
        $banner = & $script:run @([pscustomobject]@{ Path = 'docs/banner.json'; Carrier = $script:property })
        $banner.Files[0].Fixed | Should -BeExactly "{`n  `"//`": `"catzc:\n  derived:\n    path: docs/banner.json`",`n  `"name`": `"widget`"`n}`n"

        $note = & $script:run @([pscustomobject]@{ Path = 'docs/note.json'; Carrier = $script:property })
        $note.Files[0].Findings.Kind | Should -Be @('UnownedHead')
        $note.Files[0].Findings[0].Actual | Should -BeLike "property '//' holds something else"
        $note.Files[0].Fixed | Should -BeExactly "{`n  `"//`": `"a note someone wrote`"`n}`n"
    }

    It 'leaves a JSON text that is no object alone' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/list.json'), "[1, 2]`n")
        $result = & $script:run @([pscustomobject]@{ Path = 'docs/list.json'; Carrier = $script:property })
        $result.FileCount | Should -Be 1
        @($result.Files).Count | Should -Be 0
    }

    It 'asks a sidecar carrier only for the description beside the file, and never reads the file itself' {
        [System.IO.File]::WriteAllBytes((Join-Path $script:widgetRoot 'docs/gadget.pic'), [byte[]] @(0, 255, 1))
        [System.IO.File]::WriteAllBytes((Join-Path $script:widgetRoot 'docs/sprocket.pic'), [byte[]] @(0, 255, 2))
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/sprocket.md'), "# Sprocket`n")
        $result = & $script:run @(
            [pscustomobject]@{ Path = 'docs/gadget.pic'; Carrier = $script:sidecar }
            [pscustomobject]@{ Path = 'docs/sprocket.pic'; Carrier = $script:sidecar }
        )
        $result.FileCount | Should -Be 2
        @($result.Files).Count | Should -Be 1
        $result.Files[0].Path | Should -Be 'docs/gadget.pic'
        $result.Files[0].Findings[0].Kind | Should -Be 'MissingSidecar'
        $result.Files[0].Findings[0].Expected | Should -Be 'docs/gadget.md'
    }

    It 'checks the entries it is handed, and never asks for a scope of its own' {
        Mock Get-FileMetaScope { throw 'the scope must not be asked for' } -ModuleName Catzc.Base.QualityGates
        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Config = $script:config; Entries = @($script:entries[0]) } {
            param($Root, $Config, $Entries)
            Invoke-FileMetaEngine -RepositoryRoot $Root -Config $Config -Entry $Entries
        }
        $result.FileCount | Should -Be 1
        $result.Files[0].Path | Should -Be 'automation/Catzc.Widget/Get-Gadget.ps1'
        Should -Invoke Get-FileMetaScope -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'imprints nothing and reports nothing for an empty scope' {
        $result = & $script:run @()
        $result.FileCount | Should -Be 0
        @($result.Files).Count | Should -Be 0
    }
}
