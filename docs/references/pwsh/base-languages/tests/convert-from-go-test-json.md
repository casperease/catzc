# pwsh/Base.Languages/tests/ConvertFrom-GoTestJson.Tests.ps1

The logic tests of `ConvertFrom-GoTestJson`, over canned `go test -json` streams in `tests/assets`: one recorded from a widget package
(pass, fail, skip, and a table test with subtests) and one from a gadget package that does not compile.
