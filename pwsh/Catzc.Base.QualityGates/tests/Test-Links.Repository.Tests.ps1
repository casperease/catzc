<#
---
catzc:
  immutable:
    with_body_sha: "0181376d3a54"
  edges:
    docs: "[Test-Links.Repository.Tests.ps1.md](docs/references/pwsh/catzc-base-quality-gates/tests/Test-Links.Repository.Tests.ps1.md)"
    cites:
      - ADR-REPO-LINK
---
#>

Describe 'Repository code links (automation comments)' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:result = Test-Links -Path (Get-CatzcModulesRoot) -Kind Code -PassThru `
            -OutputFolder (Join-Path $TestDrive 'links-code')
    }

    It 'every ADR reference in an automation comment is a canonical code link that resolves' -Tag 'ADR-REPO-LINK-CODELINKS', 'ADR-REPO-LINK-ONECITATIONSPELLING' {
        $result.Facts['FileCount'] | Should -BeGreaterThan 0
        $result.Issues | Should -BeNullOrEmpty -Because 'Format-Links aligns code links; the rest need a person'
        $result.IssueCount | Should -Be 0
    }

    It 'every docs path in an automation string names a file that exists' -Tag 'ADR-REPO-LINK-STRINGSAREDATA' {
        @($result.Issues | Where-Object { $_ -match '\[StringPathMissing\]' }) | Should -BeNullOrEmpty
    }
}

Describe 'Repository links (every tracked file)' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:result = Test-Links -PassThru -OutputFolder (Join-Path $TestDrive 'links')
    }

    It 'every markdown link and code link in a tracked file is aligned and resolves, fragments included' -Tag 'ADR-REPO-LINK-MARKDOWNRELATIVE', 'ADR-REPO-LINK-OFFREPOSITORYURLS' {
        $result.Facts['FileCount'] | Should -BeGreaterThan 0
        $result.Issues | Should -BeNullOrEmpty -Because 'run Format-Links, then fix what remains by hand'
        $result.IssueCount | Should -Be 0
    }

    It 'Format-Links changes nothing on the aligned repository' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
        @(Format-Links -DryRun) | Should -BeNullOrEmpty -Because 'the committed tree is formatter-stable'
    }

    It 'the VS Code registries make code links clickable' -Tag 'ADR-REPO-LINK-CODELINKS' {
        (Get-Config -Config vscode-extensions).recommendations | Should -Contain 'DanLevett.regex-robin'
        $rules = @((Get-Config -Config vscode-settings).settings['regexrobin.rules'])
        @($rules | Where-Object { $_.regex -like '*docs/adr/*' }).Count | Should -Be 1
    }
}
