Describe 'Install-VendorModule' -Tag 'L0', 'logic' {
    BeforeEach {
        # The run-mode guard is its own boundary (covered in the build-mode block below).
        Mock Assert-CatzcSourceTree -ModuleName Catzc.Base.Vendor { }
        Mock Write-Message -ModuleName Catzc.Base.Vendor { }
        Mock Resolve-VendorRepository -ModuleName Catzc.Base.Vendor { 'PSGallery' }
        Mock Get-Config -ModuleName Catzc.Base.Vendor { [Catzc.Base.Vendor.VendorConfig]::new(@{}) }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Vendor { 'TestDrive:' }
        Mock Test-Path -ModuleName Catzc.Base.Vendor { $true }
        Mock Save-PSResource -ModuleName Catzc.Base.Vendor { }
        Mock Get-ChildPath -ModuleName Catzc.Base.Vendor { @() }
        Mock Get-Module -ModuleName Catzc.Base.Vendor { }
    }

    It 'throws when the module is already loaded' {
        Mock Get-Module -ModuleName Catzc.Base.Vendor { [pscustomobject]@{ Name = 'X' } }
        { Install-VendorModule X } | Should -Throw '*fresh PowerShell session*'
    }

    It 'saves from the resolved repository into the vendor root, trusting it' {
        Install-VendorModule X
        Should -Invoke Save-PSResource -ModuleName Catzc.Base.Vendor -ParameterFilter {
            $Name -eq 'X' -and $Repository -eq 'PSGallery' -and $TrustRepository
        }
    }

    It 'passes the required version through as -Version' {
        Install-VendorModule X -RequiredVersion '5.5.0'
        Should -Invoke Save-PSResource -ModuleName Catzc.Base.Vendor -ParameterFilter { $Version -eq '5.5.0' }
    }

    It 'passes no credential when the source names no variable' {
        Install-VendorModule X
        Should -Invoke Save-PSResource -ModuleName Catzc.Base.Vendor -ParameterFilter { -not $Credential }
    }

    Context 'a source with a credential variable' {
        BeforeEach {
            $env:WIDGET_TOKEN = 'widget-secret'
            Mock Get-Config -ModuleName Catzc.Base.Vendor {
                [Catzc.Base.Vendor.VendorConfig]::new(@{ package_source = @{ name = 'widget'; url = 'https://feed.widget.test/v3/index.json'; credential_env = 'WIDGET_TOKEN' } })
            }
        }

        AfterEach {
            Remove-Item Env:WIDGET_TOKEN -ErrorAction Ignore
        }

        It 'passes the token as a credential named token' {
            Install-VendorModule X
            Should -Invoke Save-PSResource -ModuleName Catzc.Base.Vendor -ParameterFilter {
                $Credential.UserName -eq 'token' -and $Credential.GetNetworkCredential().Password -eq 'widget-secret'
            }
        }

        It 'throws naming the variable and the source when the variable is unset, before any download' {
            Remove-Item Env:WIDGET_TOKEN
            { Install-VendorModule X } | Should -Throw "*'widget'*'WIDGET_TOKEN'*"
            Should -Invoke Save-PSResource -ModuleName Catzc.Base.Vendor -Times 0
        }
    }

    It 'prunes the folders the toolset never loads and keeps the rest' {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $version = Join-Path $root 'gadgets/.vendor/Widget/1.0.0'
        foreach ($folder in 'net48', 'compatibility_profiles', 'net8.0', 'Settings') {
            New-Item -ItemType Directory -Path (Join-Path $version $folder) -Force | Out-Null
        }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Vendor { $root }.GetNewClosure()
        Mock Get-Track -ModuleName Catzc.Base.Vendor { [pscustomobject]@{ type = 'vendored-code'; places = @('gadgets/.vendor') } }
        Mock Get-ChildPath -ModuleName Catzc.Base.Vendor { Catzc.Base.Folders\Get-ChildPath @PesterBoundParameters }

        Install-VendorModule Widget

        @([System.IO.Directory]::GetDirectories($version) | ForEach-Object { [System.IO.Path]::GetFileName($_) } |
                Sort-Object) |
                Should -Be @('net8.0', 'Settings')
    }
}

Describe 'Install-VendorModule — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package, before downloading' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        Mock Save-PSResource -ModuleName Catzc.Base.Vendor { }
        { Install-VendorModule Gadget } | Should -Throw '*Install-VendorModule runs in catzc*s source tree only*'
        Should -Invoke Save-PSResource -ModuleName Catzc.Base.Vendor -Times 0
    }
}
