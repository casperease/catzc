Describe 'Build-FrontPage' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.Docs.FrontPageConfig]::new(@{
                target   = 'widgets/README.md'
                title    = 'widgets — the gadget shelf'
                tagline  = 'Every widget rests on one shelf.'
                badges   = @(
                    @{ label = 'shelf'; message = 'one'; color = '3b82f6'; to = 'rest' }
                    @{ label = 'CI'; image = 'https://example.test/ci.svg'; to = 'https://example.test/ci' }
                )
                sections = @(
                    @{ id = 'rest'; kind = 'contents'; title = 'Widget rest' }
                )
                closing  = 'One shelf.'
            })
        $sections = @([pscustomobject]@{ Id = 'rest'; Title = 'Widget rest'; Anchor = 'widget-rest'; Markdown = "## Widget rest`n`nA widget rests." })
        Mock Get-FrontPageSection -ModuleName Catzc.Base.Docs -MockWith { $sections }.GetNewClosure()
        Mock Write-Message -ModuleName Catzc.Base.Docs { }
        Import-InternalModule TestKit
        Set-GitTrackedPathMock
        $script:page = Join-Path $TestDrive 'README.md'
    }

    It 'composes the title, the badges, every section and the closing line under a generated head' {
        Build-FrontPage -Config $script:config -Path $script:page -Silent | Out-Null
        $text = [System.IO.File]::ReadAllText($script:page)
        $text | Should -Match '(?m)^# widgets — the gadget shelf$'
        $text | Should -Match '\[!\[shelf\]\[badge-1\]\]\(#widget-rest\)'
        $text | Should -Match '\[!\[CI\]\[badge-2\]\]\(https://example.test/ci\)'
        $text | Should -Match '(?m)^\[badge-1\]: https://img.shields.io/badge/shelf-one-3b82f6'
        $text | Should -Match '(?m)^## Widget rest$'
        $text | Should -Match '(?m)^\*\*One shelf\.\*\*$'
        $text | Should -Match 'Do Not Edit'
    }

    It 'refuses a link that names a decision record by its code' {
        Mock Get-FrontPageSection -ModuleName Catzc.Base.Docs -MockWith {
            [pscustomobject]@{ Id = 'rest'; Title = 'Widget rest'; Anchor = 'widget-rest'; Markdown = "## Widget rest`n`nSee [ADR-WIDGET-REST](../docs/widget.md)." }
        }
        { Build-FrontPage -Config $script:config -Path (Join-Path $TestDrive 'coded.md') -Silent } | Should -Throw '*ADR-WIDGET-REST*'
    }

    It 'reports no change on a second run' {
        Build-FrontPage -Config $script:config -Path $script:page -Silent | Out-Null
        (Build-FrontPage -Config $script:config -Path $script:page -Silent -PassThru).Changed | Should -BeFalse
    }
}

Describe 'FrontPageConfig' -Tag 'L0', 'logic' {
    It 'rejects a badge that leads to no section' {
        { [Catzc.Base.Docs.FrontPageConfig]::new(@{
                    target = 'w/README.md'; title = 't'; tagline = 't'; closing = 'c'
                    badges = @(@{ label = 'x'; message = 'y'; color = '000000'; to = 'gadget' })
                    sections = @(@{ id = 'rest'; kind = 'contents'; title = 'Rest' })
                }) } | Should -Throw '*neither a URL nor a section id*'
    }

    It 'rejects a fragment that names a title' {
        { [Catzc.Base.Docs.FrontPageConfig]::new(@{
                    target = 'w/README.md'; title = 't'; tagline = 't'; closing = 'c'
                    sections = @(@{ id = 'rest'; kind = 'fragment'; source = 'w/rest.md'; title = 'Rest' })
                }) } | Should -Throw '*never ''title''*'
    }
}
