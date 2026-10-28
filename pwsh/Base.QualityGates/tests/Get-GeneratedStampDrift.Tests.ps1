Describe 'Get-GeneratedStampDrift' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-COMPOSEDFILES' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'widget-repository'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'docs')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'widget')) | Out-Null

        $script:write = {
            param([string] $Relative, [string] $Text)
            [System.IO.File]::WriteAllText((Join-Path $script:root $Relative), $Text,
                [System.Text.UTF8Encoding]::new($false))
        }
        # A Markdown page whose head carries the hash of its body, as Format-GeneratedFileHead writes it.
        $pageBody = "# docs/current.md`n`nbody`n"
        $script:pageHash = (Get-MarkdownMetaState -Text $pageBody).BodyHash
        & $script:write 'docs/current.md' "---`ncatzc:`n  immutable:`n    with_body_sha: `"$script:pageHash`"`n    repo_status: locked`n    path: docs/current.md`n    kind: widget`n---`n$pageBody"
        # The same page with a stamp that no longer matches its body.
        & $script:write 'docs/stale.md' "---`ncatzc:`n  immutable:`n    with_body_sha: `"000000000000`"`n    repo_status: locked`n    path: docs/stale.md`n    kind: widget`n---`n# docs/stale.md`n`nother body`n"
        # A page with no head at all, and one with a head that holds no stamp.
        & $script:write 'docs/bare.md' "# docs/bare.md`n`nbody`n"
        & $script:write 'docs/unstamped.md' "---`ncatzc:`n  immutable:`n    repo_status: locked`n    path: docs/unstamped.md`n    kind: widget`n---`n# docs/unstamped.md`n`nbody`n"
        # A YAML file with a comment head, written through the code-head formatter the generators use.
        $yamlBody = "widget: gadget`n"
        $yamlForm = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#')
        $yamlHash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf((Get-CodeMetaState -Text $yamlBody -Form $yamlForm).Rest)
        & $script:write 'widget/current.yml' (Format-CodeMetaHead -Text $yamlBody -Form $yamlForm -Immutable ([ordered]@{ with_body_sha = $yamlHash; repo_status = 'locked'; path = 'widget/current.yml'; kind = 'config' }))
        # A file named png that is no png has no chunk to hold a head.
        [System.IO.File]::WriteAllBytes((Join-Path $script:root 'widget/picture.png'), [byte[]] @(137, 80, 78, 71))
        # The smallest png, its signature, a 1x1 IHDR and an IEND, stamped in its catzc tEXt chunk with the hash of the image without it.
        $chunk = {
            param([string] $Type, [byte[]] $Data)
            $body = [byte[]] @([System.Text.Encoding]::ASCII.GetBytes($Type) + $Data)
            $crc = [Catzc.Base.Languages.PngTextCarrier]::Crc($body, 0, $body.Length)
            [byte[]] @([System.BitConverter]::GetBytes([uint32] $Data.Length)[3..0] + $body + [System.BitConverter]::GetBytes([uint32] $crc)[3..0])
        }
        $png = [byte[]] @(
            [byte[]] @(0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A)
            (& $chunk 'IHDR' ([byte[]] @(0, 0, 0, 1, 0, 0, 0, 1, 8, 0, 0, 0, 0)))
            (& $chunk 'IEND' ([byte[]] @()))
        )
        $pngHash = [Catzc.Base.Languages.PngTextCarrier]::HashOf($png)
        [System.IO.File]::WriteAllBytes((Join-Path $script:root 'widget/stamped.png'),
            [Catzc.Base.Languages.PngTextCarrier]::With($png, "catzc:`n  immutable:`n    with_body_sha: `"$pngHash`""))
        # An svg stamped in its metadata element with the hash of the drawing without it.
        $svg = "<svg xmlns=`"http://www.w3.org/2000/svg`"><rect width=`"1`"/></svg>`n"
        $svgHash = [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($svg)
        & $script:write 'widget/drawing.svg' ([Catzc.Base.Languages.SvgMetadataCarrier]::With($svg, "catzc:`n  immutable:`n    with_body_sha: `"$svgHash`""))

        $script:all = 'docs/current.md', 'docs/stale.md', 'docs/bare.md', 'docs/unstamped.md', 'widget/current.yml', 'widget/picture.png', 'widget/stamped.png', 'widget/drawing.svg'
        $script:run = {
            param([string[]] $Path)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root; Path = $Path } {
                param($Root, $Path)
                Get-GeneratedStampDrift -RepositoryRoot $Root -Path $Path
            }
        }
    }

    It 'lets a page and a comment-head file whose stamp is the hash of the body pass, so their writer need not render' -Tag 'ADR-REPO-FILEMETA-INTUNEWITHGENERATOR' {
        @(& $script:run @('docs/current.md', 'widget/current.yml')) | Should -BeNullOrEmpty
    }

    It 'names a file whose stamp is not the hash of its body as a miss, for its writer to render' -Tag 'ADR-REPO-FILEMETA-INTUNEWITHGENERATOR' {
        @(& $script:run @('docs/stale.md')) | Should -Be @('docs/stale.md')
    }

    It 'lets a png and an svg pass whose stamp, read through their carriers, is the hash of the body' -Tag 'ADR-REPO-FILEMETA-EVERYFORMATCARRIES' {
        @(& $script:run @('widget/stamped.png', 'widget/drawing.svg')) | Should -BeNullOrEmpty
    }

    It 'names a file with no head, no stamp, no carrier to read or no file on disk as a miss, since only the render can tell' -Tag 'ADR-REPO-FILEMETA-INTUNEWITHGENERATOR' {
        @(& $script:run ($script:all + 'widget/gone.yml')) |
            Should -Be @('docs/stale.md', 'docs/bare.md', 'docs/unstamped.md', 'widget/picture.png', 'widget/gone.yml')
    }

    It 'reads nothing for no paths' {
        @(& $script:run @()) | Should -BeNullOrEmpty
    }
}
