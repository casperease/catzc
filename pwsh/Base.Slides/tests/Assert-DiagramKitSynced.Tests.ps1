Describe 'Assert-DiagramKitSynced' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'widgets') -Force
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Slides { $script:root }
        Mock Get-Config -ModuleName Catzc.Base.Slides {
            $config = [pscustomobject]@{}
            $config | Add-Member -MemberType ScriptMethod -Name ResolveRoot -Value { 'widgets' }
            $config
        }
    }

    It 'throws naming Install-PythonWorkspace when the environment is not synced' {
        { & (Get-Module Catzc.Base.Slides) { Assert-DiagramKitSynced } } |
            Should -Throw '*widgets/.venv is not synced*Install-PythonWorkspace*'
    }

    It 'passes once the environment is synced' {
        $null = New-Item -ItemType File -Path (Join-Path $script:root 'widgets/.venv/pyvenv.cfg') -Force
        { & (Get-Module Catzc.Base.Slides) { Assert-DiagramKitSynced } } | Should -Not -Throw
    }
}
