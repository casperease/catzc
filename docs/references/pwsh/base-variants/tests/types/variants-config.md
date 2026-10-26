# pwsh/Base.Variants/tests/types/VariantsConfig.Tests.ps1

The tests of the VariantsConfig type: each builds a variants file in memory and checks what the type accepts, what it rejects, and the
defaults it fills in.

## Fixtures

`tracks` is required, so a fixture about another key gets one neutral track added; a fixture that states its own `tracks` keeps them.
