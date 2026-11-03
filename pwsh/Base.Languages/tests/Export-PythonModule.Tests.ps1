Describe 'Export-PythonModule' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($file in 'widget/app.py', 'widget/lib/helper.py', 'widget/uv.lock', 'widget/scratch.py', 'gadget/app.py') {
            $path = Join-Path $script:root $file
            $null = New-Item -ItemType Directory -Path (Split-Path $path) -Force
            [System.IO.File]::WriteAllBytes($path, [System.Text.Encoding]::UTF8.GetBytes("# $file`n"))
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages { 'widget/app.py', 'widget/lib/helper.py', 'widget/uv.lock', 'widget/tests/test_x.py' }
        Mock Get-Config -ModuleName Catzc.Base.Languages { [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name FolderOf -Value { 'tests' } -PassThru }
        Mock Write-Message -ModuleName Catzc.Base.Languages { }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Languages {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = 'uv-fixture'; Version = '0.11.0'; Required = '0.11' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages {
            $result = @{ ExitCode = 0; Output = ''; Full = '' }
            if ($Command -like '* cache dir') {
                $result.Output = 'cache-fixture'
            }
            if ($Command -like '* pip download *') {
                $match = [regex]::Match($Command, '--dest "([^"]+)"')
                foreach ($wheel in 'gizmo-2.0-py3-none-any.whl', 'doohickey-1.0-py3-none-any.whl') {
                    [System.IO.File]::WriteAllBytes([System.IO.Path]::Combine($match.Groups[1].Value, $wheel), [System.Text.Encoding]::UTF8.GetBytes("wheel $wheel"))
                }
            }
            [pscustomobject]$result
        }
        $script:out = Join-Path $TestDrive "out-$([guid]::NewGuid().ToString('N'))"
    }

    It 'copies every tracked file byte for byte, keeping the relative layout' {
        $null = Export-PythonModule -Module 'widget' -Destination $script:out -Silent
        foreach ($file in 'app.py', 'lib/helper.py', 'uv.lock') {
            [System.IO.File]::ReadAllBytes([System.IO.Path]::Combine($script:out, $file)) |
                Should -Be ([System.IO.File]::ReadAllBytes([System.IO.Path]::Combine($script:root, 'widget', $file)))
        }
    }

    It 'leaves an untracked file out of the package' {
        $null = Export-PythonModule -Module 'widget' -Destination $script:out -Silent
        Test-Path -LiteralPath ([System.IO.Path]::Combine($script:out, 'scratch.py')) | Should -BeFalse
    }

    It 'leaves a tracked test file out of the package and the count' {
        $result = Export-PythonModule -Module 'widget' -Destination $script:out -Silent
        Test-Path -LiteralPath ([System.IO.Path]::Combine($script:out, 'tests', 'test_x.py')) | Should -BeFalse
        $result.Files | Should -Be 3
    }

    It 'exports the locked wheels offline, never from a feed' {
        $null = Export-PythonModule -Module 'widget' -Destination $script:out -Silent
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Languages -ParameterFilter { $Command -like '* export --frozen --offline *' } -Times 1 -Exactly
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Languages -ParameterFilter {
            $Command -like '* run --offline --no-sync *pip download --no-index *--find-links "cache-fixture"*'
        } -Times 1 -Exactly
    }

    It 'writes the wheels into the wheels folder' {
        $null = Export-PythonModule -Module 'widget' -Destination $script:out -Silent
        @([System.IO.Directory]::GetFiles([System.IO.Path]::Combine($script:out, 'wheels')).ForEach({ [System.IO.Path]::GetFileName($_) }) | Sort-Object) |
            Should -Be @('doohickey-1.0-py3-none-any.whl', 'gizmo-2.0-py3-none-any.whl')
    }

    It 'records the sorted wheel names with their SHA-256 in wheels.json' {
        $null = Export-PythonModule -Module 'widget' -Destination $script:out -Silent
        $expected = foreach ($wheel in 'doohickey-1.0-py3-none-any.whl', 'gizmo-2.0-py3-none-any.whl') {
            $hash = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes("wheel $wheel"))).ToLowerInvariant()
            "  {`"name`":`"$wheel`",`"sha256`":`"$hash`"}"
        }
        $bytes = [System.IO.File]::ReadAllBytes([System.IO.Path]::Combine($script:out, 'wheels.json'))
        [System.Text.Encoding]::UTF8.GetString($bytes) | Should -BeExactly ("[`n" + ($expected -join ",`n") + "`n]`n")
        $bytes[0] | Should -Be ([byte][char] '[')
    }

    It 'returns the module, the destination and the counts' {
        $result = Export-PythonModule -Module 'widget' -Destination $script:out -Silent
        $result.Module | Should -BeExactly 'widget'
        $result.Destination | Should -BeExactly $script:out
        $result.Files | Should -Be 3
        $result.Wheels | Should -Be 2
    }

    It 'takes the module as an absolute path under the repository' {
        $result = Export-PythonModule -Module (Join-Path $script:root 'widget') -Destination $script:out -Silent
        $result.Module | Should -BeExactly 'widget'
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $Path -ceq 'widget' }
    }

    It 'gives identical bytes on a second export' {
        $first = Join-Path $script:out 'first'
        $second = Join-Path $script:out 'second'
        $null = Export-PythonModule -Module 'widget' -Destination $first -Silent
        $null = Export-PythonModule -Module 'widget' -Destination $second -Silent
        foreach ($file in 'app.py', 'lib/helper.py', 'uv.lock', 'wheels.json', 'wheels/gizmo-2.0-py3-none-any.whl') {
            [System.IO.File]::ReadAllBytes([System.IO.Path]::Combine($first, $file)) |
                Should -Be ([System.IO.File]::ReadAllBytes([System.IO.Path]::Combine($second, $file)))
        }
    }

    It 'ships source only, with zero wheels, when the module holds no uv.lock' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages { 'gadget/app.py' }
        $result = Export-PythonModule -Module 'gadget' -Destination $script:out -Silent
        $result.Files | Should -Be 1
        $result.Wheels | Should -Be 0
        Test-Path -LiteralPath ([System.IO.Path]::Combine($script:out, 'wheels')) | Should -BeFalse
        Test-Path -LiteralPath ([System.IO.Path]::Combine($script:out, 'wheels.json')) | Should -BeFalse
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Languages -Times 0 -Exactly
    }

    It 'throws naming the module and the command that installs uv when uv is missing' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.Languages {
            [pscustomobject]@{ Found = $false; VersionOk = $false; Path = $null; Version = $null; Required = '0.11' }
        }
        { Export-PythonModule -Module 'widget' -Destination $script:out -Silent } | Should -Throw '*widget*Install-Uv*'
    }

    It 'throws naming the module and the cache-warming command when a locked wheel is not cached' {
        Mock Invoke-Executable -ModuleName Catzc.Base.Languages -ParameterFilter { $Command -like '* pip download *' } {
            [pscustomobject]@{ ExitCode = 1; Output = ''; Full = 'No matching distribution found for gizmo==2.0' }
        }
        { Export-PythonModule -Module 'widget' -Destination $script:out -Silent } | Should -Throw '*widget*Install-PythonWorkspace*gizmo*'
    }

    It 'says what it packaged unless silent' {
        $null = Export-PythonModule -Module 'widget' -Destination $script:out
        Should -Invoke Write-Message -ModuleName Catzc.Base.Languages -Times 1 -Exactly
    }

    It 'says nothing when silent' {
        $null = Export-PythonModule -Module 'widget' -Destination $script:out -Silent
        Should -Invoke Write-Message -ModuleName Catzc.Base.Languages -Times 0 -Exactly
    }
}
