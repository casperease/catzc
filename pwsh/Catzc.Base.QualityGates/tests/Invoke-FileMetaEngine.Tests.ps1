<#
---
catzc:
  edges:
    cites:
      - ADR-REPO-CODEMETA-SAMEENGINE
      - ADR-REPO-FILEMETA-HEADPOLICY
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-FILEMETA-KINDSCOPE
      - ADR-REPO-FILEMETA-FILEISNODE
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'The fixture fact processors keep the State, Path and Kind parameters the engine passes by name, though they read only Path')]
param()

Describe 'Invoke-FileMetaEngine' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS', 'ADR-REPO-CODEMETA-SAMEENGINE' {
    BeforeAll {
        $script:widgetRoot = Join-Path $TestDrive 'engine-repository'
        # The banner a property carrier strips is the one warning every generated head carries.
        $script:warning = (Get-Config -Config generated-head).warning
        $carriers = [Catzc.Base.Languages.FileCarriersConfig]::new(@{
                carriers = [ordered]@{
                    powershell = @{ carrier = 'comment-head'; block = @('<#', '#>') }
                    markdown   = @{ carrier = 'front-matter' }
                    json       = @{ carrier = 'property'; property = '//'; strip = @($script:warning) }
                    skill      = @{ files = @('docs/skills/**/SKILL.md'); carrier = 'front-matter'; key = 'metadata.catzc' }
                }
            })
        $script:head = $carriers.Find('powershell')
        $script:front = $carriers.Find('markdown')
        $script:nested = $carriers.Find('skill')
        $script:property = $carriers.Find('json')
        $script:kinds = [Catzc.Base.Globs.FileKindsConfig]::new(@{
                kinds = [ordered]@{
                    'widget-function' = [ordered]@{ definition = 'A widget function.'; files = @('widgets/**/*.ps1') }
                    'widget-code'     = [ordered]@{ definition = 'Any other widget code.'; files = @('widgets/**') }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'file-kinds' } { $script:kinds }
        Mock Get-CatzcModulesFolder -ModuleName Catzc.Base.QualityGates { 'widgets' }
        Mock Get-PathModule -ModuleName Catzc.Base.QualityGates {
            if ($Path -match '^widgets/(?<name>[^/.][^/]*)/') {
                [pscustomobject]@{ name = $Matches['name'] }
            }
        }
        # Fixture kinds with fixture processors, so the engine is proven on facts of its own, whatever kinds the shipped registry holds.
        InModuleScope Catzc.Base.QualityGates {
            function script:Get-WidgetPathFileMetaFact {
                param($State, $Path, $Kind)
                [ordered]@{ path = $Path }
            }
            function script:Get-WidgetModuleFileMetaFact {
                param($State, $Path, $Kind)
                [ordered]@{ module = "$((Get-PathModule $Path).name)" }
            }
            function script:Get-WidgetVisibilityFileMetaFact {
                param($State, $Path, $Kind)
                [ordered]@{ visibility = $Path -match '/private/' ? 'private' : 'public' }
            }
        }
        $script:widgetKinds = [ordered]@{
            'widget-path'       = @{ keys = @('path') }
            'widget-module'     = @{ keys = @('module'); select = @(@{ classes = @('widget-*') }) }
            'widget-visibility' = @{ keys = @('visibility'); select = @(@{ classes = @('widget-function') }) }
        }
        $script:config = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ head_policy = @{ default = 'facts' }; kinds = $script:widgetKinds })
        $script:run = {
            param($Entries, $Config = $script:config)
            $script:engineEntries = $Entries
            Mock Get-FileMetaScope { $script:engineEntries } -ModuleName Catzc.Base.QualityGates
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Config = $Config } {
                param($Root, $Config)
                Invoke-FileMetaEngine -RepositoryRoot $Root -Config $Config
            }
        }
    }

    AfterAll {
        InModuleScope Catzc.Base.QualityGates {
            Remove-Item Function:\Get-WidgetPathFileMetaFact, Function:\Get-WidgetModuleFileMetaFact, Function:\Get-WidgetVisibilityFileMetaFact -ErrorAction Ignore
        }
    }

    BeforeEach {
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'widgets/Catzc.Widget/private')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'widgets/Catzc.Widget/Get-Gadget.ps1'), "function Get-Gadget { }`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'widgets/Catzc.Widget/private/Get-Sprocket.ps1'), "function Get-Sprocket { }`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "# Widget`n")
        $script:entries = @(
            [pscustomobject]@{ Path = 'widgets/Catzc.Widget/Get-Gadget.ps1'; Carrier = $script:head }
            [pscustomobject]@{ Path = 'widgets/Catzc.Widget/private/Get-Sprocket.ps1'; Carrier = $script:head }
        )
    }

    It 'writes the head of a function file from the kinds that apply to it, in the registry''s order' {
        $result = & $script:run $script:entries
        $result.FileCount | Should -Be 2
        $result.Files.Count | Should -Be 2
        $result.Files[0].Findings[0].Kind | Should -Be 'Drift'
        $result.Files[0].Fixed | Should -BeExactly "<#`n---`ncatzc:`n  warning: `"Header is generated by Format-FileMeta via Format-Code; do not change it`"`n  edges:`n    path: widgets/Catzc.Widget/Get-Gadget.ps1`n    module: Catzc.Widget`n    visibility: public`n---`n#>`n`nfunction Get-Gadget { }`n"
        $result.Files[1].Fixed | Should -BeLike "*    visibility: private`n---`n#>`n`nfunction Get-Sprocket { }`n"
    }

    It 'drops a fact an authored head held under immutable, and writes it in the part its kind names' -Tag 'ADR-REPO-FILEMETA-KINDSCOPE', 'ADR-REPO-FILEMETA-FILEISNODE' {
        $text = "<#`n---`ncatzc:`n  immutable:`n    path: widgets/Catzc.Widget/Get-Gadget.ps1`n---`n#>`n`nfunction Get-Gadget { }`n"
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'widgets/Catzc.Widget/Get-Gadget.ps1'), $text)
        $result = & $script:run $script:entries[0]
        $result.Files[0].Findings.Kind | Should -Be @('Drift')
        $result.Files[0].Findings[0].Actual | Should -Be 'an authored head holds an immutable part, which Format-FileMeta removes'
        $result.Files[0].Fixed | Should -BeExactly "<#`n---`ncatzc:`n  warning: `"Header is generated by Format-FileMeta via Format-Code; do not change it`"`n  edges:`n    path: widgets/Catzc.Widget/Get-Gadget.ps1`n    module: Catzc.Widget`n    visibility: public`n---`n#>`n`nfunction Get-Gadget { }`n"
    }

    It 'skips an entry whose file the working tree no longer has, and still counts it in the scope' {
        $gone = [pscustomobject]@{ Path = 'widgets/Catzc.Widget/Get-Gone.ps1'; Carrier = $script:head }
        $result = & $script:run (@($gone) + $script:entries)
        $result.FileCount | Should -Be 3
        $result.Files.Count | Should -Be 2
        $result.Files.Path | Should -Not -Contain 'widgets/Catzc.Widget/Get-Gone.ps1'
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

    It 'drops an imprinted key no kind owns, since the imprinted parts are wholly the engine''s' -Tag 'ADR-REPO-FILEMETA-KINDSCOPE' {
        $text = "<#`n---`ncatzc:`n  immutable:`n    colour: red`n---`n#>`n`nfunction Get-Gadget { }`n"
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'widgets/Catzc.Widget/Get-Gadget.ps1'), $text)
        $result = & $script:run $script:entries[0]
        $result.Files[0].Findings.Kind | Should -Be @('Drift')
        $result.Files[0].Fixed | Should -Not -BeLike '*colour*'
    }

    It 'keeps a key no kind owns in the authored config part, since that part is the author''s' -Tag 'ADR-REPO-FILEMETA-KINDSCOPE' {
        $text = "<#`n---`ncatzc:`n  config:`n    colour: red`n---`n#>`n`nfunction Get-Gadget { }`n"
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'widgets/Catzc.Widget/Get-Gadget.ps1'), $text)
        $result = & $script:run $script:entries[0]
        $result.Files[0].Findings.Kind | Should -Not -Contain 'Unowned'
        $result.Files[0].Findings.Kind | Should -Not -Contain 'UnownedHead'
        $result.Files[0].Fixed | Should -BeLike "<#`n---`ncatzc:`n  warning: `"Header is generated by Format-FileMeta via Format-Code; do not change it`"`n  edges:`n    path: widgets/Catzc.Widget/Get-Gadget.ps1*  config:`n    colour: red`n---`n#>`n`nfunction Get-Gadget { }`n"
    }

    It 'still reports a section that is neither imprinted nor config, and leaves the file as written' -Tag 'ADR-REPO-FILEMETA-KINDSCOPE' {
        $text = "<#`n---`ncatzc:`n  colour: red`n---`n#>`n`nfunction Get-Gadget { }`n"
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'widgets/Catzc.Widget/Get-Gadget.ps1'), $text)
        $result = & $script:run $script:entries[0]
        $result.Files[0].Findings.Kind | Should -Be @('UnownedHead')
        $result.Files[0].Fixed | Should -BeExactly $text
    }

    It 'handles a Markdown file in the same run, with its own carrier' {
        $mixed = $script:entries + [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }
        $result = & $script:run $mixed
        $result.FileCount | Should -Be 3
        $markdown = $result.Files | Where-Object Path -EQ 'docs/widget.md'
        $markdown.Fixed | Should -BeLike "---`ncatzc:`n  warning: `"Header is generated by Format-FileMeta via Format-Code; do not change it`"`n  edges:`n    path: docs/widget.md*---*# Widget*"
        $markdown.Fixed | Should -Not -BeLike '*module:*' -Because 'the module kind lists widgets/** only'
    }

    It 'nests a block at the key path its carrier names, keeps the authored config there, and reports a parent it cannot nest under' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs/skills/widget-spin')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot 'docs/skills/widget-flow')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/skills/widget-spin/SKILL.md'), "---`nname: widget-spin`nmetadata:`n  catzc:`n    config:`n      floor: low`n---`n1. Spin.`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/skills/widget-flow/SKILL.md'), "---`nname: widget-flow`nmetadata: { catzc: { floor: low } }`n---`n1. Flow.`n")
        $result = & $script:run @(
            [pscustomobject]@{ Path = 'docs/skills/widget-spin/SKILL.md'; Carrier = $script:nested }
            [pscustomobject]@{ Path = 'docs/skills/widget-flow/SKILL.md'; Carrier = $script:nested }
        )
        $spin = $result.Files | Where-Object Path -EQ 'docs/skills/widget-spin/SKILL.md'
        $spin.Findings.Kind | Should -Be @('Drift')
        $spin.Fixed | Should -BeLike "---`nname: widget-spin`nmetadata:`n  catzc:`n    warning: `"Header is generated by Format-FileMeta via Format-Code; do not change it`"`n    edges:`n      path: docs/skills/widget-spin/SKILL.md*    config:`n      floor: low`n---`n1. Spin.`n"
        $spin.Fixed | Should -Not -BeLike ("*`n" + 'catzc:*') -Because 'the block lives at metadata.catzc and nowhere else'
        $flow = $result.Files | Where-Object Path -EQ 'docs/skills/widget-flow/SKILL.md'
        $flow.Findings.Kind | Should -Be @('Unowned')
        $flow.Findings[0].Actual | Should -BeLike '*metadata.catzc holds a flow or scalar value*'
        $flow.Fixed | Should -BeExactly "---`nname: widget-flow`nmetadata: { catzc: { floor: low } }`n---`n1. Flow.`n"
    }

    It 'imprints a JSON file''s block as its first property, and finds nothing to change once it is written' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.json'), "{`n  `"name`": `"widget`"`n}`n")
        $entry = [pscustomobject]@{ Path = 'docs/widget.json'; Carrier = $script:property }
        $first = & $script:run @($entry)
        $first.Files[0].Findings[0].Kind | Should -Be 'Drift'
        $first.Files[0].Fixed | Should -BeExactly "{`n  `"//`": `"catzc:\n  warning: \`"Header is generated by Format-FileMeta via Format-Code; do not change it\`"\n  edges:\n    path: docs/widget.json`",`n  `"name`": `"widget`"`n}`n"

        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.json'), $first.Files[0].Fixed)
        @((& $script:run @($entry)).Files).Count | Should -Be 0
    }

    It 'replaces an old banner a property carrier strips, and reports a foreign value of the property' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/banner.json'), "{`n  `"//`": `"$script:warning`",`n  `"name`": `"widget`"`n}`n")
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/note.json'), "{`n  `"//`": `"a note someone wrote`"`n}`n")
        $banner = & $script:run @([pscustomobject]@{ Path = 'docs/banner.json'; Carrier = $script:property })
        $banner.Files[0].Fixed | Should -BeExactly "{`n  `"//`": `"catzc:\n  warning: \`"Header is generated by Format-FileMeta via Format-Code; do not change it\`"\n  edges:\n    path: docs/banner.json`",`n  `"name`": `"widget`"`n}`n"

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

    It 'checks the entries it is handed, and never asks for a scope of its own' {
        Mock Get-FileMetaScope { throw 'the scope must not be asked for' } -ModuleName Catzc.Base.QualityGates
        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:widgetRoot; Config = $script:config; Entries = @($script:entries[0]) } {
            param($Root, $Config, $Entries)
            Invoke-FileMetaEngine -RepositoryRoot $Root -Config $Config -Entry $Entries
        }
        $result.FileCount | Should -Be 1
        $result.Files[0].Path | Should -Be 'widgets/Catzc.Widget/Get-Gadget.ps1'
        Should -Invoke Get-FileMetaScope -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'imprints nothing and reports nothing for an empty scope' {
        $result = & $script:run @()
        $result.FileCount | Should -Be 0
        @($result.Files).Count | Should -Be 0
    }

    Context 'the head policy' -Tag 'ADR-REPO-FILEMETA-HEADPOLICY' {
        It 'strips the head of a file whose class is forbidden one, and leaves the code as it was' {
            $text = "<#`n---`ncatzc:`n  edges:`n    path: widgets/Catzc.Widget/Get-Gadget.ps1`n---`n#>`n`nfunction Get-Gadget { }`n"
            [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'widgets/Catzc.Widget/Get-Gadget.ps1'), $text)
            $forbidden = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ head_policy = @{ classes = @{ 'widget-function' = 'forbidden' } }; kinds = $script:widgetKinds })
            $result = & $script:run $script:entries[0] $forbidden
            $result.Files[0].Findings.Kind | Should -Be @('Drift')
            $result.Files[0].Findings[0].Expected | Should -BeLike 'no meta block*'
            $result.Files[0].Fixed | Should -BeExactly "function Get-Gadget { }`n"
        }

        It 'removes a Markdown front matter that held nothing but the block' {
            [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "---`ncatzc:`n  edges:`n    path: docs/widget.md`n---`n`n# Widget`n")
            $forbidden = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ head_policy = @{ default = 'forbidden' }; kinds = $script:widgetKinds })
            $result = & $script:run @([pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }) $forbidden
            $result.Files[0].Fixed | Should -BeExactly "# Widget`n"
        }

        It 'keeps only the authored config part of a class whose policy is config, and drops a block that has none' {
            $keep = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ head_policy = @{ classes = @{ '*' = 'config' } }; kinds = $script:widgetKinds })
            [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "---`ncatzc:`n  edges:`n    path: docs/widget.md`n  config:`n    spin: fast`n---`n`n# Widget`n")
            $result = & $script:run @([pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }) $keep
            $result.Files[0].Findings[0].Expected | Should -BeLike 'the authored config part alone*'
            $result.Files[0].Fixed | Should -BeExactly "---`ncatzc:`n  config:`n    spin: fast`n---`n`n# Widget`n"
            [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "---`ncatzc:`n  edges:`n    path: docs/widget.md`n---`n`n# Widget`n")
            $result = & $script:run @([pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }) $keep
            $result.Files[0].Fixed | Should -BeExactly "# Widget`n"
        }

        It 'reports a forbidden block that holds an authored config part, and changes nothing' {
            $text = "<#`n---`ncatzc:`n  config:`n    synopsis: Gets a gadget.`n---`n#>`n`nfunction Get-Gadget { }`n"
            [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'widgets/Catzc.Widget/Get-Gadget.ps1'), $text)
            $forbidden = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ head_policy = @{ default = 'forbidden' }; kinds = $script:widgetKinds })
            $result = & $script:run $script:entries[0] $forbidden
            $result.Files[0].Findings.Kind | Should -Be @('ForbiddenConfig')
            $result.Files[0].Fixed | Should -BeExactly $text
        }

        It 'gives each class by its facts: a head where a fact is non-empty, none where every fact is empty, the stale one stripped' {
            # Only the function class has a fact here, so the Markdown page's facts are all empty.
            $facts = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'widget-visibility' = $script:widgetKinds['widget-visibility'] } })
            [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot 'docs/widget.md'), "---`ncatzc:`n  immutable:`n    with_body_sha: 0123456789ab`n---`n`n# Widget`n")
            $result = & $script:run @($script:entries[0], [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }) $facts
            $function = $result.Files | Where-Object Path -EQ 'widgets/Catzc.Widget/Get-Gadget.ps1'
            $function.Fixed | Should -BeExactly "<#`n---`ncatzc:`n  warning: `"Header is generated by Format-FileMeta via Format-Code; do not change it`"`n  edges:`n    visibility: public`n---`n#>`n`nfunction Get-Gadget { }`n"
            $page = $result.Files | Where-Object Path -EQ 'docs/widget.md'
            $page.Findings[0].Expected | Should -BeLike '*none when every fact is empty'
            $page.Fixed | Should -BeExactly "# Widget`n"
        }

        It 'opens a head with the warning the registry declares, first in the block, and writes no head for the warning alone' {
            $warned = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ warning = 'Widget head, written by the widget engine'; kinds = [ordered]@{ 'widget-visibility' = $script:widgetKinds['widget-visibility'] } })
            $result = & $script:run @($script:entries[0], [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }) $warned
            @($result.Files).Count | Should -Be 1 -Because 'the page has no fact, so it carries no head, warning or not'
            $result.Files[0].Fixed | Should -BeExactly "<#`n---`ncatzc:`n  warning: `"Widget head, written by the widget engine`"`n  edges:`n    visibility: public`n---`n#>`n`nfunction Get-Gadget { }`n"
        }

        It 'writes no head on a file whose facts are all empty and that holds none, so it reports nothing' {
            $facts = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ kinds = [ordered]@{ 'widget-visibility' = $script:widgetKinds['widget-visibility'] } })
            $result = & $script:run @([pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }) $facts
            $result.FileCount | Should -Be 1
            @($result.Files).Count | Should -Be 0
        }

        It 'lets a class entry forbid a block where the default gives the facts' {
            $mixed = [Catzc.Base.QualityGates.FileMetaConfig]::new(@{ head_policy = [ordered]@{ classes = @{ 'widget-function' = 'forbidden' } }; kinds = $script:widgetKinds })
            $result = & $script:run @($script:entries[0], [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = $script:front }) $mixed
            @($result.Files).Count | Should -Be 1 -Because 'the forbidden function file holds no head, so it has nothing to change'
            $result.Files[0].Path | Should -Be 'docs/widget.md'
            $result.Files[0].Fixed | Should -BeLike "---`ncatzc:`n  warning: `"Header is generated by Format-FileMeta via Format-Code; do not change it`"`n  edges:`n    path: docs/widget.md`n---*# Widget`n"
        }
    }
}
