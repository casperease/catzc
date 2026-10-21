<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/tests/New-VsCodeLaunch.Tests.ps1
    folder: tests
    name: new-vs-code-launch-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[New-VsCodeLaunch.Tests.ps1.md](docs/references/pwsh/catzc-base-vscode/tests/New-VsCodeLaunch.Tests.ps1.md)"
    cites:
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
---
#>

Describe 'New-VsCodeLaunch' -Tag 'L0', 'logic' {
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
        $text = New-VsCodeLaunch
        $text | Should -Not -Match 'GENERATED'
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        $json.version | Should -Be '0.2.0'
        $json.configurations[0].name | Should -Be 'Fixture'
        $json.configurations[0].script | Should -Be 'x.ps1'
    }
}

Describe 'New-VsCodeLaunch — real vscode-launch.yml' -Tag 'L1', 'integrity' {
    It 'renders the shipped registry with the importer debug profile intact' {
        # Get-Config constructs the VscodeLaunchConfig type on load, so a render is also the shape proof.
        $text = New-VsCodeLaunch
        $json = ($text -split "`n" | Where-Object { $_ -notmatch '^//' }) -join "`n" | ConvertFrom-Json
        @($json.configurations).Count | Should -BeGreaterThan 0
        # The workspace-variable placeholder must survive the yml -> JSON round trip verbatim.
        $json.configurations[0].script | Should -Match '^\$\{workspaceFolder\}'
    }
}
