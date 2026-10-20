Describe 'Test-Diagrams' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-TWODIRECTIONS' {
    BeforeAll {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:root = $root
        foreach ($name in 'widget-flow', 'gadget-flow', 'sprocket-flow', 'cog-flow', 'gear-flow') {
            $folder = Join-Path $root "docs/explanation/widget/.assets/$name"
            [System.IO.Directory]::CreateDirectory($folder) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $folder 'diagram.drawio.yml'), "content: {}`n")
        }
        [System.IO.Directory]::CreateDirectory((Join-Path $root 'kit')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $root 'kit/declaration.py'), '')
        $script:out = Join-Path $root 'out'
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Slides {
            'widget-flow', 'gadget-flow', 'sprocket-flow', 'cog-flow', 'gear-flow' | ForEach-Object { "docs/explanation/widget/.assets/$_/diagram.drawio.png" }
        }
        # A new folder no commit holds yet: its declaration and its first put are untracked.
        $new = Join-Path $root 'docs/explanation/widget/.assets/new-flow'
        [System.IO.Directory]::CreateDirectory($new) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $new 'diagram.drawio.yml'), "content: {}`n")
        Mock Get-GitChangedPath -ModuleName Catzc.Base.Slides {
            'docs/explanation/widget/.assets/new-flow/diagram.drawio.yml', 'docs/explanation/widget/.assets/new-flow/diagram.drawio.png'
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
                        "{`"folder`": `"$folder`", `"drift`": [], `"stale`": []}"
                    }
                    'gadget-flow' {
                        "{`"folder`": `"$folder`", `"drift`": [`"gadget-store`", `"title`"], `"stale`": []}"
                    }
                    'sprocket-flow' {
                        "{`"folder`": `"$folder`", `"drift`": [], `"stale`": [`"minimap-2`"]}"
                    }
                    'cog-flow' {
                        "{`"folder`": `"$folder`", `"error`": `"no diagram.drawio.yml`"}"
                    }
                    'gear-flow' {
                        "{`"folder`": `"$folder`", `"conflict`": [`"gear-train`", `"widget-a`"], `"drift`": [], `"stale`": []}"
                    }
                }
            }
            [pscustomobject]@{ ExitCode = 0; Output = $lines -join "`n" }
        }
    }

    It 'passes a folder whose png is what put of its yml writes' {
        $report = Test-Diagrams -Path 'docs/explanation/widget/.assets/widget-flow' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.IssueCount | Should -Be 0
        $report.Facts['FolderCount'] | Should -Be 1
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
        $report.Facts['StaleFolders'] | Should -Be @('docs/explanation/widget/.assets/sprocket-flow')
    }

    It 'fails a folder the kit cannot read, with the kit''s error' {
        $report = Test-Diagrams -Path 'docs/explanation/widget/.assets/cog-flow' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.Issues[0] | Should -BeLike '*cog-flow: no diagram.drawio.yml'
    }

    It 'checks every declared folder when no path is given' {
        $report = Test-Diagrams -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.Facts['FolderCount'] | Should -Be 6
        $report.IssueCount | Should -Be 3
    }

    It 'checks an untracked folder once its first put has run, and passes it' {
        $report = Test-Diagrams -Path 'docs/explanation/widget/.assets/new-flow' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.IssueCount | Should -Be 0
        $report.Facts['FolderCount'] | Should -Be 1
    }

    It 'refuses a path that is not a declared diagram folder' {
        { Test-Diagrams -Path 'docs/explanation/widget' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out } | Should -Throw '*is not a declared diagram folder*'
    }
}
