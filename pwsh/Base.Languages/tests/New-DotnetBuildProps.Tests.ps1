Describe 'New-DotnetBuildProps' -Tag 'L0', 'logic' {
    It 'renders the target framework of the SDK version <version> and turns NuGet audit off' -ForEach @(
        @{ version = '10.0'; framework = 'net10.0' }
        @{ version = '11.0'; framework = 'net11.0' }
    ) {
        $script:pin = $version
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.dotnet.version' } { $script:pin }
        [xml] $document = New-DotnetBuildProps
        $document.Project.PropertyGroup.TargetFramework | Should -Be $framework
        $document.Project.PropertyGroup.NuGetAudit | Should -Be 'false'
    }

    It 'refuses a version that names no target framework (<version>)' -ForEach @(
        @{ version = '10' }
        @{ version = '10.0.201' }
        @{ version = '' }
    ) {
        $script:pin = $version
        Mock Get-ConfigValue -ModuleName Catzc.Base.Languages -ParameterFilter { $Address -eq 'global.tools.dotnet.version' } { $script:pin }
        { New-DotnetBuildProps } | Should -Throw '*names no target framework*'
    }
}
