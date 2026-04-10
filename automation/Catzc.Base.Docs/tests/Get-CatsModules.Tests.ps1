Describe 'Get-CatsModules' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:automationRoot = Join-Path $TestDrive 'automation'
        $reader = Join-Path $script:automationRoot 'Catzc.Sample.Reader'
        $writer = Join-Path $script:automationRoot 'Catzc.Sample.Writer'
        $hidden = Join-Path $script:automationRoot '.hidden'
        [System.IO.Directory]::CreateDirectory((Join-Path $reader 'private')) | Out-Null
        [System.IO.Directory]::CreateDirectory($writer) | Out-Null
        [System.IO.Directory]::CreateDirectory($hidden) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $reader 'Get-Report.ps1'), '# fixture')
        [System.IO.File]::WriteAllText((Join-Path $reader 'Set-Report.ps1'), '# fixture')
        [System.IO.File]::WriteAllText((Join-Path $reader 'private/Get-Helper.ps1'), '# fixture')
        [System.IO.File]::WriteAllText((Join-Path $writer 'Invoke-Backup.ps1'), '# fixture')
        [System.IO.File]::WriteAllText((Join-Path $hidden 'Get-Ignored.ps1'), '# fixture')
    }

    It 'lists the non-dot modules with their root public functions, sorted' {
        $modules = & (Get-Module Catzc.Base.Docs) { param($p) Get-CatsModules -AutomationRoot $p } $script:automationRoot
        @($modules).Count | Should -Be 2
        $reader = $modules | Where-Object { $_.Module -eq 'Catzc.Sample.Reader' }
        $reader.Functions | Should -Be @('Get-Report', 'Set-Report')
    }

    It 'excludes private/ helpers and dot-prefixed infrastructure folders' {
        $modules = & (Get-Module Catzc.Base.Docs) { param($p) Get-CatsModules -AutomationRoot $p } $script:automationRoot
        $modules.Module | Should -Not -Contain '.hidden'
        $reader = $modules | Where-Object { $_.Module -eq 'Catzc.Sample.Reader' }
        $reader.Functions | Should -Not -Contain 'Get-Helper'
    }
}
