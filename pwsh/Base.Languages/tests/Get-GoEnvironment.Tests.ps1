Describe 'Get-GoEnvironment' {
    BeforeAll {
        $script:publicUrl = [Catzc.Base.Languages.PackageSource]::GoProxy.url
    }

    Context 'the public proxy' {
        BeforeEach {
            Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'go' } {
                [pscustomobject]@{ package_source = [pscustomobject]@{ name = 'public'; url = [Catzc.Base.Languages.PackageSource]::GoProxy.url } }
            }
        }

        It 'sets only GOPROXY to the public url' {
            $environment = Get-GoEnvironment
            @($environment.Keys) | Should -Be @('GOPROXY')
            $environment['GOPROXY'] | Should -BeExactly $script:publicUrl
        }

        It 'sets GOPROXY to off with Offline' {
            $environment = Get-GoEnvironment -Offline
            @($environment.Keys) | Should -Be @('GOPROXY')
            $environment['GOPROXY'] | Should -BeExactly 'off'
        }
    }

    Context 'a private source' {
        BeforeEach {
            Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $Config -eq 'go' } {
                [pscustomobject]@{ package_source = [pscustomobject]@{ name = 'widget'; url = 'https://goproxy.widget.example/path' } }
            }
        }

        It 'sets the proxy, the private host and no checksum database' {
            $environment = Get-GoEnvironment
            $environment['GOPROXY'] | Should -BeExactly 'https://goproxy.widget.example/path'
            $environment['GOPRIVATE'] | Should -BeExactly 'goproxy.widget.example'
            $environment['GOSUMDB'] | Should -BeExactly 'off'
        }

        It 'sets GOPROXY to off with Offline and keeps the other two' {
            $environment = Get-GoEnvironment -Offline
            $environment['GOPROXY'] | Should -BeExactly 'off'
            $environment['GOPRIVATE'] | Should -BeExactly 'goproxy.widget.example'
            $environment['GOSUMDB'] | Should -BeExactly 'off'
        }
    }
}
