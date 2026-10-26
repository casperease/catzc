<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-languages/tests/types/BclConfig.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'BclConfig' -Tag 'L0' {

    Context 'integrity (shipped bcl.yml and the tracked solutions and projects)' -Tag 'integrity' {
        BeforeAll {
            $script:config = Get-Config -Config bcl
            $script:root = Get-RepositoryRoot
            $script:tracked = @(Get-GitTrackedPath '.' | Where-Object { $_ -match '\.csproj$' -and $_ -notmatch '(^|/)\.vendor/' })
            $script:solutions = @{ 'catzc.sln' = New-Solution }
        }

        It 'loads the shipped bcl.yml as a BclConfig with the Debug on Any CPU pair' {
            $script:config | Should -BeOfType [Catzc.Base.Languages.BclConfig]
            $script:config.SolutionPair() | Should -BeExactly 'Debug|Any CPU'
        }

        It 'binds only type sources that exist, each to the pwsh host' {
            $modules = Get-CatzcModulesRoot
            foreach ($binding in $script:config.host_bindings) {
                Join-Path $modules $binding.file | Should -Exist
                $binding.host | Should -BeExactly 'pwsh'
            }
        }

        It 'finds the tracked solutions and projects' {
            $script:solutions['catzc.sln'] | Should -Match 'Microsoft Visual Studio Solution File'
            @($script:tracked | Where-Object { $_ -like '*.csproj' }).Count | Should -BeGreaterThan 0
        }

        It 'declares only the configured pair in every solution (ADR-BCL-TYPES-DEBUGANYCPU)' {
            $pair = [regex]::Escape($script:config.SolutionPair())
            $offenders = foreach ($path in $script:solutions.Keys) {
                $text = $script:solutions[$path]
                $section = [regex]::Match($text,
                    '(?s)GlobalSection\(SolutionConfigurationPlatforms\)[^\n]*\n(.*?)EndGlobalSection').Groups[1].Value
                foreach ($line in ($section -split '\r?\n').Where({ $_.Trim() })) {
                    if ($line.Trim() -notmatch "^$pair = $pair$") {
                        "${path}: $($line.Trim())"
                    }
                }
                $projects = [regex]::Match($text,
                    '(?s)GlobalSection\(ProjectConfigurationPlatforms\)[^\n]*\n(.*?)EndGlobalSection').Groups[1].Value
                foreach ($line in ($projects -split '\r?\n').Where({ $_.Trim() })) {
                    if ($line.Trim() -notmatch "^\{[0-9A-F-]+\}\.$pair\.(ActiveCfg|Build\.0) = $pair$") {
                        "${path}: $($line.Trim())"
                    }
                }
            }
            $offenders | Should -BeNullOrEmpty
        }

        It 'declares only the configured pair in every project (ADR-BCL-TYPES-DEBUGANYCPU)' {
            $offenders = foreach ($path in $script:tracked.Where({ $_ -like '*.csproj' })) {
                $xml = [xml][System.IO.File]::ReadAllText((Join-Path $script:root $path))
                $configurations = @($xml.SelectNodes('//Configurations') | ForEach-Object InnerText)
                $platforms = @($xml.SelectNodes('//Platforms') | ForEach-Object InnerText)
                if (($configurations -join ';') -cne $script:config.configuration -or
                    ($platforms -join ';') -cne $script:config.ProjectPlatform()) {
                    "${path}: Configurations '$($configurations -join ';')', Platforms '$($platforms -join ';')'"
                }
            }
            $offenders | Should -BeNullOrEmpty
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'takes the declared defaults for an empty or absent file' {
            foreach ($raw in [ordered]@{}, $null) {
                $config = [Catzc.Base.Languages.BclConfig]::new($raw)
                $config.configuration | Should -BeExactly ([Catzc.Base.Languages.BclConfig]::DefaultConfiguration)
                $config.platform | Should -BeExactly ([Catzc.Base.Languages.BclConfig]::DefaultPlatform)
            }
            [Catzc.Base.Languages.BclConfig]::DefaultConfiguration | Should -BeExactly 'Debug'
            [Catzc.Base.Languages.BclConfig]::DefaultPlatform | Should -BeExactly 'Any CPU'
        }

        It 'treats a key set to null like an omitted key' {
            $config = [Catzc.Base.Languages.BclConfig]::new([ordered]@{ configuration = $null; platform = $null })
            $config.SolutionPair() | Should -BeExactly 'Debug|Any CPU'
        }

        It 'maps every key and spells the platform the way a project does' {
            $config = [Catzc.Base.Languages.BclConfig]::new([ordered]@{ configuration = 'Widget'; platform = 'Gadget CPU' })
            $config.SolutionPair() | Should -BeExactly 'Widget|Gadget CPU'
            $config.ProjectPlatform() | Should -BeExactly 'GadgetCPU'
        }

        It 'rejects an unknown key and an invalid name, naming each' {
            { [Catzc.Base.Languages.BclConfig]::new([ordered]@{ widget = 'x'; configuration = 'Debug|x64'; platform = 7 }) } |
                Should -Throw -ExpectedMessage "*unknown key 'widget'*invalid configuration 'Debug|x64'*invalid platform '7'*"
        }

        It 'has no host bindings by default' {
            [Catzc.Base.Languages.BclConfig]::new([ordered]@{}).host_bindings.Count | Should -Be 0
        }

        It 'maps the host bindings in ordinal file order and finds one by file' {
            $config = [Catzc.Base.Languages.BclConfig]::new([ordered]@{
                    host_bindings = @(
                        [ordered]@{ file = 'Base.Widgets/types/Widget.cs'; host = 'pwsh'; reason = 'Parses scripts.' }
                        [ordered]@{ file = 'Catzc.Base.Gadgets/types/Gadget.cs'; host = 'pwsh'; reason = ' Wraps a pipeline. ' }
                    )
                })
            @($config.host_bindings.file) | Should -Be @('Catzc.Base.Gadgets/types/Gadget.cs',
                'Base.Widgets/types/Widget.cs')
            $config.host_bindings[0].reason | Should -BeExactly 'Wraps a pipeline.'
            $config.HostBindingOf('Base.Widgets/types/Widget.cs').host | Should -BeExactly 'pwsh'
            $config.HostBindingOf('Base.Widgets/types/Other.cs') | Should -BeNullOrEmpty
        }

        It 'rejects a host binding without its reason, a bad file or host, and a file bound twice, naming each row' {
            $raw = [ordered]@{
                host_bindings = @(
                    [ordered]@{ file = 'Base.Widgets/types/Widget.cs'; host = 'pwsh' }
                    [ordered]@{ file = 'widget.cs'; host = 'Pwsh!'; reason = 'x' }
                    [ordered]@{ file = 'Catzc.Base.Gadgets/types/Gadget.cs'; host = 'pwsh'; reason = 'x' }
                    [ordered]@{ file = 'Catzc.Base.Gadgets/types/Gadget.cs'; host = 'pwsh'; reason = 'y' }
                )
            }
            { [Catzc.Base.Languages.BclConfig]::new($raw) } | Should -Throw -ExpectedMessage (
                "*host_bindings``[0``]: a host binding needs its reason*host_bindings``[1``]: invalid file 'widget.cs'*" +
                "host_bindings``[1``]: invalid host 'Pwsh!'*host_bindings``[3``]: 'Catzc.Base.Gadgets/types/Gadget.cs' is bound twice*")
        }

        It 'rejects host_bindings that is not a list' {
            { [Catzc.Base.Languages.BclConfig]::new([ordered]@{ host_bindings = 'widget' }) } |
                Should -Throw -ExpectedMessage '*invalid host_bindings*'
        }
    }
}
