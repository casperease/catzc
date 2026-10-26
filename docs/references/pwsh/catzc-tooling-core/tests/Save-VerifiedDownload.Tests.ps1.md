# pwsh/Tooling.Core/tests/Save-VerifiedDownload.Tests.ps1

The L0 tests of `Save-VerifiedDownload`, over a mocked download.

## Test vector

The expected hash is the NIST test vector SHA-256 of `abc`, `ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad`. The mocked
download writes exactly those three bytes, UTF-8 without a byte order mark and without a newline.
