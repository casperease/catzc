Describe 'Get-GeneratedTarget — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:targets = @(Get-GeneratedTarget)
    }

    It 'returns every opted-in root config by its generator, Build-RootConfig for one copied from its source' {
        foreach ($file in (Get-Config -Config rootconfig).files.Where({ $_.optIn })) {
            $generator = $file.generator ? $file.generator : 'Build-RootConfig'
            $script:targets.Where({ $_.path -ceq $file.target -and $_.generator -ceq $generator }).Count | Should -Be 1 -Because "rootconfig.yml renders $($file.target)"
        }
    }

    It 'returns the READMEs readme.yml names, by Build-Readme' {
        $script:targets.Where({ $_.path -ceq 'pwsh/*/README.md' -and $_.generator -ceq 'Build-Readme' }).Count | Should -Be 1
    }

    It 'returns the comment pages comment-pages.yml roots, by Format-Code, a module placeholder as one wildcard folder' {
        foreach ($expected in 'docs/references/pwsh/*/**', 'docs/references/infrastructure/**', 'docs/references/ado/pipelines/**') {
            $script:targets.Where({ $_.path -ceq $expected -and $_.generator -ceq 'Format-Code' }).Count | Should -Be 1 -Because "comment-pages.yml declares the root of $expected"
        }
    }

    It 'returns every module''s declared generated targets' {
        foreach ($expected in 'docs/drs/index.md', 'docs/drs/glossary.md', 'out/**', 'pwsh/*/*.psd1', 'docs/**/.assets/*.drawio.png', '**/.ruff_cache/**', 'python/.venv/**') {
            $script:targets.path | Should -Contain $expected
        }
    }

    It 'names a generator for every target' {
        $script:targets.Where({ [string]::IsNullOrWhiteSpace($_.generator) }) | Should -BeNullOrEmpty
    }
}
