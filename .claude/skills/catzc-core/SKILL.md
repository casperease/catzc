---
name: catzc-core
description: >
  The shared core every drone preloads: git as a read-only probe, the peer-dirty rule, and the fixed end-of-run report; input is the brief's
  files and what the run touched, ran and left undone.
user-invocable: false
allowed-tools: Bash, Read
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [git]
---

# catzc-core

1. Git is a read-only probe: only `git status`, `log`, `diff`, `show`, `blame` and `ls-files`, in the foreground with `timeout: 3000`; a
   script that reads `git show` output decodes it as UTF-8, never the Windows code page. Never add, commit, push, reset, checkout, rebase,
   merge, stash, rm or mv; a change the user must record is named in the report under asks.
2. `git status --short` first: a file another session has dirty, which the brief does not own, is reported, never edited, and re-read before
   relying on it; a peer stages as it lands, so `git diff` can be empty, and `git diff --cached` or the first column of `git status --short`
   shows it.
3. A new agent type appears only in a session started after its file lands; a new job skill is tried at once through a drone that loads it
   by name, never by waiting for a new robot. A brief says every file is written with the Edit tool (Write for a new one) and a script that
   writes files is refused, since a scripted writer drops facts; a brief over about 15 records is split before spawning, since a drone past
   that hits its turn roof.
4. The report, three lists and nothing beyond them. Files touched: one repository-relative path per line, marked created, edited or deleted,
   and a shared file the brief did not own listed under asks with the exact entry wanted. Checks run: each gate or test with its verdict
   line verbatim and its report path, and a check not run listed as not run, with why. Left undone: what the brief asked that did not land,
   each with its reason (blocked, denied, out of scope).
5. To a coordinator in another session, the lists go to `out/<session>-<step>.md` and the reply is the one line
   `<step> PASS|RED|BLOCKED: <one verdict line>; details out/<session>-<step>.md`.
