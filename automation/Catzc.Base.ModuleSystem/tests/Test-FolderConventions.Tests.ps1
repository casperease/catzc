<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/tests/Test-FolderConventions.Tests.ps1.md
      source: automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Test-FolderConventions' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FixtureFile {
            param([string] $Path)
            $full = Join-Path $TestDrive "repo/automation/$Path"
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($full))
            [System.IO.File]::WriteAllText($full, '')
        }
    }

    BeforeEach {
        Remove-Item (Join-Path $TestDrive 'repo') -Recurse -Force -ErrorAction Ignore
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.ModuleSystem { Join-Path $TestDrive 'repo' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        New-FixtureFile 'Widget/Get-Widget.ps1'
        New-FixtureFile 'Widget/tests/Get-Widget.Tests.ps1'
        New-FixtureFile 'Widget/configs/widget-settings.yml'
        New-FixtureFile 'Gadget/private/Get-GadgetPart.ps1'
        New-FixtureFile '.internal/Tooling.psm1'
        $script:out = Join-Path $TestDrive 'out'
    }

    It 'passes a conventional tree and counts its modules (dot folders are not modules)' {
        $result = Test-FolderConventions -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Modules | Should -Be 2
    }

    It 'throws once listing every convention break' {
        New-FixtureFile 'Widget/scripts/run.ps1'
        New-FixtureFile 'Widget/Get-Widget.Tests.ps1'
        New-FixtureFile 'Gadget/private/Get-GadgetPart.Tests.ps1'
        New-FixtureFile 'Gadget/Get-Widget.ps1'
        New-FixtureFile 'Gadget/configs/Gadget.yaml'
        New-FixtureFile 'Gadget/configs/nested/gadget.yml'
        New-FixtureFile 'Gadget/assets/config/gadget.yml'
        New-FixtureFile 'Gadget/assets/test/fixture.txt'

        $thrown = { Test-FolderConventions -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-FolderConventions failed: 8 issue(s)*'
        $message | Should -Match 'Widget/scripts: not a conventional module folder'
        $message | Should -Match 'Widget/Get-Widget.Tests.ps1: a test file at the module root'
        $message | Should -Match 'Gadget/private/Get-GadgetPart.Tests.ps1: a test file in private/'
        $message | Should -Match 'Get-Widget: exported by more than one module \(Gadget, Widget\)'
        $message | Should -Match 'Gadget/configs/Gadget.yaml: not a kebab-case .yml file'
        $message | Should -Match 'Gadget/configs/nested: not a file'
        $message | Should -Match 'Gadget/assets/config: internal config belongs in configs/'
        $message | Should -Match 'Gadget/assets/test: test fixtures belong in tests/assets/'
    }

    It 'skips dot-prefixed configs/ entries' {
        New-FixtureFile 'Widget/configs/.schema.json'
        (Test-FolderConventions -OutputFolder $out -PassThru).IssueCount | Should -Be 0
    }

    It 'returns the issues under -PassThru instead of throwing' {
        New-FixtureFile 'Widget/scripts/run.ps1'
        $result = Test-FolderConventions -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'folder-conventions'
        $result.Issues | Should -HaveCount 1
    }
}
