# pwsh/Base.Drs/tests/types/DrsConfig.Tests.ps1

The tests of `DrsConfig`, the typed record of `drs.yml`.

## Fixtures

The fixtures are neutral: invented codes and names of domains, never real DRS vocabulary
([ADR-REPO-LANG](../../../../../drs/repository/domain-language-separation.md)). The `New-ValidRaw` helper is defined in `BeforeAll`, so it
is in scope for the run phase and visible to every `It`. A function in a `Describe` body is only in discovery scope.
