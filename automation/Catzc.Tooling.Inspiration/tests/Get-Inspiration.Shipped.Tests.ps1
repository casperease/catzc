# The shipped inspiration.yml through the real Get-Config and the real repository root. It asserts consistency, never
# presence: on a machine without eac the default inspiration is reported unavailable, and the test still passes
# ([ADR-REPO-INSPIRE#1](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire1)).
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
