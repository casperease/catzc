Describe 'Test-Comments' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:writeFile = {
            param([string] $Root, [string] $Relative, [string] $Text)
            $full = Join-Path $Root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Text)
        }
        $script:readFile = {
            param([string] $Root, [string] $Relative)
            [System.IO.File]::ReadAllText((Join-Path $Root $Relative))
        }
        $script:newRepository = {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            & $script:writeFile $root '.editorconfig' ((@('[*.{ps1,psm1,psd1}]', 'max_line_length = 120',
                        '') -join "`n"))
            & $script:writeFile $root "$(Get-CatzcModulesFolder)/Widget/Get-Widget.ps1" ((@(
                        'function Get-Widget {'
                        '    # Sorted first, so the gadget order is stable'
                        '    # across runs and the cache key never changes.'
                        '    Get-Gadget | Sort-Object'
                        '}'
                        ''
                    ) -join "`n"))
            $root
        }
        $script:file = "$(Get-CatzcModulesFolder)/Widget/Get-Widget.ps1"
        $script:pageRelative = 'docs/references/pwsh/catzc-widget/Get-Widget.ps1.md'
        $script:check = {
            param([string] $Root)
            Test-Comments -RepositoryRoot $Root -Path (Join-Path $Root (Get-CatzcModulesFolder)) -OutputFolder (Join-Path $Root 'out/report') -PassThru
        }
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.Reports
    }

    It 'reports a long comment still in the file, then passes once it is exported' -Tag 'ADR-REPO-COMMENTS-MOVEDBYTOOL' {
        $root = & $newRepository
        $before = & $check $root
        $before.IssueCount | Should -Be 1
        $before.Issues[0] | Should -BeLike "$($file):2: a 2-line comment is still in the file*Export-Comments"
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) | Out-Null
        $after = & $check $root
        $after.IssueCount | Should -Be 0
        $after.Facts['PageCount'] | Should -Be 1
    }

    It 'reports a section whose code line the file no longer has' -Tag 'ADR-REPO-COMMENTS-MOVEDBYTOOL' {
        $root = & $newRepository
        Export-Comments -RepositoryRoot $root -Path (Join-Path $root (Get-CatzcModulesFolder)) | Out-Null
        $text = & $readFile $root $file
        & $writeFile $root $file ($text.Replace('Sort-Object', 'Sort-Object -Unique'))
        $report = & $check $root
        $report.IssueCount | Should -Be 1
        ($report.Issues -join "`n") | Should -BeLike "*$pageRelative*section comment:1 names a code line*no longer has*"
    }
}
