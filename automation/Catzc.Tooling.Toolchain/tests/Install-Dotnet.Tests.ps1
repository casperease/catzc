Describe 'Install-Dotnet' -Tag 'L0' {
    # The vendored .NET install scripts ship with this module (Install-Dotnet runs them); guard their presence.
    Context 'asset dependencies' -Tag 'integrity' {
        It 'dotnet-install.ps1 exists' {
            Join-Path $PSScriptRoot '../assets/scripts/dotnet-install.ps1' | Should -Exist
        }

        It 'dotnet-install.sh exists' {
            Join-Path $PSScriptRoot '../assets/scripts/dotnet-install.sh' | Should -Exist
        }
    }
}
