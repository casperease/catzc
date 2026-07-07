Describe 'Remove-MacToolInstall' -Tag 'L0', 'logic' {
    It 'throws not-implemented (macOS eviction is a stub) and names the manual path' -Tag 'ADR-REMOVE#7' {
        $config = [pscustomobject]@{ command = 'widget' }
        { Remove-MacToolInstall -Config $config } | Should -Throw '*not implemented yet*'
    }
}
