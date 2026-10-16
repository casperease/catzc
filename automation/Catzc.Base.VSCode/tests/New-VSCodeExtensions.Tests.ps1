<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/tests/New-VSCodeExtensions.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.VSCode
    relatives:
      page: docs/references/automation/catzc-base-vscode/tests/New-VSCodeExtensions.Tests.ps1.md
      source: automation/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
    adrs:
      - ADR-PWSH-PESTER#2
      - ADR-REPO-FORMAT#8
---
#>

Describe 'New-VSCodeExtensions' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeExtensionsConfig]::new([ordered]@{ recommendations = @('acme.tool-one', 'globex.tool-two') })
        }
    }

    It 'renders valid JSON carrying the recommendations in registry order, with no head of its own' {
        $text = New-VSCodeExtensions
        $text | Should -Not -Match 'GENERATED'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations) | Should -Be @('acme.tool-one', 'globex.tool-two')
    }

    It 'appends the formatter engines'' extensions, sorted, after the authored ones, never twice' -Tag 'ADR-REPO-FORMAT#8' {
        $text = New-VSCodeExtensions -EngineExtension 'globex.tool-two', 'globex.widget-formatter', 'contoso.gadget-formatter'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations) | Should -Be @('acme.tool-one', 'globex.tool-two', 'contoso.gadget-formatter', 'globex.widget-formatter')
    }
}

Describe 'New-VSCodeExtensions — real vscode-extensions.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry, with the engines'' extensions from languages.yml, to a non-empty, validated recommendation list' {
        $engineExtension = @((Get-Config -Config languages).engines.Values | Where-Object vscode_extension | ForEach-Object vscode_extension)
        $text = New-VSCodeExtensions -EngineExtension $engineExtension
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations).Count | Should -BeGreaterThan 0
        @($json.recommendations) | Should -Contain 'ms-vscode.powershell'
        # The Go language server for the Go tests, under either Go root (go/ or .go/): it reads the repository-root go.work.
        @($json.recommendations) | Should -Contain 'golang.go'
    }
}
