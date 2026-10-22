Describe 'GzipText' -Tag 'L0', 'logic' {
    It 'round-trips UTF-8 text through compress/decompress' {
        $text = "the quick brown fox`n" + "ÆØÅ`n" + "rule collection group`n"
        $bytes = [System.Text.UTF8Encoding]::new($false).GetBytes($text)
        $compressed = [Catzc.Base.QualityGates.GzipText]::Compress($bytes)
        $restored = [System.Text.Encoding]::UTF8.GetString([Catzc.Base.QualityGates.GzipText]::Decompress($compressed))
        $restored | Should -BeExactly $text
    }

    It 'compresses a repetitive payload smaller than the source' {
        $bytes = [System.Text.UTF8Encoding]::new($false).GetBytes(('word' * 5000))
        $compressed = [Catzc.Base.QualityGates.GzipText]::Compress($bytes)
        $compressed.Length | Should -BeLessThan $bytes.Length
    }

    It 'is deterministic — the same input yields the same bytes' {
        $bytes = [System.Text.UTF8Encoding]::new($false).GetBytes("deterministic`n" + "payload`n")
        $a = [Catzc.Base.QualityGates.GzipText]::Compress($bytes)
        $b = [Catzc.Base.QualityGates.GzipText]::Compress($bytes)
        [System.Convert]::ToBase64String($a) | Should -BeExactly ([System.Convert]::ToBase64String($b))
    }
}
