function Enable-FirstUseCompletion {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Wraps the session''s tab-completion function in memory only; the importer announces the deferral')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The wrap is session state the importer records in its load record')]
    [CmdletBinding()]
    [OutputType([void])]
    param(
        # Takes the wrap out and puts the engine's own TabExpansion2 back.
        [switch] $Remove
    )

    $previous = $ExecutionContext.SessionState.PSVariable.GetValue('script:firstUseCompletionOriginal')
    if ($null -ne $previous) {
        Set-Item -Path Function:\global:TabExpansion2 -Value $previous
        $script:firstUseCompletionOriginal = $null
    }
    if ($Remove) {
        return
    }

    $original = (Get-Command -Name TabExpansion2 -CommandType Function -ErrorAction Ignore).ScriptBlock
    if ($null -eq $original) {
        return
    }
    $script:firstUseCompletionOriginal = $original
    $index = $ExecutionContext.SessionState.PSVariable.GetValue('script:firstUseIndex')

    # The same two parameter sets as the engine's own TabExpansion2, so PSReadLine and CompleteInput bind as they do to it.
    $wrap = {
        [CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
        param(
            [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory, Position = 0)]
            [string] $inputScript,

            [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory, Position = 1)]
            [int] $cursorColumn,

            [Parameter(ParameterSetName = 'AstInputSet', Mandatory, Position = 0)]
            [System.Management.Automation.Language.Ast] $ast,

            [Parameter(ParameterSetName = 'AstInputSet', Mandatory, Position = 1)]
            [System.Management.Automation.Language.Token[]] $tokens,

            [Parameter(ParameterSetName = 'AstInputSet', Mandatory, Position = 2)]
            [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,

            [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
            [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
            [Hashtable] $options = $null
        )

        $completion = & $original @PSBoundParameters
        if ($null -eq $completion -or $index.Count -eq 0) {
            return $completion
        }

        if ($PSCmdlet.ParameterSetName -eq 'AstInputSet') {
            $text = $ast.Extent.Text
            $cursor = $positionOfCursor.Offset - $ast.Extent.StartOffset
        }
        else {
            $text = $inputScript
            $cursor = $cursorColumn
        }
        if ($cursor -lt 0 -or $cursor -gt $text.Length) {
            return $completion
        }

        # A command-name position: the word under the cursor is the first one, or follows a pipe or a semicolon.
        $position = [regex]::Match($text.Substring(0, $cursor), '(?:^|[|;])\s*(?<word>[A-Za-z][\w.-]*)$')
        if (-not $position.Success) {
            return $completion
        }
        $word = $position.Groups['word'].Value
        $pattern = [System.Management.Automation.WildcardPattern]::new([System.Management.Automation.WildcardPattern]::Escape($word) + '*', 'IgnoreCase')

        $engineCount = $completion.CompletionMatches.Count
        $known = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($match in $completion.CompletionMatches) {
            [void] $known.Add($match.CompletionText)
        }
        # The engine's own collection may be read-only, so the merge builds a new one.
        $merged = [System.Collections.ObjectModel.Collection[System.Management.Automation.CompletionResult]]::new()
        foreach ($match in $completion.CompletionMatches) {
            $merged.Add($match)
        }
        foreach ($entry in @($index.GetEnumerator() | Sort-Object -Property Key)) {
            if ($entry.Value -and $pattern.IsMatch($entry.Key) -and $known.Add($entry.Key)) {
                $merged.Add([System.Management.Automation.CompletionResult]::new($entry.Key, $entry.Key, [System.Management.Automation.CompletionResultType]::Command, $entry.Value))
            }
        }
        if ($merged.Count -eq $engineCount) {
            return $completion
        }
        # The engine found nothing, so it named no span to replace: the word itself is the span.
        if ($engineCount -eq 0) {
            return [System.Management.Automation.CommandCompletion]::new($merged, -1, $position.Groups['word'].Index, $word.Length)
        }
        [System.Management.Automation.CommandCompletion]::new($merged, $completion.CurrentMatchIndex, $completion.ReplacementIndex, $completion.ReplacementLength)
    }.GetNewClosure()

    Set-Item -Path Function:\global:TabExpansion2 -Value $wrap
}
