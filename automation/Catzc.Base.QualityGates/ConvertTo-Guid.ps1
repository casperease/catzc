<#
.SYNOPSIS
    Converts a sentence into a valid GUID whose hex digits best-effort spell the sentence.
.DESCRIPTION
    The mint for readable placeholder GUIDs: each character is mapped to its closest hex look-alike
    (s→5, o→0, i/l→1, z→2, g→6, t→7, q→9; a–f and digits pass through; everything else is dropped), the
    result is padded with zeros to 32 hex digits, truncated past 32, and formatted as a canonical lowercase
    GUID. The conversion is deterministic and total — every non-empty input yields a valid [guid], down to
    the all-zeros GUID for an input with no mappable characters.

    Run by a human or an LLM to mint entries for the managed-GUID registry
    (Catzc.Base.QualityGates/configs/guids.yml) — never called by production code. The engine is the native
    type Catzc.Base.QualityGates.SentenceGuid.
.PARAMETER Sentence
    The sentence to convert. Case-insensitive; must be non-empty and non-whitespace.
.OUTPUTS
    [guid] The minted GUID.
.EXAMPLE
    ConvertTo-Guid 'sample test data'
    Returns 5a1e7e57-da7a-0000-0000-000000000000.
.EXAMPLE
    ConvertTo-Guid 'alpha test tenant'
    Returns a1a7e577-ea70-0000-0000-000000000000.
#>
function ConvertTo-Guid {
    [CmdletBinding()]
    [OutputType([guid])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Sentence
    )

    Assert-NotNullOrWhitespace $Sentence

    [Catzc.Base.QualityGates.SentenceGuid]::Convert($Sentence)
}
