<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Shipped.Tests.ps1
    folder: tests
    name: get-inspiration-shipped-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Inspiration
    moduletype: pwsh-folder
    catzc_bundle: full
  edges:
    docs: "[Get-Inspiration.Shipped.Tests.ps1.md](docs/references/pwsh/catzc-tooling-inspiration/tests/Get-Inspiration.Shipped.Tests.ps1.md)"
    cites:
      - ADR-REPO-INSPIRE-SIBLINGFORIDEAS
---
#>

Describe 'Get-Inspiration over the shipped inspiration.yml' -Tag 'L1', 'integrity' {
    It 'loads the shipped config as its typed model' {
        Get-Config -Config inspiration | Should -BeOfType ([Catzc.Tooling.Inspiration.InspirationConfig])
    }

    It 'resolves eac in the workspace, and reports it available exactly when its root exists here' {
        $eac = Get-Inspiration -Id 'eac'
        $workspace = Split-Path ([IO.Path]::GetFullPath((Get-RepositoryRoot))) -Parent
        $eac.Root | Should -BeExactly ([IO.Path]::GetFullPath((Join-Path $workspace 'eac')))
        $eac.Available | Should -Be ([IO.Directory]::Exists($eac.Root))
    }

    It 'lists eac with no arguments exactly when it is available' {
        $eac = Get-Inspiration -Id 'eac'
        $listed = @(foreach ($inspiration in @(Get-Inspiration)) {
                $inspiration.Id
            })
        ('eac' -in $listed) | Should -Be $eac.Available
    }
}
