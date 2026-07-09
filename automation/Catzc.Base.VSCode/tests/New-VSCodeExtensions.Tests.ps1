Describe 'New-VSCodeExtensions' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the config seam (ADR-AUTO-PESTER:2): a small fixture registry.
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [ordered]@{ recommendations = @('acme.tool-one', 'globex.tool-two') }
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
        # Get-Config dispatches Assert-VscodeExtensionsConfig on load, so a render is also the shape proof.
        $text = New-VSCodeExtensions
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.recommendations).Count | Should -BeGreaterThan 0
        @($json.recommendations) | Should -Contain 'ms-vscode.powershell'
    }
}
