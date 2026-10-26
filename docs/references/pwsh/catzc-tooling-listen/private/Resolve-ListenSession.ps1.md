# pwsh/Tooling.Listen/private/Resolve-ListenSession.ps1

A private helper of the listen module that finds the session folder every listen command works on: the one named, or the newest.

## help

### synopsis

Resolves a listen session's folder: the one named, or the newest under the output folder.

### description

A session folder is named by its start stamp (yyyyMMdd-HHmmss), so the newest is the last by ordinal name. A session must hold its seen.json
index; a folder without one is no session. The output folder lives in out/, which can be wiped at any time, so a session can be missing at
the start and can vanish while it is in use.

### parameter `Session`

The session folder. Omitted: the newest session under listen.yml's output folder.

### parameter `AllowMissing`

Return nothing, instead of throwing, when there is no such session.

### outputs

`[string]` the session folder's full path, or nothing with -AllowMissing.
