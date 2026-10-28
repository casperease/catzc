Describe 'Get-GeneratedTarget — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:targets = @(Get-GeneratedTarget)
    }

    It 'returns every opted-in root config by its generator, Build-RootConfig for one copied from its source' {
        foreach ($file in (Get-Config -Config rootconfig).files.Where({ $_.optIn })) {
            $generator = $file.generator ? $file.generator : 'Build-RootConfig'
            $script:targets.Where({ $_.path -ceq $file.target -and $_.generator -ceq $generator }).Count |
                Should -Be 1 -Because "rootconfig.yml renders $($file.target)"
        }
    }

    It 'returns the READMEs readme.yml names, by Build-Readme' {
        $readmes = "$((Get-Track -Name pwsh).places[0])/*/README.md"
        $script:targets.Where({ $_.path -ceq $readmes -and $_.generator -ceq 'Build-Readme' }).Count |
            Should -Be 1
    }

    It 'returns no comment page, since a page is authored (ADR-REPO-COMMENTS-PAGEISAUTHORED)' {
        $roots = @(foreach ($page in (Get-Config -Config comment-pages).pages) {
                "$($page.docs)/**"
            })
        $script:targets.Where({ $_.path -cin $roots -or $_.generator -ceq 'Format-Code' }) | Should -BeNullOrEmpty
    }

    It 'returns every module''s declared generated targets' {
        foreach ($expected in 'docs/drs/index.md', 'docs/drs/glossary.md', 'out/**', "$((Get-Track -Name pwsh).places[0])/*/*.psd1",
            'docs/**/.assets/*.drawio.png', '**/.ruff_cache/**', 'python/.venv/**') {
            $script:targets.path | Should -Contain $expected
        }
    }

    It 'returns a writer row''s outputs only where no config of its own expands its instances' {
        foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
            foreach ($writer in (Get-Config -Config generated -Module $owner.Module).writers.Where({ $_.expands })) {
                foreach ($output in $writer.outputs) {
                    $script:targets.Where({ $_.path -ceq $output.path -and $_.generator -ceq $writer.name }) |
                        Should -BeNullOrEmpty -Because "$($writer.expands) expands $($writer.name)'s instances"
                }
            }
        }
    }

    It 'names a generator for every target' {
        $script:targets.Where({ [string]::IsNullOrWhiteSpace($_.generator) }) | Should -BeNullOrEmpty
    }
}
