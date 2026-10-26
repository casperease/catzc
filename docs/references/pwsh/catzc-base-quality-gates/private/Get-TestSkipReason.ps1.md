# pwsh/Base.QualityGates/private/Get-TestSkipReason.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Extracts the human-readable reason a Pester test was skipped.

### description

A test skipped with `Set-ItResult -Skipped -Because '<reason>'` carries an error record whose message reads "is skipped, because
`<reason>`"; this returns just "`<reason>`". A skip with no -Because (a bare `Set-ItResult -Skipped`, or an `It -Skip`, which records no
error at all) has no reason, so the function returns 'no reason given'. Any other recorded message (e.g. Run.SkipRemainingOnFailure's
"Skipped due to previous failure at …") is returned verbatim. Feeds Write-TestAutomationSkipReport.

### parameter `Test`

A Pester test-result object (an item of $result.Tests). Its .ErrorRecord carries the skip message.

## comment:1

Above `if ($message -match 'because\s+(.+?)\s*$') {`, written with `#`.

```text
Set-ItResult renders "is skipped, because <reason>" — pull out the reason. Capture $Matches
immediately (it is clobbered by the next -match; see automatic-variable-pitfalls).
```
