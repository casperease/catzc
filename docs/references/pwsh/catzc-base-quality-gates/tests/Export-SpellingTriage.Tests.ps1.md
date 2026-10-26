# pwsh/Base.QualityGates/tests/Export-SpellingTriage.Tests.ps1

The tests of `Export-SpellingTriage`, which turns the words cspell flags into a stub for `terminology.yml`.

## Fixture words

The cspell output is built by joining real words, so the test's own source carries no coined token for `Test-Spelling` to flag. Apple and
mango are known through the mocked registry.

## The stub

The stub carries a blank meaning and no category, so a copy-paste into `terminology.yml` fails to load (the category is required) until a
person classifies it.
