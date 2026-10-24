Describe 'Get-DiagramArticleStem' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-DECLARATION' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'docs/widgets')) | Out-Null
        $script:block = "``````yml drawio`ncontent: { title: Gadgets }`n```````n"
        $script:stems = {
            param([string[]] $Candidate)
            InModuleScope Catzc.Base.Slides -Parameters @{ Root = $script:root; Candidate = $Candidate } {
                param($Root, $Candidate)
                @(Get-DiagramArticleStem -RepositoryRoot $Root -Candidate $Candidate)
            }
        }
    }

    AfterEach {
        foreach ($page in Get-ChildPath (Join-Path $script:root 'docs/widgets') -Depth 1 -File -Filter '*.md') {
            [System.IO.File]::Delete($page)
        }
    }

    It 'names the diagram a block sits directly above, by its page folder and the png it embeds' {
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/gadget-flow.md'), "# Gadgets`n`n$($script:block)`n![Gadgets](.assets/gadget-flow.drawio.png)`n")
        & $script:stems 'docs/widgets/gadget-flow.md' | Should -Be @('docs/widgets/.assets/gadget-flow')
    }

    It 'names nothing for a block with a sentence between it and the image, or an image of no png' {
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/gadget-flow.md'), "# Gadgets`n`n$($script:block)`nA sentence.`n`n![Gadgets](.assets/gadget-flow.drawio.png)`n")
        & $script:stems 'docs/widgets/gadget-flow.md' | Should -BeNullOrEmpty
    }

    It 'never reads a slide, a file outside docs, or a page that is not there' {
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/gadget-flow.slide.md'), "$($script:block)`n![Gadgets](.assets/gadget-flow.drawio.png)`n")
        & $script:stems 'docs/widgets/gadget-flow.slide.md', 'notes/other.md', 'docs/widgets/missing.md' | Should -BeNullOrEmpty
    }
}
