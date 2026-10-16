<#
---
catzc:
  derived:
    path: automation/Catzc.Base.VSCode/tests/New-VSCodeLaunch.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.VSCode
    relatives:
      page: docs/references/automation/catzc-base-vscode/tests/New-VSCodeLaunch.Tests.ps1.md
      source: automation/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
    adrs:
      - ADR-PWSH-PESTER#2
---
#>

Describe 'New-VSCodeLaunch' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-Config -ModuleName Catzc.Base.VSCode {
            [Catzc.Base.VSCode.VscodeLaunchConfig]::new([ordered]@{
                    version        = '0.2.0'
                    configurations = @(
                        [ordered]@{ name = 'Fixture'; type = 'PowerShell'; request = 'launch'; script = 'x.ps1' }
                    )
                })
        }
    }

    It 'renders valid JSON carrying version and configurations, with no head of its own' {
        $text = New-VSCodeLaunch
        $text | Should -Not -Match 'GENERATED'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.version | Should -Be '0.2.0'
        $json.configurations[0].name | Should -Be 'Fixture'
        $json.configurations[0].script | Should -Be 'x.ps1'
    }
}

Describe 'New-VSCodeLaunch — real vscode-launch.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry with the importer debug profile intact' {
        # Get-Config constructs the VscodeLaunchConfig type on load, so a render is also the shape proof.
        $text = New-VSCodeLaunch
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.configurations).Count | Should -BeGreaterThan 0
        # The workspace-variable placeholder must survive the yml -> JSON round trip verbatim.
        $json.configurations[0].script | Should -Match '^\$\{workspaceFolder\}'
    }
}
