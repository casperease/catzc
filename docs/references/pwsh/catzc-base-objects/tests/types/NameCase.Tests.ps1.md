# pwsh/Base.Objects/tests/types/NameCase.Tests.ps1

The L0 logic tests of `NameCase`, the closed set of name cases.

## Acronyms

An acronym written as one capitalised word splits at its case step like any other word: `DevOps` is two words, dev and ops, in every case,
so a module named `Widget.DevOps` is `widget.dev_ops` in the snake normal form and `widget-dev-ops` in kebab case. A run of capitals before
a capitalised word ends at the run's last capital, so `HTTPServer` is http and server.
