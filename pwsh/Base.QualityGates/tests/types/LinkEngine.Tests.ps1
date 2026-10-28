Describe 'LinkEngine edges' -Tag 'L0', 'logic', 'ADR-REPO-LINKS-EVERYLINKHASADIRECTION', 'ADR-REPO-LINKS-CHECKEDBYONEGATE' {
    BeforeAll {
        $script:writeFile = {
            param([string] $Root, [string] $Relative, [string] $Text)
            $full = Join-Path $Root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Text)
        }
        $script:root = Join-Path $TestDrive 'repo'
        & $writeFile $root 'docs/drs/index.md' "| Code | Record |`n| ---- | --- |`n| ``ADR-TST-WIDGET`` | [widget-rules](widget/widget-rules.md) |`n"
        & $writeFile $root 'docs/drs/widget/widget-rules.md' "# Widget rules`n`n### Rule ADR-TST-WIDGET-SPIN`n`nOne.`n"
        & $writeFile $root 'docs/gadget.md' "# Gadget`n`n## Part`n"
        & $writeFile $root 'docs/widget.md' ("# Widget`n`nSee [gadget](gadget.md), [part](gadget.md#part), [self](#widget), [folder](drs), " +
            "[site](https://example.com/gadget) and [gone](missing.md).`n`n![picture](gadget.md)`n")
        & $writeFile $root 'docs/references/src/widget.ps1.md' "# src/widget.ps1`n"
        & $writeFile $root 'src/widget.ps1' ("<#`n---`ncatzc:`n  docs: ""../docs/references/src/widget.ps1.md""`n  header: ""generated""`n---`n#>`n`n" +
            "# Spins as [ADR-TST-WIDGET-SPIN](/docs/drs/widget/widget-rules.md#rule-adr-tst-widget-spin) says; see [gadget](/docs/gadget.md).`n" +
            "# Also ADR-TST-WIDGET-SPIN, and [site](https://example.com/widget).`n" +
            "`$path = 'docs/gadget.md'`nfunction Get-Widget { }`n")
        $script:run = {
            param([switch] $IncludeEdge)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; IncludeEdge = $IncludeEdge.IsPresent } {
                param($Root, $IncludeEdge)
                Invoke-LinkEngine -RepositoryRoot $Root -Path (Join-Path $Root 'docs/widget.md'), (Join-Path $Root 'src/widget.ps1') -Kind Both -Wrap Break -IncludeEdge:$IncludeEdge
            }
        }
        $script:edges = @((& $script:run -IncludeEdge).Edges)
    }

    It 'records a markdown link to a tracked file, its anchor dropped, and none for an anchor, a folder, a URL, a missing target or an image' {
        $markdown = @($edges.Where({ $_.File -eq 'docs/widget.md' }))
        @($markdown.ForEach({ "$($_.Relation) $($_.Target)" })) | Should -Be @('MarkdownLink docs/gadget.md',
            'MarkdownLink docs/gadget.md')
        $markdown[0].Line | Should -Be 3
    }

    It 'records a code link with its rule code, a bare citation as the link it aligns to, a non-rule comment link, and a docs edge' {
        $code = @($edges.Where({ $_.File -eq 'src/widget.ps1' }))
        @($code.ForEach({ "$($_.Relation) $($_.Target) $($_.Code)".Trim() })) | Should -Be @(
            'DocsEdge docs/references/src/widget.ps1.md'
            'CodeLink docs/drs/widget/widget-rules.md ADR-TST-WIDGET-SPIN'
            'CodeLink docs/gadget.md'
            'CodeLink docs/drs/widget/widget-rules.md ADR-TST-WIDGET-SPIN'
        ) -Because 'a string naming a path is data, and a URL is no relation'
    }

    It 'returns no edge when none was asked for' {
        @((& $script:run).Edges) | Should -HaveCount 0
    }

    It 'reads the head''s docs edge as a bare path from the file''s folder, quoted or plain, and finds one that does not resolve' {
        & $writeFile $root 'src/plain.ps1' "<#`n---`ncatzc:`n  docs: ../docs/references/src/widget.ps1.md`n  header: ""generated""`n---`n#>`n`nfunction Get-Plain { }`n"
        & $writeFile $root 'src/gone.ps1' "<#`n---`ncatzc:`n  docs: ""../docs/references/src/gone.ps1.md""`n  header: ""generated""`n---`n#>`n`nfunction Get-Gone { }`n"
        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            param($Root)
            Invoke-LinkEngine -RepositoryRoot $Root -Path (Join-Path $Root 'src/plain.ps1'), (Join-Path $Root 'src/gone.ps1') -Kind Both -Wrap Break -IncludeEdge
        }
        @($result.Edges.Where({ $_.File -eq 'src/plain.ps1' }).ForEach({ "$($_.Relation) $($_.Target)" })) |
            Should -Be @('DocsEdge docs/references/src/widget.ps1.md')
        @($result.Findings.Where({ $_.File -eq 'src/gone.ps1' }).ForEach({ $_.Message })) |
            Should -BeLike "*docs edge '../docs/references/src/gone.ps1.md' does not resolve*"
        @($result.Findings.Where({ $_.File -eq 'src/plain.ps1' })) | Should -HaveCount 0
    }
}
