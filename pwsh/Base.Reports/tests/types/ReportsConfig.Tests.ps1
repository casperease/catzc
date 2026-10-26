Describe 'Catzc.Base.Reports.ReportsConfig' -Tag 'L0', 'logic' {
    It 'defaults every key, so an empty file gives the test-subject folder, the subject report, and latest.txt' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $config = [Catzc.Base.Reports.ReportsConfig]::new(@{})
        $config.FolderFor('widget') | Should -Be 'test-widget'
        $config.ReportFileFor('widget') | Should -Be 'widget.md'
        $config.latest_file | Should -Be 'latest.txt'
        $config.stamp_format | Should -Be 'yyyyMMdd-HHmmss'
    }

    It 'overrides only the keys a file sets' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $config = [Catzc.Base.Reports.ReportsConfig]::new(@{ folder = 'gate-{subject}'; report_file = 'report.md' })
        $config.FolderFor('gadget') | Should -Be 'gate-gadget'
        $config.ReportFileFor('gadget') | Should -Be 'report.md'
        $config.latest_file | Should -Be 'latest.txt'
    }

    It 'reports every bad value in one throw' -Tag 'ADR-AUTO-TEST-QUALITYGATE' {
        $bad = @{ widget = 1; folder = 'shared'; report_file = '../escape.md'; latest_file = 'a/b' }
        $thrown = { [Catzc.Base.Reports.ReportsConfig]::new($bad) } | Should -Throw -PassThru
        $message = $thrown.Exception.InnerException.Message
        $message | Should -Match "unknown key 'widget'"
        $message | Should -Match "folder must contain '\{subject\}'"
        $message | Should -Match "report_file '\.\./escape\.md' must be one path segment"
        $message | Should -Match "latest_file 'a/b' must be one path segment"
    }
}
