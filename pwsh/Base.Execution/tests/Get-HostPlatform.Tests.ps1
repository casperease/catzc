Describe 'Get-HostPlatform' -Tag 'L0', 'logic' {
    It 'names the host as os slash arch in the Go spelling' {
        Get-HostPlatform | Should -Match '^(windows|linux|darwin)/(amd64|arm64)$'
    }

    It 'names the operating system the session runs on' {
        $expected = if ($IsWindows) {
            'windows'
        }
        elseif ($IsMacOS) {
            'darwin'
        }
        else {
            'linux'
        }
        (Get-HostPlatform).Split('/')[0] | Should -BeExactly $expected
    }

    It 'gives the same answer twice' {
        Get-HostPlatform | Should -BeExactly (Get-HostPlatform)
    }
}
