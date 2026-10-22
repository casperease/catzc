# cspell:ignore AGQA AHQA  -- pieces of the base64 encoded-command fixture, data
Describe 'Test-IsInteractiveHost' -Tag 'L0', 'logic' {
    It 'reads a host started with no command, or with options only, as interactive' -ForEach @(
        @{ CommandLine = @('pwsh') }
        @{ CommandLine = @('pwsh', '-NoLogo') }
        @{ CommandLine = @('pwsh', '-NoProfile', '-ExecutionPolicy', 'Bypass') }
    ) {
        Test-IsInteractiveHost -CommandLine $CommandLine | Should -BeTrue
    }

    It 'reads a host that runs a script or a command and exits as not interactive' -ForEach @(
        @{ CommandLine = @('pwsh', '-NoProfile', '-NonInteractive', '-File', 'C:/repo/importer.ps1') }
        @{ CommandLine = @('pwsh', '-File', 'C:/repo/importer.ps1') }
        @{ CommandLine = @('pwsh', '-f', 'C:/repo/importer.ps1') }
        @{ CommandLine = @('pwsh', '-NoProfile', '-Command', '. ./importer.ps1; Test-Widget') }
        @{ CommandLine = @('pwsh', '-c', 'Get-Gadget') }
        @{ CommandLine = @('pwsh', '-EncodedCommand', 'ZwBhAGQAZwBlAHQA') }
        @{ CommandLine = @('pwsh', '-ec', 'ZwBhAGQAZwBlAHQA') }
        @{ CommandLine = @('pwsh', '-NonInteractive') }
    ) {
        Test-IsInteractiveHost -CommandLine $CommandLine | Should -BeFalse
    }

    It 'reads a host that -NoExit keeps open after its command as interactive' {
        Test-IsInteractiveHost -CommandLine @('pwsh', '-NoProfile', '-NonInteractive', '-NoExit', '-Command', 'Import-Module Widget') | Should -BeTrue
    }

    It 'leaves the arguments after the script to the script' {
        Test-IsInteractiveHost -CommandLine @('pwsh', '-File', 'C:/repo/widget.ps1', '-NoExit') | Should -BeFalse
    }
}
