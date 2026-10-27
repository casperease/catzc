# pwsh/Tooling.Claude/Unlock-SharedConfig.ps1

The public command that releases a session's claim on a shared config, so any session may edit or claim it again.

## help

### synopsis

Releases this session's claim on a shared config, so any session may edit or claim it.

### description

Deletes the session's claim record. A config no session claims releases as nothing to do; one another session holds throws, naming the
claimant and the expiry, and keeps that claim.

### parameter `Name`

The shared config's global name, such as `timeouts`.

### parameter `Session`

The Claude Code session that holds the claim. Default: `CLAUDE_CODE_SESSION_ID`.

### outputs

Nothing.

### example 1

```powershell
Unlock-SharedConfig timeouts
```
