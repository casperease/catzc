Describe 'Convert-FirewallCsvToMarkdown' -Tag 'L2', 'logic' {
    BeforeAll {
        $script:assets = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Firewall/tests/assets'
        $script:appCsv = Join-Path $assets 'application.csv'
        $script:netCsv = Join-Path $assets 'network.csv'
        Mock Write-Message -ModuleName Catzc.Azure.Firewall {}

        # The fixtures use rcg-baseline / rcg-app / rcg-shared; the function's default GroupPriority only
        # knows rcg-old/rcg-new. Supply priorities so the evaluation-order sort is meaningful.
        $script:groupPriority = @{ 'rcg-baseline' = 100; 'rcg-app' = 200; 'rcg-shared' = 300 }

        # Pull the rule-name column out of a rendered table, in row order, for ordering assertions.
        function script:Get-RuleOrder {
            param([string]$Markdown)
            $Markdown -split "`r?`n" |
                Where-Object { $_ -match '^\| ' -and $_ -notmatch '^\| -' -and $_ -notmatch '^\| Name ' } |
                ForEach-Object { ($_ -split '\|')[1].Trim() }
        }
    }

    Context 'network.csv (Path set)' {
        BeforeAll {
            $script:md = Join-Path $TestDrive 'network.md'
            Convert-FirewallCsvToMarkdown -CsvPath $netCsv -MarkdownPath $md -GroupPriority $groupPriority
            $script:text = Get-Content $md -Raw
            $script:lines = $text -split "`r?`n"
            $script:order = Get-RuleOrder $text
        }

        It 'writes the title, rules section, and a table header + separator' {
            $lines[0] | Should -BeExactly '# network.csv'
            $text | Should -Match '## Rules'
            ($lines | Where-Object { $_ -match '^\| Name \| Source \| Protocol/Port \| Destination \| RuleCollectionGroup \| RuleCollectionPriority \|' }) | Should -Not -BeNullOrEmpty
            ($lines | Where-Object { $_ -match '^\| --- \|' }) | Should -Not -BeNullOrEmpty
        }

        It 'sorts by group priority, then collection priority, then name' {
            # rcg-baseline(100): Allow_DNS(200), Allow_NTP(210) | rcg-app(200): starts at Allow_OnPrem_SQL(300)
            # | rcg-shared(300): Allow_Ping_Mgmt(400) ... Deny_All_Network(3100) last.
            $order[0] | Should -Be 'Allow_DNS'
            $order.IndexOf('Allow_DNS')        | Should -BeLessThan $order.IndexOf('Allow_NTP')
            $order.IndexOf('Allow_NTP')        | Should -BeLessThan $order.IndexOf('Allow_OnPrem_SQL')
            $order.IndexOf('Allow_OnPrem_SQL') | Should -BeLessThan $order.IndexOf('Allow_Ping_Mgmt')
            $order[-1] | Should -Be 'Deny_All_Network'
        }

        It 'trims IP-group resource IDs to their simple name' {
            $dnsRow = $lines | Where-Object { $_ -match '^\| Allow_DNS ' }
            $dnsRow | Should -Match 'ipg-dns-forwarders'
            $dnsRow | Should -Not -Match '/subscriptions/'
        }

        It 'pairs protocols with ports as protocols:ports' {
            $dnsRow = $lines | Where-Object { $_ -match '^\| Allow_DNS ' }
            $dnsRow | Should -Match 'UDP/TCP:53'
        }

        It 'lists both IP groups and raw addresses in a composite Destination cell' {
            # Allow_DNS destination = ipg-dns-forwarders (group) + 168.63.129.16,1.1.1.1 (addresses)
            $dnsRow = $lines | Where-Object { $_ -match '^\| Allow_DNS ' }
            $dnsRow | Should -Match 'ipg-dns-forwarders'
            $dnsRow | Should -Match '168\.63\.129\.16'
        }
    }

    Context 'application.csv (Path set)' {
        BeforeAll {
            $script:md = Join-Path $TestDrive 'application.md'
            Convert-FirewallCsvToMarkdown -CsvPath $appCsv -MarkdownPath $md -GroupPriority $groupPriority
            $script:lines = (Get-Content $md -Raw) -split "`r?`n"
        }

        It 'backtick-wraps FQDN cells so markdownlint does not flag a bare URL' {
            $row = $lines | Where-Object { $_ -match '^\| Allow_Microsoft_Fqdns ' }
            $row | Should -Match '`\*\.microsoft\.com'
        }

        It 'passes an application rule protocol (port embedded) straight through' {
            $row = $lines | Where-Object { $_ -match '^\| Allow_WindowsUpdate ' }
            $row | Should -Match 'Http:80'
            $row | Should -Match 'Https:443'
        }
    }

    Context '-DoNotCutIpgNames' {
        It 'keeps the full IP-group resource id' {
            $md = Join-Path $TestDrive 'network-full.md'
            Convert-FirewallCsvToMarkdown -CsvPath $netCsv -MarkdownPath $md -GroupPriority $groupPriority -DoNotCutIpgNames
            $dnsRow = ((Get-Content $md -Raw) -split "`r?`n") | Where-Object { $_ -match '^\| Allow_DNS ' }
            $dnsRow | Should -Match '/subscriptions/.*/ipGroups/ipg-dns-forwarders'
        }
    }

    Context 'schema mismatch' {
        It 'throws when a required column has no backing CSV field' {
            $bad = Join-Path $TestDrive 'bad.csv'
            # Has a Name but none of the Source / Protocol/Port / Destination candidate fields.
            'Name,Note', 'rule-1,hello' | Set-Content -Path $bad -Encoding UTF8
            { Convert-FirewallCsvToMarkdown -CsvPath $bad -MarkdownPath (Join-Path $TestDrive 'bad.md') } |
                Should -Throw '*No matching CSV fields*'
        }
    }

    Context 'Object parameter set (pipeline from Get-FirewallCsv)' {
        It 'writes a md named after the source csv, titled from the blob name' {
            $folder = Join-Path $TestDrive 'objout'
            [pscustomobject]@{
                Type      = 'network'
                Path      = $netCsv
                Generated = [datetime]'2026-06-16T11:00:00Z'
                Blob      = 'NetworkRules-16-06-2026-11-00.csv'
            } | Convert-FirewallCsvToMarkdown -OutputFolder $folder

            $written = Join-Path $folder 'network.md'
            Test-Path $written | Should -BeTrue
            ((Get-Content $written -Raw) -split "`r?`n")[0] | Should -BeExactly '# NetworkRules-16-06-2026-11-00.csv'
        }
    }
}
