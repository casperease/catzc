# pwsh/Base.Objects/tests/types/SentenceGuid.Tests.ps1

<!-- cspell:ignore oilzstgq -->

The L0 logic tests of `SentenceGuid`, the mint behind `ConvertTo-Guid`.

## The empty result

An input with no mappable characters is compared against `[guid]::Empty`, not a literal: the all-zeros GUID is on the registry's denied list
and never appears in tracked text.
