Describe 'PackageSource' -Tag 'L0' {
    BeforeAll {
        $script:read = {
            param($Value, $Fallback = [Catzc.Base.Languages.PackageSource]::PyPI)
            $errors = [System.Collections.Generic.List[string]]::new()
            $source = [Catzc.Base.Languages.PackageSource]::Read($Value, $Fallback, $errors)
            [pscustomobject]@{ Source = $source; Errors = @($errors) }
        }
    }

    Context 'reading' -Tag 'logic' {
        It 'reads the name, the url and the credential variable' {
            $result = & $script:read ([ordered]@{ name = 'widget'; url = 'https://feed.widget.test/simple'; credential_env = 'WIDGET_TOKEN' })
            @($result.Errors).Count | Should -Be 0
            $result.Source.name | Should -Be 'widget'
            $result.Source.url | Should -Be 'https://feed.widget.test/simple'
            $result.Source.credential_env | Should -Be 'WIDGET_TOKEN'
        }

        It 'defaults the credential to empty and a left-out key to the fallback' {
            $result = & $script:read ([ordered]@{ url = 'https://feed.widget.test/simple' })
            @($result.Errors).Count | Should -Be 0
            $result.Source.name | Should -Be 'pypi'
            $result.Source.credential_env | Should -Be ''
        }

        It 'returns the fallback for an absent value' {
            $result = & $script:read $null
            $result.Source | Should -Be ([Catzc.Base.Languages.PackageSource]::PyPI)
        }

        It 'rejects a non-https url with a message naming the key' {
            $result = & $script:read ([ordered]@{ url = 'http://feed.widget.test/simple' })
            @($result.Errors).Count | Should -Be 1
            $result.Errors[0] | Should -BeLike "*package_source.url 'http://feed.widget.test/simple'*"
        }

        It 'rejects an unknown key and a credential that is not a variable name' {
            $result = & $script:read ([ordered]@{ token = 'x'; credential_env = 'not a name' })
            @($result.Errors).Count | Should -Be 2
            $result.Errors[0] | Should -BeLike "*unknown key 'token'*"
            $result.Errors[1] | Should -BeLike '*package_source.credential_env*'
        }

        It 'takes a registry host only where the fallback is the registry form' {
            $registry = [Catzc.Base.Languages.PackageSource]::BicepRegistry
            (& $script:read ([ordered]@{ url = 'registry.widget.test/bicep' }) $registry).Errors.Count | Should -Be 0
            @((& $script:read ([ordered]@{ url = 'registry.widget.test/bicep' })).Errors).Count | Should -Be 1
        }
    }

    Context 'defaults' -Tag 'logic' {
        It 'declares each public default with its short name and its address' -ForEach @(
            @{ Member = 'PyPI'; Name = 'pypi'; Url = 'https://pypi.org/simple' }
            @{ Member = 'GoProxy'; Name = 'goproxy'; Url = 'https://proxy.golang.org' }
            @{ Member = 'Npm'; Name = 'npm'; Url = 'https://registry.npmjs.org' }
            @{ Member = 'PSGallery'; Name = 'psgallery'; Url = 'https://www.powershellgallery.com/api/v2' }
            @{ Member = 'NuGet'; Name = 'nuget'; Url = 'https://api.nuget.org/v3/index.json' }
            @{ Member = 'GitHubReleases'; Name = 'github'; Url = 'https://github.com' }
            @{ Member = 'BicepRegistry'; Name = 'mcr'; Url = 'mcr.microsoft.com/bicep' }
        ) {
            $source = [Catzc.Base.Languages.PackageSource]::$Member
            $source.name | Should -Be $Name
            $source.url | Should -Be $Url
            $source.credential_env | Should -Be ''
        }
    }
}
