<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-dev-ops/tests/Get-AdoYamlFiles.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Resolve-AdoYamlClassification' -Tag 'L0' {
    InModuleScope 'Catzc.Azure.DevOps' {
        Context 'null and non-dictionary input' -Tag 'logic' {
            It 'returns Unknown for $null' {
                $result = Resolve-AdoYamlClassification -Yaml $null
                $result.Classification | Should -Be 'Unknown'
                $result.TemplateType | Should -BeNullOrEmpty
            }

            It 'returns Unknown for a scalar' {
                $result = Resolve-AdoYamlClassification -Yaml 'just a string'
                $result.Classification | Should -Be 'Unknown'
            }

            It 'returns Unknown for an array' {
                $result = Resolve-AdoYamlClassification -Yaml @('item1', 'item2')
                $result.Classification | Should -Be 'Unknown'
            }
        }

        Context 'strong pipeline signals' -Tag 'logic' {
            It 'classifies trigger + jobs as Pipeline' {
                $yaml = [ordered]@{ trigger = @('main'); jobs = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Pipeline'
                $result.TemplateType | Should -BeNullOrEmpty
            }

            It 'classifies pr as Pipeline' {
                $yaml = [ordered]@{ pr = @('main'); stages = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Pipeline'
            }

            It 'classifies schedules as Pipeline' {
                $yaml = [ordered]@{ schedules = @(); stages = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Pipeline'
            }

            It 'classifies extends as Pipeline' {
                $yaml = [ordered]@{ extends = @{ template = 'base.yml' } }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Pipeline'
            }

            It 'classifies lockBehavior as Pipeline' {
                $yaml = [ordered]@{ lockBehavior = 'sequential'; stages = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Pipeline'
            }
        }

        Context 'template detection' -Tag 'logic' {
            It 'classifies parameters + steps as Steps template' {
                $yaml = [ordered]@{ parameters = @(); steps = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Template'
                $result.TemplateType | Should -Be 'Steps'
            }

            It 'classifies parameters + jobs as Jobs template' {
                $yaml = [ordered]@{ parameters = @(); jobs = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Template'
                $result.TemplateType | Should -Be 'Jobs'
            }

            It 'classifies parameters + stages as Stages template' {
                $yaml = [ordered]@{ parameters = @(); stages = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Template'
                $result.TemplateType | Should -Be 'Stages'
            }

            It 'classifies parameters + variables as Variables template' {
                $yaml = [ordered]@{ parameters = @(); variables = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Template'
                $result.TemplateType | Should -Be 'Variables'
            }
        }

        Context 'moderate pipeline signals' -Tag 'logic' {
            It 'classifies pool + jobs without parameters as Pipeline' {
                $yaml = [ordered]@{ pool = @{ vmImage = 'ubuntu-latest' }; jobs = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Pipeline'
            }

            It 'classifies name + resources + stages without parameters as Pipeline' {
                $yaml = [ordered]@{ name = '$(Rev:r)'; resources = @{}; stages = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Pipeline'
            }
        }

        Context 'single-key files' -Tag 'logic' {
            It 'classifies lone steps as Steps template' {
                $yaml = [ordered]@{ steps = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Template'
                $result.TemplateType | Should -Be 'Steps'
            }

            It 'classifies lone variables as Variables template' {
                $yaml = [ordered]@{ variables = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Template'
                $result.TemplateType | Should -Be 'Variables'
            }

            It 'classifies lone stages as Unknown' {
                $yaml = [ordered]@{ stages = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Unknown'
            }

            It 'classifies lone jobs as Unknown' {
                $yaml = [ordered]@{ jobs = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Unknown'
            }
        }

        Context 'fallback' -Tag 'logic' {
            It 'classifies arbitrary keys as Unknown' {
                $yaml = [ordered]@{ foo = 'bar'; baz = 42 }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Unknown'
            }

            It 'classifies config-like YAML as Unknown' {
                $yaml = [ordered]@{ Organization = 'https://dev.azure.com/org'; Project = 'proj' }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Unknown'
            }
        }

        Context 'strong pipeline wins over template indicators' -Tag 'logic' {
            It 'classifies trigger + parameters + steps as Pipeline' {
                $yaml = [ordered]@{ trigger = @('main'); parameters = @(); steps = @() }
                $result = Resolve-AdoYamlClassification -Yaml $yaml
                $result.Classification | Should -Be 'Pipeline'
            }
        }
    }
}

Describe 'Get-AdoYamlFiles' -Tag 'L0' {
    Context 'scanning real repo YAML' -Tag 'integrity' {
        BeforeAll {
            $repoRoot = $env:RepositoryRoot
            $script:results = Get-AdoYamlFiles -Path $repoRoot
        }

        It 'returns results' {
            $results | Should -Not -BeNullOrEmpty
        }

        It 'returns objects with expected properties' {
            $first = $results | Select-Object -First 1
            $first.PSObject.Properties.Name | Should -Contain 'Path'
            $first.PSObject.Properties.Name | Should -Contain 'RelativePath'
            $first.PSObject.Properties.Name | Should -Contain 'Root'
            $first.PSObject.Properties.Name | Should -Contain 'RelativeDirectory'
            $first.PSObject.Properties.Name | Should -Contain 'Classification'
            $first.PSObject.Properties.Name | Should -Contain 'TemplateType'
            $first.PSObject.Properties.Name | Should -Contain 'TopLevelKeys'
            $first.PSObject.Properties.Name | Should -Contain 'ParseError'
        }

        It 'uses forward slashes in RelativePath' {
            $violations = @(foreach ($result in $results) {
                    if ($result.RelativePath -match '\\') {
                        $result.RelativePath
                    }
                })
            $violations | Should -BeNullOrEmpty
        }

        It 'classifies pipeline files as Pipeline' {
            $pipeline = $results | Where-Object { $_.RelativePath -like '*/ci-pwsh.yaml' } | Select-Object -First 1
            if ($pipeline) {
                $pipeline.Classification | Should -Be 'Pipeline'
            }
        }

        It 'classifies template files as Template' {
            $template = $results | Where-Object { $_.RelativePath -like '*/steps/*.yaml' } | Select-Object -First 1
            if ($template) {
                $template.Classification | Should -Be 'Template'
            }
        }

        It 'has no parse errors for valid YAML files' {
            $errors = $results | Where-Object { $_.ParseError }
            $errors | Should -BeNullOrEmpty
        }

        It 'excludes .git directory by default' -Tag 'integrity' {
            $gitFiles = @($results | Where-Object { $_.RelativePath -match '^\\.git/' -or $_.RelativePath -match '^\.git/' })
            $gitFiles | Should -BeNullOrEmpty
        }
    }

    Context 'a widget tree' -Tag 'logic' {
        BeforeAll {
            $script:widgetRoot = Join-Path $TestDrive 'widget-pipelines'
            $deep = Join-Path $script:widgetRoot 'a/b/c/d/e'
            [System.IO.Directory]::CreateDirectory($deep) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $deep 'gadget.yaml'), "trigger: none`njobs: []`n")
            $cache = Join-Path $script:widgetRoot '.terraform'
            [System.IO.Directory]::CreateDirectory($cache) | Out-Null
            [System.IO.File]::WriteAllText((Join-Path $cache 'provider.yml'), "widget: 1`n")
            Mock Write-Message -ModuleName Catzc.Azure.DevOps { }
        }

        It 'finds a YAML file five folders below the root at the default depth' {
            @(Get-AdoYamlFiles -Path $script:widgetRoot).RelativePath | Should -Contain 'a/b/c/d/e/gadget.yaml'
        }

        It 'stops at a -Depth that overrides the default' {
            @(Get-AdoYamlFiles -Path $script:widgetRoot -Depth 3 | ForEach-Object RelativePath) | Should -Not -Contain 'a/b/c/d/e/gadget.yaml'
        }

        It 'never searches a .terraform provider cache' {
            @(Get-AdoYamlFiles -Path $script:widgetRoot).RelativePath | Should -Not -Contain '.terraform/provider.yml'
        }
    }
}
