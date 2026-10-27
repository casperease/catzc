# pwsh/Tooling.Claude/Lock-SharedConfig.ps1

The public command that claims a shared config for one session's edits. The claim is a file-backed record beside the run lock's queue, which
the `Assert-EditClaim` hook reads on every Edit or Write: another session's edit of the claimed file is denied, the claimant's goes on.

## help

### synopsis

Claims a shared config for this session's edits until the claim expires, so another session's Edit of it is denied.

### description

The run lock is a mutex its process lets go on exit, so it cannot span an edit across tool calls; this claim can. The config is named by its
global name, one of `shared_configs` in `configs/editor-claims.yml`, and resolved to its file as Get-Config finds it. The claim lasts
`run_lock.wait_seconds` of `timeouts.yml`, so a peer is never held up longer by an edit than by a run; calling it again renews the
claimant's own claim. It throws, naming the claimant and the expiry, while another session holds a live claim.

### parameter `Name`

The shared config's global name, such as `timeouts`.

### parameter `Session`

The Claude Code session that claims it. Default: `CLAUDE_CODE_SESSION_ID`, which Claude Code sets for every shell it starts.

### outputs

`[Catzc.Tooling.Claude.EditorClaim]`: the session, the claimed file's full path and the expiry in UTC.

### example 1

```powershell
Lock-SharedConfig timeouts
```
