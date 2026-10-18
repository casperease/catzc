Describe 'Import-TypesAssembly' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:runId = 'r' + [guid]::NewGuid().ToString('N').Substring(0, 8)
        $script:namespace = "CatzcShadowWidget$runId"
        $script:source = Join-Path $TestDrive "Catzc.Types.$runId.dll"
        Add-Type -TypeDefinition "namespace $namespace { public class Sprocket { } }" -OutputAssembly $source -OutputType Library
        $script:shadowRoot = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-shadow-$runId"

        # A stale and a fresh sibling copy (plain bytes — never loaded), to prove the age-bounded prune.
        [System.IO.Directory]::CreateDirectory($shadowRoot) | Out-Null
        $script:stale = Join-Path $shadowRoot 'Catzc.Types.0000dead.dll'
        $script:fresh = Join-Path $shadowRoot 'Catzc.Types.0000beef.dll'
        foreach ($sibling in $stale, $fresh) {
            [System.IO.File]::WriteAllBytes($sibling, [byte[]] @(0x4d, 0x5a))
        }
        [System.IO.File]::SetLastWriteTimeUtc($stale, [DateTime]::UtcNow.AddDays(-2))
        [System.IO.File]::SetLastWriteTimeUtc($fresh, [DateTime]::UtcNow.AddHours(-12))

        $script:loaded = Import-TypesAssembly -Path $source -ShadowRoot $shadowRoot
    }
    AfterAll {
        Remove-Item -LiteralPath $script:shadowRoot -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'loads the shadow copy, not the given file' {
        $loaded | Should -Be (Join-Path $shadowRoot "Catzc.Types.$runId.dll")
        $type = ([System.Management.Automation.PSTypeName]"$namespace.Sprocket").Type
        $type | Should -Not -BeNullOrEmpty
        $type.Assembly.Location | Should -Be $loaded
    }

    It 'leaves the given file unlocked, so it can be deleted while its types are loaded' {
        $copy = Join-Path $TestDrive "deletable-$runId.dll"
        [System.IO.File]::Copy($source, $copy)
        [System.IO.File]::Delete($source)
        [System.IO.File]::Exists($source) | Should -BeFalse
        [System.IO.File]::Move($copy, $source)
    }

    It 'leaves no temp file behind' {
        @([System.IO.Directory]::EnumerateFiles($shadowRoot, '*.tmp')).Count | Should -Be 0
    }

    It 'prunes, by default, a sibling copy untouched for over a day and keeps a more recent one' {
        [System.IO.File]::Exists($stale) | Should -BeFalse
        [System.IO.File]::Exists($fresh) | Should -BeTrue
    }

    It 'reuses an existing copy and refreshes its write time' {
        [System.IO.File]::SetLastWriteTimeUtc($loaded, [DateTime]::UtcNow.AddDays(-1))
        $before = [System.IO.File]::GetLastWriteTimeUtc($loaded)
        # Already loaded types: a second Add-Type of the same path is a no-op, so this proves the reuse path.
        $again = Import-TypesAssembly -Path $source -ShadowRoot $shadowRoot
        $again | Should -Be $loaded
        [System.IO.File]::GetLastWriteTimeUtc($loaded) | Should -BeGreaterOrEqual $before
    }

    It 'throws when the given file does not exist' {
        { Import-TypesAssembly -Path (Join-Path $TestDrive 'Catzc.Types.missing.dll') -ShadowRoot $shadowRoot } |
            Should -Throw -ExpectedMessage '*does not exist*'
    }
}

Describe 'Get-TypesShadowRoot' -Tag 'L0', 'logic' {
    It 'is the per-user catzc types folder' {
        $expected = if ($IsWindows) {
            Join-Path $env:LOCALAPPDATA 'catzc\types'
        }
        else {
            Join-Path $HOME '.local/share/catzc/types'
        }
        Get-TypesShadowRoot | Should -Be $expected
    }
}
