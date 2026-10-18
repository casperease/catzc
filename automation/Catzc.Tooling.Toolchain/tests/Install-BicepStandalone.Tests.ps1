Describe 'Install-BicepStandalone' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:fakeHome = Join-Path $TestDrive "home-$([guid]::NewGuid().ToString('N'))"
        $script:savedHome = $env:HOME
        $env:HOME = $script:fakeHome
        $script:architecture = if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64') {
            'arm64'
        }
        else {
            'x64'
        }
        $asset = {
            param($name, $digest)
            [pscustomobject]@{ name = $name; browser_download_url = "https://example.invalid/$name"; digest = $digest }
        }
        $script:releases = @(
            [pscustomobject]@{ tag_name = 'v0.49.0'; prerelease = $false; assets = @(& $asset "bicep-linux-$script:architecture" 'sha256:aa') }
            [pscustomobject]@{ tag_name = 'v0.48.2'; prerelease = $true; assets = @(& $asset "bicep-linux-$script:architecture" 'sha256:bb') }
            [pscustomobject]@{ tag_name = 'v0.48.1'; prerelease = $false; assets = @((& $asset "bicep-linux-$script:architecture" 'sha256:cc'), (& $asset 'bicep-linux-musl-x64' 'sha256:dd')) }
            [pscustomobject]@{ tag_name = 'v0.48.0'; prerelease = $false; assets = @(& $asset "bicep-linux-$script:architecture" 'sha256:ee') }
        )
        Mock Write-Message -ModuleName Catzc.Tooling.Toolchain { }
        Mock Invoke-RestMethod -ModuleName Catzc.Tooling.Toolchain { , $script:releases }
        Mock Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain { [System.IO.File]::WriteAllText($OutFile, 'bicep'); $OutFile }
        Mock Invoke-Executable -ModuleName Catzc.Tooling.Toolchain { }
    }

    AfterEach {
        $env:HOME = $script:savedHome
    }

    It 'downloads the newest stable release at the pin, verified against its published digest, into ~/.local/bin' {
        InModuleScope Catzc.Tooling.Toolchain { Install-BicepStandalone -Version '0.48' }
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter {
            $Uri -eq "https://example.invalid/bicep-linux-$script:architecture" -and $Sha256 -eq 'sha256:cc'
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Toolchain -Times 1 -Exactly -ParameterFilter { $Command -like 'chmod +x *' }
        Join-Path $script:fakeHome '.local/bin/bicep' | Should -Exist
        Join-Path $script:fakeHome '.local/bin/bicep.download' | Should -Not -Exist
    }

    It 'throws when no release matches the pin, naming the tools.yml pin to bump' {
        { InModuleScope Catzc.Tooling.Toolchain { Install-BicepStandalone -Version '0.47' } } | Should -Throw '*No Azure/bicep release matches the locked 0.47.x*tools.yml*'
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'refuses an asset without a published digest' {
        $script:releases[2].assets[0].digest = ''
        { InModuleScope Catzc.Tooling.Toolchain { Install-BicepStandalone -Version '0.48' } } | Should -Throw '*no published SHA-256*refusing an unverified download*'
        Should -Invoke Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain -Times 0
    }

    It 'leaves no half-written binary when the verified download fails' {
        Mock Save-VerifiedDownload -ModuleName Catzc.Tooling.Toolchain { throw 'SHA-256 mismatch' }
        { InModuleScope Catzc.Tooling.Toolchain { Install-BicepStandalone -Version '0.48' } } | Should -Throw '*SHA-256 mismatch*'
        Join-Path $script:fakeHome '.local/bin/bicep' | Should -Not -Exist
        Join-Path $script:fakeHome '.local/bin/bicep.download' | Should -Not -Exist
    }
}
