<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-file-limits/private/Get-StringOverflowLine.ps1.md"
  header: "generated"
---
#>

function Get-StringOverflowLine {
    [CmdletBinding()]
    [OutputType([int[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [int] $Width,

        [string] $Language
    )

    # The spans of every one-line string literal as (line, first column, last column), 1-based, from the language's own
    # tokenizer.
    $spans = [System.Collections.Generic.List[int[]]]::new()
    switch ($Language) {
        'powershell' {
            $tokens = $null
            $errors = $null
            $null = [System.Management.Automation.Language.Parser]::ParseInput($Text, [ref] $tokens, [ref] $errors)
            foreach ($token in $tokens) {
                $isString = $token.Kind -in 'StringLiteral', 'StringExpandable', 'HereStringLiteral', 'HereStringExpandable'
                if ($isString -and $token.Extent.StartLineNumber -eq $token.Extent.EndLineNumber) {
                    $spans.Add([int[]] @($token.Extent.StartLineNumber, $token.Extent.StartColumnNumber,
                        ($token.Extent.EndColumnNumber - 1)))
                }
            }
        }
        'yaml' {
            $scanner = [YamlDotNet.Core.Scanner]::new([System.IO.StringReader]::new($Text))
            try {
                while ($scanner.MoveNext()) {
                    $token = $scanner.Current
                    if ($token -is [YamlDotNet.Core.Tokens.Scalar] -and $token.Start.Line -eq $token.End.Line) {
                        $spans.Add([int[]] @([int] $token.Start.Line, [int] $token.Start.Column,
                            ([int] $token.End.Column - 1)))
                    }
                }
            }
            catch [YamlDotNet.Core.YamlException] {
                # A file the scanner cannot read exempts nothing: its long lines stay findings.
                return , [int[]] @()
            }
        }
        'xml' {
            # The reader gives an attribute's line and the column of its name; the value runs from its opening quote to
            # the matching one.
            $sourceLines = $Text -split "`r?`n"
            $settings = [System.Xml.XmlReaderSettings]::new()
            $settings.DtdProcessing = [System.Xml.DtdProcessing]::Ignore
            $reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($Text), $settings)
            try {
                while ($reader.Read()) {
                    if ($reader.NodeType -ne [System.Xml.XmlNodeType]::Element -or -not $reader.HasAttributes) {
                        continue
                    }
                    while ($reader.MoveToNextAttribute()) {
                        $info = [System.Xml.IXmlLineInfo] $reader
                        $line = $sourceLines[$info.LineNumber - 1]
                        $equals = $line.IndexOf('=', $info.LinePosition - 1)
                        if ($equals -lt 0 -or $equals + 1 -ge $line.Length) {
                            continue
                        }
                        $quote = $line[$equals + 1]
                        $close = $line.IndexOf($quote, $equals + 2)
                        if ($quote -in '"', "'" -and $close -gt 0) {
                            $spans.Add([int[]] @($info.LineNumber, ($equals + 2), ($close + 1)))
                        }
                    }
                    $null = $reader.MoveToElement()
                }
            }
            catch [System.Xml.XmlException] {
                # A file the reader cannot read exempts nothing: its long lines stay findings.
                return , [int[]] @()
            }
            finally {
                $reader.Dispose()
            }
        }
        { $_ -in 'json', 'jsonl' } {
            $number = 0
            foreach ($line in $Text -split "`r?`n") {
                $number++
                $at = 0
                while ($at -lt $line.Length) {
                    if ($line[$at] -eq '/' -and $at + 1 -lt $line.Length -and $line[$at + 1] -eq '/') {
                        break
                    }
                    if ($line[$at] -ne '"') {
                        $at++
                        continue
                    }
                    $end = $at + 1
                    while ($end -lt $line.Length -and $line[$end] -ne '"') {
                        $end += if ($line[$end] -eq '\') {
                            2
                        }
                        else {
                            1
                        }
                    }
                    if ($end -ge $line.Length) {
                        break
                    }
                    $spans.Add([int[]] @($number, ($at + 1), ($end + 1)))
                    $at = $end + 1
                }
            }
        }
        default {
            return , [int[]] @()
        }
    }

    # A line is exempt when one string covers every column past the width to the end of its text, so nothing but the
    # string overflows.
    $lines = $Text -split "`r?`n"
    $exempt = foreach ($span in $spans) {
        $number = $span[0]
        if ($number -lt 1 -or $number -gt $lines.Count) {
            continue
        }
        $content = $lines[$number - 1].TrimEnd()
        if ($content.Length -le $Width) {
            continue
        }
        if ($span[1] -le $Width + 1 -and $span[2] -ge $content.Length) {
            $number
        }
    }
    , [int[]] @($exempt | Sort-Object -Unique)
}
