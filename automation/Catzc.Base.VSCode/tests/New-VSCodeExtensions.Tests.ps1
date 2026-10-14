Describe 'New-VSCodeExtensions' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the config seam
        # ([ADR-AUTO-PESTER#2](/docs/adr/automation/powershell/pester-testing.md#rule-adr-auto-pester2)): a small
        # fixture registry.
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeExtensionsConfig]::new([ordered]@{ recommendations = @('acme.tool-one', 'globex.tool-two') })
        }
    }

    It 'renders a JSONC header and valid JSON carrying the recommendations in registry order' {
        $text = New-VSCodeExtensions
        $text | Should -Match '^// GENERATED FILE'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations) | Should -Be @('acme.tool-one', 'globex.tool-two')
    }
}

Describe 'New-VSCodeExtensions — real vscode-extensions.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry to a non-empty, validated recommendation list' {
        # Get-Config constructs the VscodeExtensionsConfig type on load, so a render is also the shape proof.
        $text = New-VSCodeExtensions
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations).Count | Should -BeGreaterThan 0
        @($json.recommendations) | Should -Contain 'ms-vscode.powershell'
        # The Go language server for the Go tests, under either Go root (go/ or .go/): it reads the repository-root go.work.
        @($json.recommendations) | Should -Contain 'golang.go'
    }
}
