Describe 'Get-FileMetaEngineStamp' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:gates = Join-Path $TestDrive "gates-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        $script:languages = Join-Path $TestDrive "languages-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        $files = [ordered]@{
            "$script:gates/configs/file-meta.yml"              = "kinds: {}`n"
            "$script:languages/configs/file-carriers.yml"      = "carriers: {}`n"
            "$script:gates/Format-FileMeta.ps1"                = "function Format-FileMeta {}`n"
            "$script:gates/Get-FileMetaFact.ps1"               = "function Get-FileMetaFact {}`n"
            "$script:gates/private/Invoke-FileMetaEngine.ps1"  = "function Invoke-FileMetaEngine {}`n"
            "$script:gates/private/Get-WidgetFileMetaFact.ps1" = "function Get-WidgetFileMetaFact {}`n"
            "$script:gates/types/FileMetaConfig.cs"            = "class FileMetaConfig {}`n"
        }
        foreach ($file in $files.Keys) {
            [System.IO.Directory]::CreateDirectory((Split-Path $file -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($file, $files[$file])
        }
        $script:stamp = {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ G = $script:gates; L = $script:languages } {
                param($G, $L)
                Get-FileMetaEngineStamp -QualityGatesBase $G -LanguagesBase $L
            }
        }
    }

    It 'changes when file-meta.yml changes, so a changed registry invalidates every file''s memo' {
        $before = & $script:stamp
        [System.IO.File]::WriteAllText("$script:gates/configs/file-meta.yml", "kinds: { gadget: {} }`n")
        & $script:stamp | Should -Not -Be $before
    }

    It 'changes when the carrier registry, the engine or a fact processor changes, or a processor is added' {
        $before = & $script:stamp
        [System.IO.File]::WriteAllText("$script:languages/configs/file-carriers.yml", "carriers: { widget: {} }`n")
        $carrier = & $script:stamp
        $carrier | Should -Not -Be $before
        [System.IO.File]::WriteAllText("$script:gates/private/Invoke-FileMetaEngine.ps1", "function Invoke-FileMetaEngine { 'gadget' }`n")
        $engine = & $script:stamp
        $engine | Should -Not -Be $carrier
        [System.IO.File]::WriteAllText("$script:gates/private/Get-GadgetFileMetaFact.ps1", "function Get-GadgetFileMetaFact {}`n")
        & $script:stamp | Should -Not -Be $engine
    }

    It 'stays the same while nothing it reads changes' {
        & $script:stamp | Should -Be (& $script:stamp)
    }
}
