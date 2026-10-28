Describe 'Get-GeneratedTarget' -Tag 'L0', 'logic', 'ADR-REPO-ROOTCFG-ONECLASSPERWRITER' {
    BeforeEach {
        $script:writers = [ordered]@{
            'Build-Widget'     = [ordered]@{ class = 'rollable'; outputs = @('widget/*.md') }
            'Build-RootConfig' = [ordered]@{ class = 'import-critical'; expands = 'rootconfig'; outputs = @('*') }
            'New-Gadget'       = [ordered]@{ class = 'snapshot'; check = 'none'; expands = 'rootconfig'; outputs = @('gadget.yml') }
            'Build-Sprocket'   = [ordered]@{ class = 'untracked'; expands = 'readme'; outputs = @('*/README.md') }
            'Export-Pages'     = [ordered]@{ class = 'snapshot'; expands = 'comment-pages'; outputs = @('docs/pages/**') }
        }
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'generated' -and $ListOwners } {
            [pscustomobject]@{ Module = 'Catzc.Base.Widget' }
        }
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'generated' -and -not $ListOwners } {
            [Catzc.Base.Variants.GeneratedConfig]::new([ordered]@{ writers = $script:writers })
        }
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'rootconfig' } {
            [pscustomobject]@{ files = @(
                    [pscustomobject]@{ target = 'widget.psd1'; generator = $null; optIn = $true }
                    [pscustomobject]@{ target = 'gadget.yml'; generator = 'New-Gadget'; optIn = $true }
                    [pscustomobject]@{ target = 'trinket.json'; generator = 'New-Trinket'; optIn = $true }
                    [pscustomobject]@{ target = 'spare.txt'; generator = $null; optIn = $false }
                )
            }
        }
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'readme' } {
            [pscustomobject]@{ patterns = @([pscustomobject]@{ glob = 'widget/*' }); mappings = @([pscustomobject]@{ folder = 'gadget' }) }
        }
    }

    It 'answers a row''s outputs in its class, and an expanding config''s instances once in place of the outputs of every row that points at it' {
        $rows = @(Get-GeneratedTarget | ForEach-Object { "$($_.path)|$($_.generator)|$($_.class)" })
        $rows | Should -Be @(
            'widget/*.md|Build-Widget|rollable'
            'widget.psd1|Build-RootConfig|import-critical'
            'gadget.yml|New-Gadget|snapshot'
            'trinket.json|New-Trinket|import-critical'
            'widget/*/README.md|Build-Sprocket|untracked'
            'gadget/README.md|Build-Sprocket|untracked'
        ) -Because 'a generator with a row of its own keeps that class; one without takes the class of the row that expands its config'
    }

    It 'answers no target for the comment pages, since a page is authored (ADR-REPO-COMMENTS-PAGEISAUTHORED)' {
        @(Get-GeneratedTarget | Where-Object generator -CEQ 'Export-Pages') | Should -BeNullOrEmpty
    }

    It 'throws naming the writer whose expanding config it does not know' {
        $script:writers['Build-Gizmo'] = [ordered]@{ class = 'rollable'; expands = 'gizmos'; outputs = @('gizmo/**') }
        { Get-GeneratedTarget } | Should -Throw "*writer 'Build-Gizmo' expands 'gizmos'*"
    }
}

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

    It 'answers .gitattributes once, in the class of New-GitAttributes'' own row' {
        $answers = @($script:targets.Where({ $_.path -ceq '.gitattributes' }))
        $answers.Count | Should -Be 1
        $answers[0].generator | Should -BeExactly 'New-GitAttributes'
        $answers[0].class | Should -BeExactly 'import-critical'
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

    It 'returns a writer row''s outputs only where no config of its own expands its instances, or that config names the path itself' {
        $rootTargets = @((Get-Config -Config rootconfig).files.Where({ $_.optIn }) | ForEach-Object target)
        foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
            foreach ($writer in (Get-Config -Config generated -Module $owner.Module).writers.Where({ $_.expands })) {
                foreach ($output in $writer.outputs) {
                    if ($writer.expands -ceq 'rootconfig' -and $output.path -cin $rootTargets) {
                        continue
                    }
                    $script:targets.Where({ $_.path -ceq $output.path -and $_.generator -ceq $writer.name }) |
                        Should -BeNullOrEmpty -Because "$($writer.expands) expands $($writer.name)'s instances"
                }
            }
        }
    }

    It 'names a generator and a writer class for every target' {
        $script:targets.Where({ [string]::IsNullOrWhiteSpace($_.generator) }) | Should -BeNullOrEmpty
        $script:targets.Where({ $_.class -cnotin [Catzc.Base.Variants.GeneratedWriterRow]::Classes }) | Should -BeNullOrEmpty
    }
}
