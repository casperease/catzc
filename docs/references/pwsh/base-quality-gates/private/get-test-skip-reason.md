# pwsh/Base.QualityGates/private/Get-TestSkipReason.ps1

Extracts the human-readable reason a Pester test was skipped from the test's last error record.

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

## Parsing

Set-ItResult renders `is skipped, because <reason>`, and the reason is pulled out of that message. The capture is taken at once, since the
next `-match` overwrites `$Matches` ([ADR-PWSH-AUTOVAR](../../../../drs/automation/pwsh/automatic-variable-pitfalls.md)).
