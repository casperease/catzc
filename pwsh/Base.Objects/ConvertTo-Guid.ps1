function ConvertTo-Guid {
    [CmdletBinding()]
    [OutputType([guid])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Sentence
    )

    Assert-NotNullOrWhitespace $Sentence

    [Catzc.Base.Objects.SentenceGuid]::Convert($Sentence)
}
