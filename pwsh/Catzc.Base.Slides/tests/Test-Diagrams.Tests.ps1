<#
---
catzc:
  immutable:
    with_body_sha: "143eee08cfd2"
  edges:
    code: pwsh/Catzc.Base.Slides/Test-Diagrams.ps1
    cites:
      - ADR-REPO-SLIDES-DECLARATION
      - ADR-REPO-SLIDES-TWODIRECTIONS
---
#>

Describe 'Test-Diagrams' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-TWODIRECTIONS' {
    BeforeAll {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:root = $root
        $assets = Join-Path $root 'docs/explanation/widget/.assets'
        [System.IO.Directory]::CreateDirectory($assets) | Out-Null
        foreach ($name in 'widget-flow', 'gadget-flow', 'sprocket-flow', 'cog-flow', 'gear-flow') {
            [System.IO.File]::WriteAllText((Join-Path $assets "$name.drawio.yml"), "content: {}`n")
        }
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'kit')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $root 'kit/declaration.py'), '')
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'kit/configs')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $root 'kit/configs/drawio.yml'), "renderer:`n  carrier: file`ncarriers:`n")
        $script:out = Join-Path $root 'out'
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides {
            'widget-flow', 'gadget-flow', 'sprocket-flow', 'cog-flow', 'gear-flow' | ForEach-Object { "docs/explanation/widget/.assets/$_.drawio.png" }
        }
        # A new diagram no commit holds yet: its declaration and its first put are untracked.
        [System.IO.File]::WriteAllText((Join-Path $assets 'new-flow.drawio.yml'), "content: {}`n")
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Slides {
            'docs/explanation/widget/.assets/new-flow.drawio.yml', 'docs/explanation/widget/.assets/new-flow.drawio.png'
        }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Slides { [pscustomobject]@{ Found = $true; Path = 'uv' } }
        Mock Write-DiagramMinimapData -ModuleName Catzc.Base.Slides { }
        # The kit's check prints one JSON line per folder; the mock answers from the folder names on the command line.
        Mock Invoke-Executable -ModuleName Catzc.Base.Slides {
            $lines = foreach ($name in 'widget-flow', 'gadget-flow', 'sprocket-flow', 'cog-flow', 'gear-flow', 'new-flow') {
                $folder = "docs/explanation/widget/.assets/$name"
                if ($Command -notlike "*`"$folder`"*") {
                    continue
                }
                switch ($name) {
                    { $_ -in 'widget-flow', 'new-flow' } {
                        "{`"diagram`":`"$folder`", `"drift`": [], `"stale`": []}"
                    }
                    'gadget-flow' {
                        "{`"diagram`":`"$folder`", `"drift`": [`"gadget-store`", `"title`"], `"stale`": []}"
                    }
                    'sprocket-flow' {
                        "{`"diagram`":`"$folder`", `"drift`": [], `"stale`": [`"minimap-2`"]}"
                    }
                    'cog-flow' {
                        "{`"diagram`":`"$folder`", `"error`": `"no cog-flow.drawio.yml`"}"
                    }
                    'gear-flow' {
                        "{`"diagram`":`"$folder`", `"conflict`": [`"gear-train`", `"widget-a`"], `"drift`": [], `"stale`": []}"
                    }
                }
            }
            [pscustomobject]@{ ExitCode = 0; Output = $lines -join "`n" }
        }
    }

    It 'passes a folder whose png is what put of its yml writes' {
        $report = Test-Diagrams -Path 'docs/explanation/widget/.assets/widget-flow' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.IssueCount | Should -Be 0
        $report.Facts['DiagramCount'] | Should -Be 1
    }

    It 'fails a folder whose png drifted from its yml, naming the cells' {
        { Test-Diagrams -Path 'docs/explanation/widget/.assets/gadget-flow' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out } | Should -Throw '*Test-Diagrams failed: 1 issue(s)*'
        $report = Test-Diagrams -Path 'docs/explanation/widget/.assets/gadget-flow' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.Issues[0] | Should -BeLike '*gadget-flow: the png differs from put of its yml in gadget-store, title*'
    }

    It 'fails a pair edited on both sides since HEAD, naming the cells and the way out' {
        $report = Test-Diagrams -Path 'docs/explanation/widget/.assets/gear-flow' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.Issues[0] | Should -BeLike '*gear-flow: the yml and the png both moved from HEAD and disagree in gear-train, widget-a; put or get it by name*'
    }

    It 'reports stale minimaps as a fact, not an issue' {
        $report = Test-Diagrams -Path 'docs/explanation/widget/.assets/sprocket-flow' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.IssueCount | Should -Be 0
        $report.Facts['StaleMinimapCount'] | Should -Be 1
        $report.Facts['StaleDiagrams'] | Should -Be @('docs/explanation/widget/.assets/sprocket-flow')
    }

    It 'fails a folder the kit cannot read, with the kit''s error' {
        $report = Test-Diagrams -Path 'docs/explanation/widget/.assets/cog-flow' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.Issues[0] | Should -BeLike '*cog-flow: no cog-flow.drawio.yml'
    }

    It 'checks every declared folder when no path is given' {
        $report = Test-Diagrams -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.Facts['DiagramCount'] | Should -Be 6
        $report.IssueCount | Should -Be 3
    }

    It 'fails a page whose yml drawio block has no image of a diagram directly below it' -Tag 'ADR-REPO-SLIDES-DECLARATION' {
        $page = Join-Path $root 'docs/explanation/widget/widget-page.md'
        [System.IO.File]::WriteAllText($page, "# Widget`n`n``````yml drawio`ncontent: {}`n```````n`nA sentence, then the image.`n`n![Widget](.assets/widget-flow.drawio.png)`n")
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Slides {
            'docs/explanation/widget/.assets/new-flow.drawio.yml', 'docs/explanation/widget/.assets/new-flow.drawio.png', 'docs/explanation/widget/widget-page.md'
        }
        try {
            $report = Test-Diagrams -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
            @($report.Issues | Where-Object { $_.StartsWith('docs/explanation/widget/widget-page.md: 1 ', [System.StringComparison]::Ordinal) -and $_.Contains('block(s) with no image') }).Count | Should -Be 1
        }
        finally {
            [System.IO.File]::Delete($page)
        }
    }

    It 'checks an untracked diagram once its first put has run, and passes it, named by its yml' {
        $report = Test-Diagrams -Path 'docs/explanation/widget/.assets/new-flow.drawio.yml' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.IssueCount | Should -Be 0
        $report.Facts['DiagramCount'] | Should -Be 1
    }

    It 'refuses a path that is not a declared diagram' {
        { Test-Diagrams -Path 'docs/explanation/widget' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out } | Should -Throw '*is not a declared diagram (*'
    }
}
