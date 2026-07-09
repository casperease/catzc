Describe 'New-VSCodeLaunch' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate through the config seam (ADR-AUTO-PESTER:2): a small fixture registry.
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [ordered]@{
                version        = '0.2.0'
                configurations = @(
                    [ordered]@{ name = 'Fixture'; type = 'PowerShell'; request = 'launch'; script = 'x.ps1' }
                )
            }
        }
    }

    It 'renders a JSONC header and valid JSON carrying version and configurations' {
        $text = New-VSCodeLaunch
        $text | Should -Match '^// GENERATED FILE'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.version | Should -Be '0.2.0'
        $json.configurations[0].name | Should -Be 'Fixture'
        $json.configurations[0].script | Should -Be 'x.ps1'
    }
}

Describe 'New-VSCodeLaunch — real vscode-launch.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry with the importer debug profile intact' {
        # Get-Config dispatches Assert-VscodeLaunchConfig on load, so a render is also the shape proof.
        $text = New-VSCodeLaunch
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.configurations).Count | Should -BeGreaterThan 0
        # The workspace-variable placeholder must survive the yml -> JSON round trip verbatim.
        $json.configurations[0].script | Should -Match '^\$\{workspaceFolder\}'
    }
}
