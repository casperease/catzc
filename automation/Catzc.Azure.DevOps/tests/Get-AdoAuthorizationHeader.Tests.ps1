Describe 'Get-AdoAuthorizationHeader' -Tag 'L0', 'logic' {
    Context 'in pipeline' {
        BeforeEach {
            $script:origTfBuild = $env:TF_BUILD
            $script:origToken = $env:SYSTEM_ACCESSTOKEN
            $script:origCollection = $env:SYSTEM_COLLECTIONURI
            $env:TF_BUILD = 'True'
            $env:SYSTEM_ACCESSTOKEN = 'test-token-value'
            Mock Get-Config -ParameterFilter { $Config -eq 'ado' } -MockWith { @{ organization = 'https://dev.azure.com/org' } } -ModuleName Catzc.Azure.DevOps
        }

        AfterEach {
            $env:TF_BUILD = $script:origTfBuild
            $env:SYSTEM_ACCESSTOKEN = $script:origToken
            $env:SYSTEM_COLLECTIONURI = $script:origCollection
        }

        It 'uses SYSTEM_ACCESSTOKEN when the collection matches the configured org' {
            $env:SYSTEM_COLLECTIONURI = 'https://dev.azure.com/org/'
            $header = Get-AdoAuthorizationHeader
            $header | Should -BeOfType [hashtable]
            $header.Authorization | Should -Be 'Bearer test-token-value'
        }

        It 'throws when the pipeline collection does not match the configured org' {
            $env:SYSTEM_COLLECTIONURI = 'https://dev.azure.com/other-org'
            { Get-AdoAuthorizationHeader } | Should -Throw '*does not match*'
        }
    }

    Context 'PAT authentication' {
        It 'uses AZURE_DEVOPS_PAT with Basic auth' {
            $origTfBuild = $env:TF_BUILD
            $origToken = $env:SYSTEM_ACCESSTOKEN
            $origPat = $env:AZURE_DEVOPS_PAT
            try {
                $env:TF_BUILD = $null
                $env:SYSTEM_ACCESSTOKEN = $null
                $env:AZURE_DEVOPS_PAT = 'test-pat-value'

                $header = Get-AdoAuthorizationHeader
                $header | Should -BeOfType [hashtable]
                $expected = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(':test-pat-value'))
                $header.Authorization | Should -Be "Basic $expected"
            }
            finally {
                $env:TF_BUILD = $origTfBuild
                $env:SYSTEM_ACCESSTOKEN = $origToken
                $env:AZURE_DEVOPS_PAT = $origPat
            }
        }
    }

    Context 'az CLI fallback' {
        BeforeEach {
            $script:origTfBuild = $env:TF_BUILD
            $script:origToken = $env:SYSTEM_ACCESSTOKEN
            $script:origPat = $env:AZURE_DEVOPS_PAT
            $env:TF_BUILD = $null
            $env:SYSTEM_ACCESSTOKEN = $null
            $env:AZURE_DEVOPS_PAT = $null
            # ado.yml supplies the tenant; az session is asserted before the token request.
            Mock Get-Config -ParameterFilter { $Config -eq 'ado' } -MockWith { @{ tenant = 'fa0e0000-7e0a-0700-1d00-000000000000' } } -ModuleName Catzc.Azure.DevOps
        }

        AfterEach {
            $env:TF_BUILD = $script:origTfBuild
            $env:SYSTEM_ACCESSTOKEN = $script:origToken
            $env:AZURE_DEVOPS_PAT = $script:origPat
        }

        It 'asserts the session is in ado.yml''s tenant, then returns a Bearer token' {
            Mock Assert-AzCliConnected { } -ModuleName Catzc.Azure.DevOps
            Mock Invoke-Executable { [pscustomobject]@{ Output = 'tok-123' } } -ModuleName Catzc.Azure.DevOps

            $header = Get-AdoAuthorizationHeader
            $header.Authorization | Should -Be 'Bearer tok-123'
            Should -Invoke Assert-AzCliConnected -ModuleName Catzc.Azure.DevOps -ParameterFilter {
                $TenantId -eq 'fa0e0000-7e0a-0700-1d00-000000000000'
            }
        }

        It 'propagates the assertion failure when the session is in the wrong tenant' {
            Mock Assert-AzCliConnected { throw 'az CLI is set to the wrong context.' } -ModuleName Catzc.Azure.DevOps

            { Get-AdoAuthorizationHeader } | Should -Throw '*wrong context*'
        }
    }
}
