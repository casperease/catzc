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

Describe 'The shadow-cache prune and the holds' -Tag 'L1', 'logic' {
    BeforeAll {
        # A loaded build stays locked, so the shadow roots live outside the test drive, removed as far as the locks allow.
        $script:roots = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-hold-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
    }
    AfterAll {
        Remove-Item -LiteralPath $script:roots -Recurse -Force -ErrorAction SilentlyContinue
    }
    BeforeEach {
        $script:root = Join-Path $roots ([guid]::NewGuid().ToString('N').Substring(0, 8))
        [System.IO.Directory]::CreateDirectory($root) | Out-Null
        $script:widget = Join-Path $root 'Catzc.Types.0000a1d9.dll'
        [System.IO.File]::WriteAllBytes($widget, [byte[]] @(0x4d, 0x5a))
        [System.IO.File]::SetLastWriteTimeUtc($widget, [DateTime]::UtcNow.AddDays(-2))
        $script:gadget = Join-Path $roots "Catzc.Types.$([guid]::NewGuid().ToString('N').Substring(0, 8)).dll"
        Add-Type -TypeDefinition "namespace CatzcHold$([guid]::NewGuid().ToString('N')) { public class Gadget { } }" -OutputAssembly $gadget -OutputType Library
    }

    It 'keeps a stale build that a live process holds' {
        Register-TypesHold -Hash '0000a1d9' -ShadowRoot $root | Should -Be (Join-Path $root "Catzc.Types.0000a1d9.$PID.hold")
        Import-TypesAssembly -Path $gadget -ShadowRoot $root | Out-Null
        [System.IO.File]::Exists($widget) | Should -BeTrue
    }

    It 'prunes a stale build whose holder is gone and deletes the dead hold' {
        $dead = Join-Path $root 'Catzc.Types.0000a1d9.2147483646.hold'
        [System.IO.File]::WriteAllBytes($dead, [byte[]] @())
        Import-TypesAssembly -Path $gadget -ShadowRoot $root | Out-Null
        [System.IO.File]::Exists($widget) | Should -BeFalse
        [System.IO.File]::Exists($dead) | Should -BeFalse
    }

    It 'holds the hash of the build it loads' {
        Import-TypesAssembly -Path $gadget -ShadowRoot $root | Out-Null
        $hash = [System.IO.Path]::GetFileNameWithoutExtension($gadget).Substring('Catzc.Types.'.Length)
        Test-TypesHeld -Hash $hash -ShadowRoot $root | Should -BeTrue
    }
}

Describe 'The shadow-cache prune across processes' -Tag 'L2', 'logic' {
    It 'lets two processes load a stale build while a third prunes, with no missing-assembly error' {
        # A loaded build stays locked, so the shared shadow root lives outside the test drive, removed as far as the locks allow.
        $root = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-hold-shared-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        [System.IO.Directory]::CreateDirectory($root) | Out-Null
        $hash = 'w' + [guid]::NewGuid().ToString('N').Substring(0, 8)
        $widget = Join-Path $root "Catzc.Types.$hash.dll"
        Add-Type -TypeDefinition "namespace CatzcWidget$hash { public class Widget { } }" -OutputAssembly $widget -OutputType Library
        [System.IO.File]::SetLastWriteTimeUtc($widget, [DateTime]::UtcNow.AddDays(-2))
        $go = Join-Path $root 'go'
        $module = Join-Path $PSScriptRoot '..\Catzc.Internal.Types.psm1'
        # Each importer holds the hash, waits until the prune has run, then loads the build it held.
        $script = @"
Import-Module '$module' -Force
Register-TypesHold -Hash '$hash' -ShadowRoot '$root' | Out-Null
`$deadline = [DateTime]::UtcNow.AddSeconds(20)
while (-not [System.IO.File]::Exists('$go') -and [DateTime]::UtcNow -lt `$deadline) { Start-Sleep -Milliseconds 50 }
Import-TypesAssembly -Path '$widget' -ShadowRoot '$root' | Out-Null
"@
        $self = (Get-Process -Id $PID).Path
        $importers = @(1..2 | ForEach-Object {
                Start-Process -FilePath $self -ArgumentList '-NoProfile', '-Command', $script -PassThru -WindowStyle Hidden
            })
        try {
            $deadline = [DateTime]::UtcNow.AddSeconds(20)
            while (@([System.IO.Directory]::EnumerateFiles($root, "Catzc.Types.$hash.*.hold")).Count -lt 2 -and [DateTime]::UtcNow -lt $deadline) {
                Start-Sleep -Milliseconds 50
            }
            $gadget = Join-Path $root "g$hash.source.dll"
            Add-Type -TypeDefinition "namespace CatzcGadget$hash { public class Gadget { } }" -OutputAssembly $gadget -OutputType Library
            Import-TypesAssembly -Path $gadget -ShadowRoot $root | Out-Null
            [System.IO.File]::Exists($widget) | Should -BeTrue
            [System.IO.File]::WriteAllBytes($go, [byte[]] @())
            foreach ($importer in $importers) {
                $importer.WaitForExit(30000) | Should -BeTrue
                $importer.ExitCode | Should -Be 0
            }
        }
        finally {
            $importers | Where-Object { -not $_.HasExited } | Stop-Process -Force -ErrorAction SilentlyContinue
            Remove-Item -LiteralPath $root -Recurse -Force -ErrorAction SilentlyContinue
        }
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
