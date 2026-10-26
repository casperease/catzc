# One streaming pass must report the line count and the widest line with its number, the same lines the gate and the
# linters see.
Describe 'Measure-FileShape' -Tag 'L0', 'logic' {
    It 'counts every line and names the widest one' {
        $file = Join-Path $TestDrive 'widget.txt'
        [System.IO.File]::WriteAllText($file, "ab`nabcdef`r`nabc`n")
        $shape = Measure-FileShape -Path $file
        $shape.lines | Should -Be 3
        $shape.width | Should -Be 6
        $shape.widest_line | Should -Be 2
    }

    It 'measures an empty file as no lines' {
        $file = Join-Path $TestDrive 'gadget.txt'
        [System.IO.File]::WriteAllText($file, '')
        (Measure-FileShape -Path $file).lines | Should -Be 0
    }

    It 'takes paths from the pipeline' {
        $file = Join-Path $TestDrive 'widget.txt'
        [System.IO.File]::WriteAllText($file, "a`n")
        @(Get-Item $file | Measure-FileShape).Count | Should -Be 1
    }
}
