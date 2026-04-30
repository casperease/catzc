Describe 'Convert-FirewallCsvToYaml' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:assets = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Firewall/tests/assets'
        $script:appCsv = Join-Path $assets 'application.csv'
        $script:netCsv = Join-Path $assets 'network.csv'
        # Quiet the "wrote ..." log line; this is the module's own status output.
        Mock Write-Message -ModuleName Catzc.Azure.Firewall {}
    }

    Context 'application.csv (Path set)' {
        BeforeAll {
            $script:out = Join-Path $TestDrive 'application.yaml'
            Convert-FirewallCsvToYaml -CsvPath $appCsv -YamlPath $out
            $script:raw = Get-Content $out -Raw
            $script:rules = $raw | ConvertFrom-Yaml
            $script:wu = $rules | Where-Object { $_.Name -eq 'Allow_WindowsUpdate' }
        }

        It 'round-trips to a list with one entry per CSV row' {
            @($rules).Count | Should -Be 20
            $rules | ForEach-Object { $_.Name | Should -Not -BeNullOrEmpty }
        }

        It 'splits a multi-value field into an array' {
            @($wu.Protocols).Count | Should -Be 2
            $wu.Protocols | Should -Contain 'Http:80'
            $wu.Protocols | Should -Contain 'Https:443'
        }

        It 'forces a single value to a one-element array' {
            @($wu.SourceIpGroups).Count | Should -Be 1
        }

        It 'renders a blank multi-value field as an empty array' {
            @($wu.SourceAddresses).Count | Should -Be 0
        }

        It 'leaves a non-multi-value field as a scalar string' {
            $wu.RuleCollectionPriority | Should -BeExactly '200'
        }

        It 'writes a Source header comment and no generated line when -GeneratedAt is omitted' {
            $raw | Should -Match '# Source: application\.csv'
            $raw | Should -Not -Match 'CSV generated'
        }
    }

    Context 'network.csv (schema-agnostic with the same defaults)' {
        BeforeAll {
            $script:out = Join-Path $TestDrive 'network.yaml'
            Convert-FirewallCsvToYaml -CsvPath $netCsv -YamlPath $out
            $script:rules = Get-Content $out -Raw | ConvertFrom-Yaml
        }

        It 'splits DestinationPorts and DestinationIpGroups into arrays' {
            $webTier = $rules | Where-Object { $_.Name -eq 'Allow_Web_Tier' }
            @($webTier.DestinationPorts).Count | Should -Be 2     # "80,443"
        }

        It 'splits on semicolons as well as commas' {
            $hubSpoke = $rules | Where-Object { $_.Name -eq 'Allow_Hub_To_Spoke' }
            @($hubSpoke.DestinationIpGroups).Count | Should -Be 3   # ipg-spoke-prod;dev;test
        }
    }

    Context 'with -GeneratedAt' {
        It 'records the CSV generation time in the header' {
            $out = Join-Path $TestDrive 'app-gen.yaml'
            Convert-FirewallCsvToYaml -CsvPath $appCsv -YamlPath $out -GeneratedAt ([datetime]'2026-06-16T10:32:00Z')
            # Literal ':' guards against the locale separator regression — the function formats with
            # InvariantCulture, so every machine renders 10:32 (a da-DK box without it would render 10.32).
            (Get-Content $out -Raw) | Should -Match '# CSV generated: 2026-06-16 10:32 UTC'
        }
    }

    Context 'Object parameter set (pipeline from Get-FirewallCsv)' {
        It 'writes a yaml named after the source csv, titled from the blob name' {
            $folder = Join-Path $TestDrive 'objout'
            [pscustomobject]@{
                Type      = 'application'
                Path      = $appCsv
                Generated = [datetime]'2026-06-16T10:32:00Z'
                Blob      = 'ApplicationRules-16-06-2026-10-32.csv'
            } | Convert-FirewallCsvToYaml -OutputFolder $folder

            $written = Join-Path $folder 'application.yaml'
            Test-Path $written | Should -BeTrue
            (Get-Content $written -Raw) | Should -Match '# Source: ApplicationRules-16-06-2026-10-32\.csv'
        }
    }
}
