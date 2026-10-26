Describe 'Assert-DotnetOffline' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:cleared = @'
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
  </packageSources>
  <auditSources>
    <clear />
  </auditSources>
</configuration>
'@
        # A repository with the generated root config and one project two folders down.
        function New-WidgetRepository {
            param([string] $Config = $script:cleared, [switch] $NoConfig)
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N').Substring(0, 8))
            $project = Join-Path $root 'gadgets/widget/widget.csproj'
            [System.IO.Directory]::CreateDirectory((Split-Path $project)) | Out-Null
            [System.IO.File]::WriteAllText($project, '<Project />')
            if (-not $NoConfig) {
                [System.IO.File]::WriteAllText((Join-Path $root 'nuget.config'), $Config)
            }
            [pscustomobject]@{ Root = $root; Project = $project }
        }
    }

    It 'passes a project under a root config that clears every source' {
        $repo = New-WidgetRepository
        { Assert-DotnetOffline $repo.Project -RepositoryRoot $repo.Root } | Should -Not -Throw
        { Assert-DotnetOffline 'gadgets/widget' -RepositoryRoot $repo.Root } |
            Should -Not -Throw -Because 'a folder or a repository-relative path is read the same'
    }

    It 'stops the call when the root config is missing' {
        $repo = New-WidgetRepository -NoConfig
        { Assert-DotnetOffline $repo.Project -RepositoryRoot $repo.Root } | Should -Throw '*nuget.config is missing*'
    }

    It 'stops the call when the root config is empty or not XML' {
        $repo = New-WidgetRepository -Config ''
        { Assert-DotnetOffline $repo.Project -RepositoryRoot $repo.Root } | Should -Throw '*is not readable XML*'
    }

    It 'stops the call when a package source is visible (<section>)' -ForEach @(
        @{ section = 'packageSources' }
        @{ section = 'auditSources' }
    ) {
        $config = $script:cleared -replace "(<$section>\s*<clear />)", "`$1`n    <add key=`"gizmo`" value=`"https://gizmo.example/v3/index.json`" />"
        $repo = New-WidgetRepository -Config $config
        { Assert-DotnetOffline $repo.Project -RepositoryRoot $repo.Root } |
            Should -Throw "*does not clear its $section*"
    }

    It 'stops the call when a section does not open with clear' {
        $repo = New-WidgetRepository -Config ($script:cleared -replace '(?s)<auditSources>.*?</auditSources>',
            '<auditSources />')
        { Assert-DotnetOffline $repo.Project -RepositoryRoot $repo.Root } |
            Should -Throw '*does not clear its auditSources*'
    }

    It 'stops the call when a stray nuget.config sits between the project and the root' {
        $repo = New-WidgetRepository
        $stray = Join-Path $repo.Root 'gadgets/NuGet.Config'
        [System.IO.File]::WriteAllText($stray, '<configuration />')
        { Assert-DotnetOffline $repo.Project -RepositoryRoot $repo.Root } | Should -Throw '*sits between*Remove it*'
    }

    It 'leaves a nuget.config off the project''s path alone, since NuGet never reads it for that project' {
        $repo = New-WidgetRepository
        [System.IO.Directory]::CreateDirectory((Join-Path $repo.Root 'gizmos')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $repo.Root 'gizmos/nuget.config'), '<configuration />')
        { Assert-DotnetOffline $repo.Project -RepositoryRoot $repo.Root } | Should -Not -Throw
    }

    It 'refuses a path outside the repository' {
        $repo = New-WidgetRepository
        { Assert-DotnetOffline (Join-Path $TestDrive 'elsewhere/gadget.csproj') -RepositoryRoot $repo.Root } |
            Should -Throw '*outside the repository*'
    }
}
