Describe 'Get-DiagramEmbedder' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-ONEBUILDCOMMAND' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'docs/widgets')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/gadget.md'),
            "# Gadget`n`n![Gadget](.assets/gadget.drawio.png)`n")
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/cog.slide.md'),
            "# Cog`n`n## Image`n`n[cog](.assets/cog.drawio.png)`n`n## Caption`n`nA cog.`n")
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/sprocket.md'),
            "# Sprocket`n`n## Image`n`n.assets/sprocket.drawio.png`n")
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/widget.md'),
            "# Widget`n`n![Widget][D]`n`n[d]: .assets/widget.drawio.png`n[unused]: .assets/gizmo.drawio.png`n")
        $script:found = InModuleScope Catzc.Base.Slides -Parameters @{ Root = $script:root } {
            param($Root)
            Get-DiagramEmbedder -Tracked @('docs/widgets/gadget.md', 'docs/widgets/cog.slide.md',
                'docs/widgets/sprocket.md', 'docs/widgets/widget.md') -RepositoryRoot $Root
        }
    }

    It 'finds a page that embeds a diagram by a reference-style image, and no png a definition names but no image uses' {
        $script:found['docs/widgets/.assets/widget'] | Should -Be @('docs/widgets/widget.md')
        $script:found.ContainsKey('docs/widgets/.assets/gizmo') | Should -BeFalse
    }

    It 'finds a page that embeds a diagram by a markdown image' {
        $script:found['docs/widgets/.assets/gadget'] | Should -Be @('docs/widgets/gadget.md')
    }

    It 'finds a slide file that embeds its diagram by the link under its Image heading, and no other page by that form' {
        $script:found['docs/widgets/.assets/cog'] | Should -Be @('docs/widgets/cog.slide.md')
        $script:found.ContainsKey('docs/widgets/.assets/sprocket') | Should -BeFalse
    }

    It 'refuses a slide file whose Image section is a bare path, naming the file' {
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/gizmo.slide.md'),
            "# Gizmo`n`n## Image`n`n.assets/gizmo.drawio.png`n")
        {
            InModuleScope Catzc.Base.Slides -Parameters @{ Root = $script:root } {
                param($Root)
                Get-DiagramEmbedder -Tracked @('docs/widgets/gizmo.slide.md') -RepositoryRoot $Root
            }
        } | Should -Throw '*docs/widgets/gizmo.slide.md: the ## Image section holds one markdown link*'
    }
}
