Describe 'Get-SlidePictureFinding' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-CHECKABLECLAIMS' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:write = {
            param([string] $Relative, [string] $Content)
            $full = Join-Path $script:root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Content)
            $full
        }
        $script:then = [datetime]::new(2026, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)
        # The article carrier: a yml drawio block directly above the image of its png.
        & $write 'docs/widgets/widget-flow.md' "# Widgets`n`n``````yml drawio`nabout:`n  rules: [ADR-WIDGET-SPIN-FAST, ADR-GADGET-TURN]`ncontent:`n  title: Widgets`n```````n`n![Widgets](.assets/widget-flow.drawio.png)`n" | Out-Null
        $widgetPng = & $write 'docs/widgets/.assets/widget-flow.drawio.png' 'png'
        [System.IO.File]::SetLastWriteTimeUtc($widgetPng, $then)
        # The file carrier, citing another rule.
        & $write 'docs/gadgets/.assets/gadget-flow.drawio.yml' "about:`n  rules: [ADR-GADGET-TURN]`ncontent:`n  title: Gadgets`n" | Out-Null
        [System.IO.File]::SetLastWriteTimeUtc((& $write 'docs/gadgets/.assets/gadget-flow.drawio.png' 'png'), $then)
        [System.IO.File]::SetLastWriteTimeUtc((& $write 'docs/gadgets/.assets/bare-flow.drawio.png' 'png'), $then)
        $script:find = {
            param([string] $Name, [string] $Source, [string] $Eyebrow = '1 / 2 · fact · ADR-WIDGET-SPIN', [string] $Image = '', [int] $PictureAge = 1)
            $picture = if ($Source) {
                "    picture:`n      mode: reduce`n      source: $Source`n"
            }
            $imageField = if ($Image) {
                "## Image`n`n$Image`n`n"
            }
            $path = & $script:write "docs/widgets/deck/$Name.slide.md" "---`ncatzc:`n  config:`n    pattern: fact`n    deck: deck`n    order: 1`n$picture---`n`n# The widget spins`n`n## Eyebrow`n`n$Eyebrow`n`n## Lead`n`nA widget spins.`n`n$imageField"
            $shown = & $script:write "docs/widgets/deck/.assets/$Name.png" 'png'
            [System.IO.File]::SetLastWriteTimeUtc($shown, $script:then.AddDays($PictureAge))
            InModuleScope Catzc.Base.Slides -Parameters @{ Path = $path; Root = $script:root; Name = $Name } {
                param($Path, $Root, $Name)
                $slide = Read-SlideFile -Path $Path
                @(Get-SlidePictureFinding $slide -Relative "docs/widgets/deck/$Name.slide.md" -RepositoryRoot $Root | ForEach-Object { "$_" })
            }
        }
    }

    It 'finds nothing on a text-only slide, which names no picture' {
        & $find 'plain' '' | Should -BeNullOrEmpty
    }

    It 'passes a picture whose diagram cites a rule of the slide''s record, made after its source' {
        & $find 'shown' '../.assets/widget-flow.drawio.png' -Image '[shown](.assets/shown.png)' | Should -BeNullOrEmpty
    }

    It 'names a picture whose diagram cites another rule, in a file carrier' {
        & $find 'stray' '../../gadgets/.assets/gadget-flow.drawio.png' -Image '[stray](.assets/stray.png)' |
            Should -Be @("docs/widgets/deck/stray.slide.md: field 'picture': the picture's source 'docs/gadgets/.assets/gadget-flow.drawio.png' cites ADR-GADGET-TURN, never the slide's ADR-WIDGET-SPIN; show a diagram whose about.rules cites it, or no picture")
    }

    It 'names a picture older than its source' {
        & $find 'stale' '../.assets/widget-flow.drawio.png' -Image '[stale](.assets/stale.png)' -PictureAge -1 |
            Should -Be @("docs/widgets/deck/stale.slide.md: field 'image': the picture '.assets/stale.png' is older than its source 'docs/widgets/.assets/widget-flow.drawio.png'; make it again with slide_png.py picture")
    }

    It 'names an eyebrow with no rule code and a picture with no Image link' {
        $found = & $find 'unnamed' '../.assets/widget-flow.drawio.png' -Eyebrow '1 / 2 · fact'
        $found | Should -Contain "docs/widgets/deck/unnamed.slide.md: field 'eyebrow': the slide shows a picture, so its eyebrow names the rule code the picture's diagram cites; it names none"
        $found | Should -Contain "docs/widgets/deck/unnamed.slide.md: field 'image': the head names a picture, so ## Image holds one markdown link to it, [<stem>](<path>)"
    }

    It 'names a source that is no catalogue diagram, one that does not exist, and one with no declaration' {
        & $find 'flat' '.assets/flat.png' -Image '[flat](.assets/flat.png)' |
            Should -Be @("docs/widgets/deck/flat.slide.md: field 'picture': the picture's source 'docs/widgets/deck/.assets/flat.png' is no catalogue diagram, an .assets/<name>.drawio.png in the repository")
        & $find 'gone' '../.assets/gone.drawio.png' -Image '[gone](.assets/gone.png)' |
            Should -Be @("docs/widgets/deck/gone.slide.md: field 'picture': the picture's source 'docs/widgets/.assets/gone.drawio.png' does not exist")
        & $find 'bare' '../../gadgets/.assets/bare-flow.drawio.png' -Image '[bare](.assets/bare.png)' |
            Should -Be @("docs/widgets/deck/bare.slide.md: field 'picture': the picture's source 'docs/gadgets/.assets/bare-flow.drawio.png' has no declaration (its .drawio.yml, or one ``yml drawio`` block above its image)")
    }
}
