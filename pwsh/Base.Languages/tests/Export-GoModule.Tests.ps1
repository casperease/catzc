Describe 'Export-GoModule' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $script:module = Join-Path $script:root 'go/widget'
        $null = New-Item -ItemType Directory -Path $script:module -Force
        $script:goPath = Join-Path $TestDrive 'managed go/bin/go.exe'
        $script:go = "`"$($script:goPath)`""
    }

    BeforeEach {
        $script:seen = [System.Collections.Generic.List[object]]::new()
        $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('go', $script:goPath, 'probe', '1.27.1', '1.27',
            $true, 1, 0, 'Agent')
        $script:buildExit = 0
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Languages { $script:probe }
        Mock Write-Message -ModuleName Catzc.Base.Languages { }
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages {
            $output = [regex]::Match($Command, '-o "([^"]+)"').Groups[1].Value
            $script:seen.Add([pscustomobject]@{
                    Command   = $Command
                    Directory = $WorkingDirectory
                    Output    = $output
                    Os        = $env:GOOS
                    Arch      = $env:GOARCH
                    Cgo       = $env:CGO_ENABLED
                    Flags     = $env:GOFLAGS
                    Proxy     = $env:GOPROXY
                })
            if ($script:buildExit -eq 0) {
                [System.IO.File]::WriteAllBytes($output, [System.Text.Encoding]::UTF8.GetBytes("binary $env:GOOS $env:GOARCH"))
            }
            [Catzc.Base.Execution.CliResult]::new('', $(if ($script:buildExit) {
                        'build broke'
                    }
                    else {
                        ''
                    }), $script:buildExit)
        }
        $script:out = Join-Path $TestDrive "out-$([guid]::NewGuid().ToString('N'))"
    }

    AfterEach {
        $vendor = Join-Path $script:module 'vendor'
        if (Test-Path -LiteralPath $vendor) {
            Remove-Item -LiteralPath $vendor -Recurse -Force
        }
    }

    It 'builds once per platform with the matching GOOS and GOARCH and cgo off' {
        $null = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64', 'darwin/arm64' -Silent
        $script:seen.Count | Should -Be 2
        $script:seen[0].Os | Should -BeExactly 'linux'
        $script:seen[0].Arch | Should -BeExactly 'amd64'
        $script:seen[1].Os | Should -BeExactly 'darwin'
        $script:seen[1].Arch | Should -BeExactly 'arm64'
        $script:seen.Cgo | Should -Be @('0', '0')
    }

    It 'runs the managed go by its path in the module folder with the build flags' {
        $null = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64' -Silent
        $script:seen[0].Command | Should -BeLike "$($script:go) build -trimpath -ldflags `"-s -w -buildid=`" -o `"*`" ."
        $script:seen[0].Directory | Should -BeExactly ([System.IO.Path]::Combine($script:root, 'go/widget'))
    }

    It 'writes each binary under its platform folder named for the module, with exe on windows' {
        $null = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64', 'windows/amd64' -Silent
        $script:seen[0].Output | Should -BeExactly (Join-Path $script:out 'linux-amd64/widget')
        $script:seen[1].Output | Should -BeExactly (Join-Path $script:out 'windows-amd64/widget.exe')
        Test-Path -LiteralPath (Join-Path $script:out 'windows-amd64/widget.exe') | Should -BeTrue
    }

    It 'builds from the vendor folder when the module has one' {
        $null = New-Item -ItemType Directory -Path (Join-Path $script:module 'vendor') -Force
        $null = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64' -Silent
        $script:seen[0].Flags | Should -BeExactly '-mod=vendor'
        $script:seen[0].Proxy | Should -BeExactly 'off'
    }

    It 'builds from the local module cache with the proxy off when there is no vendor folder' {
        $null = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64' -Silent
        $script:seen[0].Flags | Should -BeExactly '-mod=mod'
        $script:seen[0].Proxy | Should -BeExactly 'off'
    }

    It 'leaves the session environment as it found it' {
        $before = $env:GOOS
        $null = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64' -Silent
        $env:GOOS | Should -Be $before
    }

    It 'lists the binaries with their SHA-256 in binaries.json, sorted, LF, no BOM' {
        $null = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64', 'darwin/arm64' -Silent
        $bytes = [System.IO.File]::ReadAllBytes((Join-Path $script:out 'binaries.json'))
        $bytes[0] | Should -Not -Be 0xEF
        $text = [System.Text.Encoding]::UTF8.GetString($bytes)
        $text | Should -Not -Match "`r"
        $hash = { param($Path) [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.IO.File]::ReadAllBytes((Join-Path $script:out $Path)))).ToLowerInvariant() }
        $text | Should -BeExactly ("[`n  {`"path`":`"darwin-arm64/widget`",`"sha256`":`"$(& $hash 'darwin-arm64/widget')`"},`n" +
            "  {`"path`":`"linux-amd64/widget`",`"sha256`":`"$(& $hash 'linux-amd64/widget')`"}`n]`n")
    }

    It 'gives identical bytes on a second export' {
        $first = Join-Path $script:out 'first'
        $second = Join-Path $script:out 'second'
        $null = Export-GoModule -Module 'go/widget' -Destination $first -Platform 'linux/amd64', 'windows/amd64' -Silent
        $null = Export-GoModule -Module 'go/widget' -Destination $second -Platform 'windows/amd64', 'linux/amd64' -Silent
        foreach ($file in 'binaries.json', 'linux-amd64/widget', 'windows-amd64/widget.exe') {
            [System.IO.File]::ReadAllBytes((Join-Path $first $file)) | Should -Be ([System.IO.File]::ReadAllBytes((Join-Path $second $file)))
        }
    }

    It 'returns the module, the destination, the platform count and the binary paths' {
        $result = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64', 'darwin/arm64' -Silent
        $result.Module | Should -BeExactly 'go/widget'
        $result.Destination | Should -BeExactly $script:out
        $result.Platforms | Should -Be 2
        $result.Binaries | Should -Be @('darwin-arm64/widget', 'linux-amd64/widget')
    }

    It 'takes the module as an absolute path under the repository' {
        $result = Export-GoModule -Module $script:module -Destination $script:out -Platform 'linux/amd64' -Silent
        $result.Module | Should -BeExactly 'go/widget'
    }

    It 'builds the host platform alone when no platform is given' {
        $result = Export-GoModule -Module 'go/widget' -Destination $script:out -Silent
        $result.Platforms | Should -Be 1
        $script:seen.Count | Should -Be 1
    }

    It 'rejects a platform that is not os and arch' {
        { Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux' -Silent } | Should -Throw
    }

    It 'throws with Install-Go when no managed go is found, before building' {
        $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('go', $null, 'none', $null, '1.27', $false, 1, 0, 'Agent')
        { Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64' -Silent } |
            Should -Throw '*no managed go found*Run Install-Go*'
        $script:seen.Count | Should -Be 0
    }

    It 'throws with Install-Go when the go found misses the pin' {
        $script:probe = [Catzc.Base.Execution.ExecutableProbe]::new('go', $script:goPath, 'path', '1.22.5', '1.27', $false, 1, 3, 'Agent')
        { Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64' -Silent } |
            Should -Throw "*reports version '1.22.5', but tools.yml pins '1.27'. Run Install-Go*"
    }

    It 'throws the build output when go fails' {
        $script:buildExit = 2
        { Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64' -Silent } |
            Should -Throw '*go build failed for linux/amd64*exit 2*build broke*'
    }

    It 'says what it packaged unless silent' {
        $null = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Languages -Times 1 -Exactly
    }

    It 'says nothing when silent' {
        $null = Export-GoModule -Module 'go/widget' -Destination $script:out -Platform 'linux/amd64' -Silent
        Should -Invoke Write-Message -ModuleName Catzc.Base.Languages -Times 0 -Exactly
    }
}
