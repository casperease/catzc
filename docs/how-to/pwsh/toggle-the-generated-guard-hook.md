# Turn the generated-files guard hook on and off

`Assert-GeneratedStaysCommitted` refuses a commit that stages the deletion of a generated file that stays committed. This guide puts that
guard in your own clone's pre-commit hook and takes it out again. The hook is a convenience: the system works the same without it, and no
check, import or pipeline depends on it.

## Turn it on

Preview the path first, then write the hook from the repository root:

```powershell
Enable-GeneratedGuardHook -WhatIf
Enable-GeneratedGuardHook
```

The command asks git where the hooks live, so a clone with `core.hooksPath` gets its hook there. It writes a `pre-commit` shell shim that
starts `pwsh -NoProfile`, dot-sources `importer.ps1` and calls the guard. Running it again changes nothing.

## What it refuses

- A staged deletion of a generated file whose writer is not rollable. The commit stops and the message names each path with its writer and
  class. Unstage the deletion, or restore the file, and commit again.
- Writing over a pre-commit hook it did not write. The shim carries a marker line, and a hook without it is another tool's, so
  `Enable-GeneratedGuardHook` throws and leaves it. Move that hook aside first, or call the guard from it yourself.

## Turn it off

```powershell
Disable-GeneratedGuardHook
```

It deletes the hook only when it carries the marker, refuses any other pre-commit hook and does nothing when there is none.

## Without the hook

Run `Assert-GeneratedStaysCommitted` by hand before a commit for the same check. Skipping the hook, for one commit with
`git commit --no-verify` or for good, costs nothing else.
