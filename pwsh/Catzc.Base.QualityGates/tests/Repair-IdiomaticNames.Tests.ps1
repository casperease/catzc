Describe 'Repair-IdiomaticNames' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $files = [ordered]@{
            'python/Widget.Gadget/tool.py' = "print('widget')`n"
            'python/widget/GadgetThing.py' = "print('gadget')`n"
            'python/widget/snake_case.py'  = "print('fine')`n"
            'docs/widget.md'               = "See python/Widget.Gadget/tool.py and python/widget/GadgetThing.py.`n"
        }
        foreach ($path in $files.Keys) {
            $full = Join-Path $script:root $path
            $null = New-Item -ItemType Directory -Path (Split-Path $full) -Force
            [System.IO.File]::WriteAllText($full, $files[$path])
        }
        $script:tracked = @($files.Keys)
        Mock Assert-SourceTree { } -ModuleName Catzc.Base.QualityGates
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.QualityGates
        Mock Get-GitTrackedPath { $script:tracked } -ModuleName Catzc.Base.QualityGates
        Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
    }

    It 'plans each misnamed file, then each misnamed folder, with the idiomatic target and the files that name the old path' {
        $plan = @(Repair-IdiomaticNames -DryRun)
        @($plan | ForEach-Object { "$($_.Kind) $($_.Path) -> $($_.Target)" }) | Should -Be @(
            'file python/widget/GadgetThing.py -> python/widget/gadget_thing.py'
            'folder python/Widget.Gadget -> python/widget_gadget'
        )
        $plan[0].NamedBy | Should -Be @('docs/widget.md')
        $plan[1].NamedBy | Should -Be @('docs/widget.md')
        @($plan | Where-Object Moved) | Should -BeNullOrEmpty
    }

    It 'moves nothing under -DryRun' {
        $null = Repair-IdiomaticNames -DryRun
        Join-Path $script:root 'python/Widget.Gadget/tool.py' | Should -Exist
        Join-Path $script:root 'python/widget/GadgetThing.py' | Should -Exist
    }

    It 'moves each folder and file on disk and edits no file''s text' {
        $null = Repair-IdiomaticNames
        Join-Path $script:root 'python/widget_gadget/tool.py' | Should -Exist
        Join-Path $script:root 'python/widget/gadget_thing.py' | Should -Exist
        Join-Path $script:root 'python/Widget.Gadget' | Should -Not -Exist
        [System.IO.File]::ReadAllText((Join-Path $script:root 'docs/widget.md')) | Should -Match 'python/Widget\.Gadget/tool\.py'
    }

    It 'lands a case-only rename' {
        $script:tracked = @('python/Gizmo/tool.py')
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root 'python/Gizmo') -Force
        [System.IO.File]::WriteAllText((Join-Path $script:root 'python/Gizmo/tool.py'), "print(1)`n")
        $null = Repair-IdiomaticNames
        $folders = @([System.IO.Directory]::GetDirectories((Join-Path $script:root 'python')) | ForEach-Object { [System.IO.Path]::GetFileName($_) })
        # Case-sensitive: Should -Contain ignores case, and this test is about case.
        $folders -ccontains 'gizmo' | Should -BeTrue
        $folders -ccontains 'Gizmo' | Should -BeFalse
    }

    It 'leaves a name its case cannot render to a person, moving nothing' {
        $widgetFile = (Get-CatzcModulesFolder) + '/Widget/lower case.ps1'
        $script:tracked = @($widgetFile)
        $null = New-Item -ItemType Directory -Path (Join-Path $script:root ((Get-CatzcModulesFolder) + '/Widget')) -Force
        [System.IO.File]::WriteAllText((Join-Path $script:root $widgetFile), "1`n")
        $plan = @(Repair-IdiomaticNames | Where-Object Kind -eq 'file')
        $plan[0].Target | Should -BeNullOrEmpty
        $plan[0].Moved | Should -BeFalse
        Join-Path $script:root $widgetFile | Should -Exist
    }
}
