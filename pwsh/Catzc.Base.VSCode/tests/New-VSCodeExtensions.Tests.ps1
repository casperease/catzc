<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/tests/New-VSCodeExtensions.Tests.ps1
    folder: tests
    name: new-vs-code-extensions-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[New-VSCodeExtensions.Tests.ps1.md](/docs/references/pwsh/catzc-base-vscode/tests/New-VSCodeExtensions.Tests.ps1.md)"
    cites:
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
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

    It 'appends the formatter engines'' extensions, sorted, after the authored ones, never twice' -Tag 'ADR-REPO-FORMAT-CONFIGUREDFORMATTERS' {
        $text = New-VSCodeExtensions -EngineExtension 'globex.tool-two', 'globex.widget-formatter', 'contoso.gadget-formatter'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations) | Should -Be @('acme.tool-one', 'globex.tool-two', 'contoso.gadget-formatter', 'globex.widget-formatter')
    }
}

Describe 'New-VSCodeExtensions — real vscode-extensions.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry, with the engines'' extensions from languages.yml, to a non-empty, validated recommendation list' {
        $engineExtension = @((Get-Config -Config languages).formatters.Values | Where-Object vscode_extension | ForEach-Object vscode_extension)
        $text = New-VSCodeExtensions -EngineExtension $engineExtension
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations).Count | Should -BeGreaterThan 0
        @($json.recommendations) | Should -Contain 'ms-vscode.powershell'
        # The Go language server for the Go tests, under either Go root (go/ or .go/): it reads the repository-root go.work.
        @($json.recommendations) | Should -Contain 'golang.go'
    }
}
