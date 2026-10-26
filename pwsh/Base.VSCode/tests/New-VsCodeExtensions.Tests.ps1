<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/tests/New-VSCodeExtensions.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'New-VsCodeExtensions' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeExtensionsConfig]::new([ordered]@{ recommendations = @('acme.tool-one',
                        'globex.tool-two')
                })
        }
    }

    It 'renders valid JSON carrying the recommendations in registry order, with no head of its own' {
        $text = New-VsCodeExtensions
        $text | Should -Not -Match 'GENERATED'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations) | Should -Be @('acme.tool-one', 'globex.tool-two')
    }

    It 'appends the formatter engines'' extensions, sorted, after the authored ones, never twice' -Tag 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
        $text = New-VsCodeExtensions -EngineExtension 'globex.tool-two', 'globex.widget-formatter', 'contoso.gadget-formatter'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations) | Should -Be @('acme.tool-one', 'globex.tool-two', 'contoso.gadget-formatter',
            'globex.widget-formatter')
    }
}

Describe 'New-VsCodeExtensions — real vscode-extensions.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry, with the engines'' extensions from languages.yml, to a non-empty, validated recommendation list' {
        $engineExtension = @((Get-Config -Config languages).formatters.Values | Where-Object vscode_extension | ForEach-Object vscode_extension)
        $text = New-VsCodeExtensions -EngineExtension $engineExtension
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations).Count | Should -BeGreaterThan 0
        @($json.recommendations) | Should -Contain 'ms-vscode.powershell'
        @($json.recommendations) | Should -Contain 'golang.go'
    }
}
