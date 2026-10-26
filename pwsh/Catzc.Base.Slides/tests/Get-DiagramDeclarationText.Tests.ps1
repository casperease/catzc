Describe 'Get-DiagramDeclarationText' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-DECLARATION' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'docs/widgets/.assets')) | Out-Null
        $script:read = {
            param([string] $Stem)
            InModuleScope Catzc.Base.Slides -Parameters @{ Root = $script:root; Stem = $Stem } {
                param($Root, $Stem)
                Get-DiagramDeclarationText -Stem $Stem -RepositoryRoot $Root
            }
        }
        $script:page = Join-Path $script:root 'docs/widgets/gadget-flow.md'
        $script:block = "``````yml drawio`ncontent: { title: Gadgets }`n```````n"
    }

    AfterEach {
        foreach ($page in Get-ChildPath (Join-Path $script:root 'docs/widgets') -Depth 1 -File -Filter '*.md') {
            [System.IO.File]::Delete($page)
        }
    }

    It 'reads the file carrier, the yml beside the png, whatever else is in the folder' {
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/.assets/widget-flow.drawio.yml'), "content: { title: Widgets }`n")
        & $script:read 'docs/widgets/.assets/widget-flow' | Should -BeExactly "content: { title: Widgets }`n"
    }

    It 'gives nothing for a diagram with neither a yml beside its png nor a block in an article' {
        & $script:read 'docs/widgets/.assets/sprocket-flow' | Should -BeNullOrEmpty
    }

    It 'reads the article carrier: the one yml drawio block directly above the image of its png' {
        [System.IO.File]::WriteAllText($script:page, "# Gadgets`n`n$($script:block)`n![Gadgets](.assets/gadget-flow.drawio.png)`n")
        & $script:read 'docs/widgets/.assets/gadget-flow' | Should -BeExactly "content: { title: Gadgets }`n"
    }

    It 'reads the article carrier above a reference-style image, whose definition names the png, whatever the label''s case' {
        [System.IO.File]::WriteAllText($script:page, "# Gadgets`n`n$($script:block)`n![Gadgets][Diagram]`n`n[diagram]: .assets/gadget-flow.drawio.png`n")
        & $script:read 'docs/widgets/.assets/gadget-flow' | Should -BeExactly "content: { title: Gadgets }`n"
    }

    It 'gives nothing above a reference image whose definition names another png' {
        [System.IO.File]::WriteAllText($script:page, "# Gadgets`n`n$($script:block)`n![Gadgets][d]`n`n[d]: .assets/sprocket-flow.drawio.png`n")
        & $script:read 'docs/widgets/.assets/gadget-flow' | Should -BeNullOrEmpty
    }

    It 'gives nothing when a sentence stands between the block and the image, or when two blocks declare it' {
        [System.IO.File]::WriteAllText($script:page, "# Gadgets`n`n$($script:block)`nA sentence.`n`n![Gadgets](.assets/gadget-flow.drawio.png)`n")
        & $script:read 'docs/widgets/.assets/gadget-flow' | Should -BeNullOrEmpty
        [System.IO.File]::WriteAllText($script:page, "# Gadgets`n`n$($script:block)`n![Gadgets](.assets/gadget-flow.drawio.png)`n")
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/second.md'), "# Again`n`n$($script:block)`n![Gadgets](.assets/gadget-flow.drawio.png)`n")
        & $script:read 'docs/widgets/.assets/gadget-flow' | Should -BeNullOrEmpty
    }

    It 'never reads a block from a slide, so a slide beside the article is no second carrier' {
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widgets/gadget-flow.slide.md'), "$($script:block)`n![Gadgets](.assets/gadget-flow.drawio.png)`n")
        & $script:read 'docs/widgets/.assets/gadget-flow' | Should -BeNullOrEmpty
        [System.IO.File]::WriteAllText($script:page, "# Gadgets`n`n$($script:block)`n![Gadgets](.assets/gadget-flow.drawio.png)`n")
        & $script:read 'docs/widgets/.assets/gadget-flow' | Should -BeExactly "content: { title: Gadgets }`n"
    }

    It 'does not backtrack through a long block of another diagram on a page with CRLF line ends' {
        $lines = (1..70 | ForEach-Object { "key_$($_): value" }) -join "`r`n"
        [System.IO.File]::WriteAllText($script:page, "# Other`r`n`r`n``````yml drawio`r`n$lines`r`n```````r`n`r`n![Other](.assets/other-flow.drawio.png)`r`n")
        $elapsed = [System.Diagnostics.Stopwatch]::StartNew()
        & $script:read 'docs/widgets/.assets/gadget-flow' | Should -BeNullOrEmpty
        $elapsed.Elapsed.TotalSeconds | Should -BeLessThan 5
    }
}
