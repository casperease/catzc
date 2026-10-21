<#
---
catzc:
  immutable:
    with_body_sha: "3487b45080d1"
  edges:
    code: pwsh/Catzc.Base.Languages/types/DotnetConfig.cs
    cites:
      - ADR-AUTO-TYPES-DEBUGANYCPU
---
#>

Describe 'DotnetConfig' -Tag 'L0' {

    Context 'integrity (shipped dotnet.yml and the tracked solutions and projects)' -Tag 'integrity' {
        BeforeAll {
            $script:config = Get-Config -Config dotnet
            $script:root = Get-RepositoryRoot
            $script:tracked = @(Get-GitTrackedPath '.' | Where-Object { $_ -match '\.(sln|csproj)$' -and $_ -notmatch '(^|/)\.vendor/' })
        }

        It 'loads the shipped dotnet.yml as a DotnetConfig with the Debug on Any CPU pair' {
            $script:config | Should -BeOfType [Catzc.Base.Languages.DotnetConfig]
            $script:config.SolutionPair() | Should -BeExactly 'Debug|Any CPU'
        }

        It 'finds the tracked solutions and projects' {
            @($script:tracked | Where-Object { $_ -like '*.sln' }).Count | Should -BeGreaterThan 0
            @($script:tracked | Where-Object { $_ -like '*.csproj' }).Count | Should -BeGreaterThan 0
        }

        It 'declares only the configured pair in every solution (ADR-AUTO-TYPES-DEBUGANYCPU)' {
            $pair = [regex]::Escape($script:config.SolutionPair())
            $offenders = foreach ($path in $script:tracked.Where({ $_ -like '*.sln' })) {
                $text = [System.IO.File]::ReadAllText((Join-Path $script:root $path))
                $section = [regex]::Match($text, '(?s)GlobalSection\(SolutionConfigurationPlatforms\)[^\n]*\n(.*?)EndGlobalSection').Groups[1].Value
                foreach ($line in ($section -split '\r?\n').Where({ $_.Trim() })) {
                    if ($line.Trim() -notmatch "^$pair = $pair$") {
                        "${path}: $($line.Trim())"
                    }
                }
                $projects = [regex]::Match($text, '(?s)GlobalSection\(ProjectConfigurationPlatforms\)[^\n]*\n(.*?)EndGlobalSection').Groups[1].Value
                foreach ($line in ($projects -split '\r?\n').Where({ $_.Trim() })) {
                    if ($line.Trim() -notmatch "^\{[0-9A-F-]+\}\.$pair\.(ActiveCfg|Build\.0) = $pair$") {
                        "${path}: $($line.Trim())"
                    }
                }
            }
            $offenders | Should -BeNullOrEmpty
        }

        It 'declares only the configured pair in every project (ADR-AUTO-TYPES-DEBUGANYCPU)' {
            $offenders = foreach ($path in $script:tracked.Where({ $_ -like '*.csproj' })) {
                $xml = [xml][System.IO.File]::ReadAllText((Join-Path $script:root $path))
                $configurations = @($xml.SelectNodes('//Configurations') | ForEach-Object InnerText)
                $platforms = @($xml.SelectNodes('//Platforms') | ForEach-Object InnerText)
                if (($configurations -join ';') -cne $script:config.configuration -or ($platforms -join ';') -cne $script:config.ProjectPlatform()) {
                    "${path}: Configurations '$($configurations -join ';')', Platforms '$($platforms -join ';')'"
                }
            }
            $offenders | Should -BeNullOrEmpty
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'takes the declared defaults for an empty or absent file' {
            foreach ($raw in [ordered]@{}, $null) {
                $config = [Catzc.Base.Languages.DotnetConfig]::new($raw)
                $config.configuration | Should -BeExactly ([Catzc.Base.Languages.DotnetConfig]::DefaultConfiguration)
                $config.platform | Should -BeExactly ([Catzc.Base.Languages.DotnetConfig]::DefaultPlatform)
            }
            [Catzc.Base.Languages.DotnetConfig]::DefaultConfiguration | Should -BeExactly 'Debug'
            [Catzc.Base.Languages.DotnetConfig]::DefaultPlatform | Should -BeExactly 'Any CPU'
        }

        It 'treats a key set to null like an omitted key' {
            $config = [Catzc.Base.Languages.DotnetConfig]::new([ordered]@{ configuration = $null; platform = $null })
            $config.SolutionPair() | Should -BeExactly 'Debug|Any CPU'
        }

        It 'maps every key and spells the platform the way a project does' {
            $config = [Catzc.Base.Languages.DotnetConfig]::new([ordered]@{ configuration = 'Widget'; platform = 'Gadget CPU' })
            $config.SolutionPair() | Should -BeExactly 'Widget|Gadget CPU'
            $config.ProjectPlatform() | Should -BeExactly 'GadgetCPU'
        }

        It 'rejects an unknown key and an invalid name, naming each' {
            { [Catzc.Base.Languages.DotnetConfig]::new([ordered]@{ widget = 'x'; configuration = 'Debug|x64'; platform = 7 }) } |
                Should -Throw -ExpectedMessage "*unknown key 'widget'*invalid configuration 'Debug|x64'*invalid platform '7'*"
        }
    }
}
