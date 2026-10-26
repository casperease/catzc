# pwsh/Base.Git/tests/types/GitHistoryScan.Tests.ps1

The tests of `GitHistoryScan`: they scan a hand-built `git cat-file --batch` stream for a token.

## The stream

`New-ObjectId` builds the stream by hand. The object ids are made up (any 40 hex digits): the scan indexes the stream by id and never
re-hashes content.

## The history

The fixture is a two-commit history:

- commit 1 (root): `widget.txt` (clean), `gadget/` (a tree holding `notes.txt` with the token);
- commit 2: adds the token to its message, a binary blob holding the token, a vendored copy of the token blob, and a path named after the
  token.
