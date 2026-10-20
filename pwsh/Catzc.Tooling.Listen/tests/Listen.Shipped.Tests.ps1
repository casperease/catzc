Describe 'Catzc.Tooling.Listen over the shipped configs' -Tag 'L1', 'integrity' {
    It 'loads the shipped listen.yml as its typed model' {
        Get-Config -Config listen | Should -BeOfType ([Catzc.Tooling.Listen.ListenConfig])
    }

    It 'names only file kinds that file-kinds.yml declares in its tiers' {
        $declared = @((Get-Config -Config file-kinds).kinds.role)
        foreach ($tier in (Get-Config -Config listen).tiers) {
            foreach ($kind in $tier.kinds) {
                $kind | Should -BeIn $declared -Because "tier '$($tier.name)' lists it"
            }
        }
    }

    It 'watches a folder that exists' {
        [System.IO.Directory]::Exists((Join-Path (Get-RepositoryRoot) (Get-Config -Config listen).watch)) | Should -BeTrue
    }
}
