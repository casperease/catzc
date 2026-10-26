# pwsh/Tooling.Environment/Write-EnvironmentSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Prepares a set of $env: variables for a child or external process to read — the one sanctioned seam for handing a secret to an external
consumer through the environment.

### description

Writes environment variables for an external/child/test process from three distinct, unambiguous channels, so intent is never guessed
(poka-yoke):

```text
-Set   a map whose value is either a [SecureString] (a SECRET) or a 'global.<config>...' config address
       (a non-secret value or subtree, resolved by Get-ConfigValue — ADR-CONF-ADDRESSING). The
       map KEY is the environment variable name (for a secret or a scalar address) or the prefix (for a
       subtree address). A bare literal string in -Set is REJECTED — pass it through -Value instead, so a
       literal can never be mistaken for a secret or an address.
-Value a map of explicit non-secret literals (key = env name, value = literal string).
```

Secrets are taken as `[SecureString]`, never logged or returned (masked `***`), and decrypted to plaintext only at the $env: assignment. A
subtree address flattens under its prefix, env-normalized: uppercased, '.'->'_' and '`[n]'->'_n`' (so prefix 'DB' + 'options.ssl' ->
DB_OPTIONS_SSL). If two channels would produce the same env var name, the call throws rather than silently letting one win.

Lifetime is one of two mutually exclusive parameter sets:

```text
-ScriptBlock  (Scoped, the default): snapshot each target's current value, set all, invoke the block, and
              restore every target in a finally (previously-unset variables are removed) — the secret
              leaves the environment when the block exits. The block's output is returned.
-Persist:     set all and leave them for the rest of the session/child; nothing is returned.
```

Cross-platform note (ADR cross-platform): `[SecureString]` is DPAPI-encrypted only on Windows; on Linux/macOS .NET stores it obfuscated, not
encrypted. The value of the contract here is don't-log / don't-internalize / decrypt-only-at-the-boundary, not at-rest cryptography — the
plaintext necessarily lands in $env: for the instant the external tool reads it
([ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS](../../../drs/automation/environment-variables.md#rule-adr-auto-envvar-secrettochildprocess)).

### parameter `Set`

Map of env name (or subtree prefix) to a `[SecureString]` secret or a '`global.<config>`...' config address.

### parameter `Value`

Map of env name to an explicit non-secret literal string.

### parameter `ScriptBlock`

Scoped lifetime: the variables are set only for the duration of this block, then restored.

### parameter `Persist`

Persist lifetime: the variables are set and left in place for the session/child process.

### example 1

```powershell
Write-EnvironmentSet -Set @{
    DB       = 'global.database'        # subtree -> DB_HOST, DB_PORT, DB_OPTIONS_SSL
    APP_NAME = 'global.myproperty.name' # scalar  -> APP_NAME
    GH_TOKEN = $secureToken             # secret  -> masked in logs
} -Value @{ MY_FLAG = '1' } -ScriptBlock { Invoke-SomeContainer }
```

### example 2

```powershell
Write-EnvironmentSet -Set @{ GH_TOKEN = $secureToken } -Persist
```

## comment:1

Above `$entries = [System.Collections.Generic.List[hashtable]]::new()`, written with `#`.

```text
1) Resolve every channel into a flat list of env-var assignments. Each entry:
   @{ Name; Value; Secret; Origin; Address }  (Address is $null unless address-sourced).
```

## comment:2

Above `$scoped = -not $Persist`, written with `#`.

```text
3) Apply. Scoped snapshots each target's current value, sets all, invokes the block, and restores in a
   finally; Persist just sets all and leaves them. Both share one set+log loop.
```

## comment:3

Above `$scoped = -not $Persist`, written with `#`.

```text
Scoped restores every target in a finally, so a throwing block never leaves a variable changed; Persist leaves
them set.
```
