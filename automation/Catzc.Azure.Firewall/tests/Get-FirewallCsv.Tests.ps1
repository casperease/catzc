# cspell:ignore etwork
Describe 'Get-FirewallCsv' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:assets = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Firewall/tests/assets'
        $script:subscriptionId = '50a0ed00-de00-50b0-0000-000000000000'

        # A realistic blob listing. The dd-MM-yyyy names do NOT sort chronologically by string:
        # 'ApplicationRules-30-01-2026-...' is lexically largest but is January (older than June),
        # so a correct newest-by-filename-timestamp pick must return the June blobs.
        $script:blobJson = @'
[
  { "name": "ApplicationRules-30-01-2026-23-59.csv", "properties": { "lastModified": "2026-01-30T23:59:00+00:00" } },
  { "name": "ApplicationRules-16-06-2026-10-32.csv", "properties": { "lastModified": "2026-06-16T10:32:00+00:00" } },
  { "name": "ApplicationRules-latest.csv",           "properties": { "lastModified": "2026-06-20T00:00:00+00:00" } },
  { "name": "NetworkRules-14-06-2026-09-00.csv",     "properties": { "lastModified": "2026-06-14T09:00:00+00:00" } },
  { "name": "NetworkRules-16-06-2026-11-00.csv",     "properties": { "lastModified": "2026-06-16T11:00:00+00:00" } },
  { "name": "README.txt",                            "properties": { "lastModified": "2026-06-16T11:00:00+00:00" } }
]
'@

        Mock Assert-AzCliConnected -ModuleName Catzc.Azure.Firewall {}

        # Default happy-path az mock: list returns the JSON above; download copies the matching fixture
        # to --file so the emitted Path points at a real CSV (nothing ever calls live ARM).
        Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall {
            if ($Arguments -match 'blob list') {
                return [pscustomobject]@{ Output = $blobJson; ExitCode = 0 }
            }
            if ($Arguments -match 'blob download') {
                $file = if ($Arguments -match '--file "([^"]+)"') {
                    $Matches[1]
                }
                $source = if ($Arguments -match '--name "[^"]*[Nn]etwork') {
                    Join-Path $assets 'network.csv'
                }
                else {
                    Join-Path $assets 'application.csv'
                }
                Copy-Item $source $file -Force
                return
            }
        }
    }

    Context 'happy path (both types)' {
        BeforeAll {
            $script:results = @(Get-FirewallCsv -SubscriptionId $subscriptionId -StorageAccountName stfw -ContainerName exports -DownloadPath $TestDrive)
        }

        It 'asserts the session is on the requested subscription before reading' {
            Should -Invoke Assert-AzCliConnected -ModuleName Catzc.Azure.Firewall -Scope Context -ParameterFilter {
                $SubscriptionId -eq $subscriptionId
            }
        }

        It 'emits one object per type' {
            $results.Count | Should -Be 2
            $results.Type | Should -Contain 'application'
            $results.Type | Should -Contain 'network'
        }

        It 'picks the newest blob by the filename timestamp, not lexical name or lastModified' {
            ($results | Where-Object Type -EQ 'application').Blob | Should -Be 'ApplicationRules-16-06-2026-10-32.csv'
            ($results | Where-Object Type -EQ 'network').Blob | Should -Be 'NetworkRules-16-06-2026-11-00.csv'
        }

        It 'parses Generated (UTC) from the filename and downloads to a real path' {
            $application = $results | Where-Object Type -EQ 'application'
            $application.Generated.Kind | Should -Be 'Utc'
            $application.Generated.Year | Should -Be 2026
            $application.Generated.Month | Should -Be 6
            $application.Generated.Day | Should -Be 16
            $application.Generated.Hour | Should -Be 10
            $application.Generated.Minute | Should -Be 32
            Test-Path $application.Path | Should -BeTrue
        }
    }

    Context 'single type' {
        It 'emits only the requested type' {
            $results = @(Get-FirewallCsv -SubscriptionId $subscriptionId -StorageAccountName stfw -ContainerName exports -Type application -DownloadPath $TestDrive)
            $results.Count | Should -Be 1
            $results[0].Type | Should -Be 'application'
        }
    }

    Context 'no qualifying blob' {
        It 'throws when no CSV of the requested type has a parseable timestamp' {
            Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall {
                # Only application blobs present -> nothing matches the 'network' name filter.
                [pscustomobject]@{ Output = '[{ "name": "ApplicationRules-16-06-2026-10-32.csv", "properties": { "lastModified": "2026-06-16T10:32:00+00:00" } }]'; ExitCode = 0 }
            }
            { Get-FirewallCsv -SubscriptionId $subscriptionId -StorageAccountName stfw -ContainerName exports -Type network -DownloadPath $TestDrive } |
                Should -Throw '*No CSV matching*'
        }
    }

    Context 'timestamp-shaped but unparseable' {
        It 'refuses to guess rather than silently mis-date' {
            Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall {
                [pscustomobject]@{ Output = '[{ "name": "ApplicationRules-99-99-2026-10-32.csv", "properties": { "lastModified": "2026-06-16T10:32:00+00:00" } }]'; ExitCode = 0 }
            }
            { Get-FirewallCsv -SubscriptionId $subscriptionId -StorageAccountName stfw -ContainerName exports -Type application -DownloadPath $TestDrive } |
                Should -Throw '*refusing to guess*'
        }
    }

    Context 'az failures' {
        It 'wraps a blob-list failure with remediation' {
            Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall { throw 'AuthorizationFailed' }
            { Get-FirewallCsv -SubscriptionId $subscriptionId -StorageAccountName stfw -ContainerName exports -Type application -DownloadPath $TestDrive } |
                Should -Throw '*Failed to list blobs*'
        }

        It 'wraps a download failure with the blob and destination' {
            Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall {
                if ($Arguments -match 'blob list') {
                    return [pscustomobject]@{ Output = $blobJson; ExitCode = 0 }
                }
                throw 'network glitch'
            }
            { Get-FirewallCsv -SubscriptionId $subscriptionId -StorageAccountName stfw -ContainerName exports -Type application -DownloadPath $TestDrive } |
                Should -Throw '*Failed to download*'
        }
    }
}
