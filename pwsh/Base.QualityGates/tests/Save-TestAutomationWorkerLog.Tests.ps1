Describe 'Save-TestAutomationWorkerLog' -Tag 'L0', 'logic' {
    It 'writes stdout, then stderr under its marker, without a byte-order mark' {
        $path = Join-Path $TestDrive 'worker-shard-2.log'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $path } {
            param($Path)
            Save-TestAutomationWorkerLog -Path $Path -StandardOutput "widget out`n" -StandardError 'gadget err'
        }
        [System.IO.File]::ReadAllText($path) | Should -Be "widget out`n`n--- stderr ---`ngadget err"
        [System.IO.File]::ReadAllBytes($path)[0] | Should -Be ([byte][char] 'w')
    }

    It 'writes stdout alone when stderr is empty or null, and an empty file when both are' {
        $quiet = Join-Path $TestDrive 'quiet.log'
        $empty = Join-Path $TestDrive 'empty.log'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Quiet = $quiet; Empty = $empty } {
            param($Quiet, $Empty)
            Save-TestAutomationWorkerLog -Path $Quiet -StandardOutput 'widget out' -StandardError $null
            Save-TestAutomationWorkerLog -Path $Empty
        }
        [System.IO.File]::ReadAllText($quiet) | Should -Be 'widget out'
        [System.IO.File]::ReadAllText($empty) | Should -Be ''
    }
}
