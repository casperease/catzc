Describe 'Catzc.Base.Slides.DrawioKit' -Tag 'L0', 'logic' {
    It 'joins the renderer, the declaration tool and the drawio.yml onto the kit folder, full paths' {
        $root = Join-Path $TestDrive 'widget-repo'
        $kit = [Catzc.Base.Slides.DrawioKit]::new($root, 'tools/widget_kit')
        $folder = [System.IO.Path]::GetFullPath((Join-Path $root 'tools/widget_kit'))
        $kit.Folder | Should -Be $folder
        $kit.Renderer | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $folder 'drawio_forward.py')))
        $kit.Declaration | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $folder 'declaration.py')))
        $kit.Config | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $folder 'configs/drawio.yml')))
    }

    It 'rejects an empty repository root or kit' {
        { [Catzc.Base.Slides.DrawioKit]::new('', 'tools/widget_kit') } | Should -Throw '*repositoryRoot must not be empty*'
        { [Catzc.Base.Slides.DrawioKit]::new($TestDrive, '') } | Should -Throw '*kit must not be empty*'
    }
}
