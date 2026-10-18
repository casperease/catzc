# ADR-REPO-CMDCONTRACT: command contracts and the contract language

## Rules: ADR-REPO-CMDCONTRACT

### Rule ADR-REPO-CMDCONTRACT-COMMANDCONTRACT

A **command contract** is a contract asset, `<module>/<Verb-Noun>.command.yml` in a unit's version folder, that states the call interface of
one command, and it is provided: its consumers are the callers outside the module system, a POSIX shell through `cats`, a black-box test in
another language, a pipeline step. A command is public exactly when a command contract names it. A function no contract names is not public
and changes in place under [one living version](../principles/one-living-version.md): it is **internal** when only its own module calls it,
placed in the module's `private/` folder and not exported, the way C#'s `internal` scopes a member to its assembly, and it stays exported,
with no promise, while another module calls it. Internal says where a function is visible, so it is a different thing from a Catzc.Internal
module, a group of modules with a lifetime and rules of its own.

- [Public is contracted](#public-is-contracted)

### Rule ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE

The **contract language** is the notation a command contract is written in: YAML with a `parameters:` map, one entry per parameter whose
value is one string, the type followed by `!` when the parameter is mandatory, by `= <literal>` when it has a constant default, by
`pipeline` when its value comes from the pipeline, and by `in <Set>[,<Set>]` when it belongs to named parameter sets only, an `output:`
type, `void` when omitted, and a `default_set:` naming the set a call that fits several resolves to. The type set is closed: `string`,
`int`, `bool`, `switch`, or the name of a `Catzc.*` type, each followed by `[]` for a list. A richer type, or a key beyond these three, is a
change to this rule, never a value added to a list. The defaults are declared once on the `ContractCommand` type
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): a parameter is
optional, has no default, is not fed from the pipeline and belongs to every set; the output is void; there is no default set. A parameter
that is mandatory in one set and optional in another has no spec, so a command that declares one cannot be contracted.

- [One string per parameter](#one-string-per-parameter)

### Rule ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS

A command contract stores nothing its placement says ([zero-ceremony](../automation/zero-ceremony-poka-yoke.md)): the command's name is the
file name, the owning module is the folder, the version is the unit's version folder, the implementation language is the language of the
file that holds the command, and the engines the command runs under are every engine of the engine registry. The asset holds the call
interface and, where a signature does not say what the command promises, the header comment of
[ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS](api-contracts.md#rule-adr-repo-contract-headersayswhatitpins).

- [Placement says the rest](#placement-says-the-rest)

### Rule ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE

One checker per implementation language compares a command contract with the command's file without loading the module: the PowerShell
checker reads the parameter block and the output type from the parsed file. The check reports a missing command, a parameter the contract
and the file disagree on, and a mandatory, switch, pipeline, type, default, parameter-set or output mismatch, each as one finding on the
asset's result ([ADR-REPO-CONTRACT-PROVENBYTESTS](api-contracts.md#rule-adr-repo-contract-provenbytests)). A language with no checker throws
`NotImplemented` when a command of that language is contracted, the stance of
[ADR-REPO-CONTRACT-CONFIGUREDADDRESSING](api-contracts.md#rule-adr-repo-contract-configuredaddressing), and a contracted command is proven
from every engine: each engine's start resolves it ([execution-engines](../automation/execution-engines.md)).

- [A checker per language](#a-checker-per-language)

### Rule ADR-REPO-CMDCONTRACT-ONEREADER

One reader, `Get-CommandContract`, parses a command contract into the typed record of the contract language, and nothing else parses it. The
contract reference page ([ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS](api-contracts.md#rule-adr-repo-contract-headersayswhatitpins)) shows a
command asset's signature in a column of its own, from that reader. `cats` validates a call against a committed lookup generated from the
command contracts before it starts an engine: an unknown parameter, a missing mandatory one or a value that is not of the stated type is
rejected with the contract's message, and each accepted value reaches the command in the type the contract names
([poka-yoke](../principles/poka-yoke.md)).

- [A language that is used](#a-language-that-is-used)

### Rule ADR-REPO-CMDCONTRACT-VERSIONSWITHUNIT

A command contract versions with its unit ([ADR-REPO-CONTRACT-LAYOUT](api-contracts.md#rule-adr-repo-contract-layout)): the draft `0.0.0` is
where a signature is shaped, and a change to a contracted command's signature edits its asset in the same change, or the check fails. A
released version folder pins the signature for every consumer of that version
([ADR-REPO-CONTRACT-KEPTWHILEPINNED](api-contracts.md#rule-adr-repo-contract-keptwhilepinned)): the command keeps that call interface while
the folder is in the tree, and the frozen asset's check fails the change that breaks it.

- [Pinned by the unit](#pinned-by-the-unit)

## Context

The module system exports hundreds of functions, and every one of them is reachable from a shell through `cats`, from a pipeline step, and
from a test written in another language. Nothing outside the PowerShell file says what a function takes: the help carries parameter text,
and the types, the mandatory flags and the defaults exist only in the parameter block. A caller in bash or Go reads that file or guesses,
and a signature change breaks it after a start and an import, seconds later and far from the change. A command contract puts the call
interface where the boundary already is, `contracts/` ([api-contracts](api-contracts.md)), in a notation small enough that a shell can read
it and a checker can prove it.

### Public is contracted

`What is promised is what is written down`

The provided contracts are the only public API of the repository
([ADR-REPO-CONTRACT-BINDINGINTERFACE](api-contracts.md#rule-adr-repo-contract-bindinginterface)), so a command without a contract is not
public, however it is exported: exporting is a mechanism of the module system, and promising is an act at the boundary. Writing the contract
is the act. It keeps the public set small and chosen, and it leaves every uncontracted function free to change in place, which is what one
living version asks. A caller that reaches a function no contract names gets no promise, exactly as a consumer that reaches past a provided
contract gets none.

### One string per parameter

`A signature in one line per parameter`

```yaml
# contracts/catzc/0.0.0/Catzc.Base.Widgets/Get-Widget.command.yml
parameters:
  Path: string! # mandatory
  Strict: switch
  Engine: string = auto # a constant default
  Item: string[]! pipeline # a mandatory list, fed from the pipeline
output: Catzc.Base.Widgets.Widget
```

```yaml
# contracts/catzc/0.0.0/Catzc.Base.Widgets/Find-Gadget.command.yml
parameters:
  Id: string! in Id # only in the set Id, mandatory there
  Count: int! in Random
  Seed: int in Random
  Spare: switch in All,Random # in two of the sets
  Quiet: switch # in every set
default_set: All
output: Catzc.Base.Widgets.Gadget
```

```text
spec        = type [ "!" ] [ "=" literal ] [ "pipeline" ] [ "in" sets ]
sets        = SetName { "," SetName }
type        = base [ "[]" ]
base        = "string" | "int" | "bool" | "switch" | TypeName      # TypeName is a Catzc.* type
output      = type | "void"
default_set = SetName
```

One string per parameter is the least ceremony a signature can take, and a map keyed by parameter name is order-free, so the existing
key-subset readers of the contracts module read it unchanged. The cost is a small grammar inside each value; the `ContractCommand` type
holds that grammar, the one place it is written, and a value that does not parse is a finding. The type set is closed on purpose: every
checker maps four base types and the `Catzc.*` type names, nothing more, and a type nobody can prove from a file is a type nobody can
promise.

A command with parameter sets takes one of several call shapes, and the shape is part of its interface: which parameters go together and
which are mandatory in each. The set names ride on the parameter they belong to, so each parameter is still one string, and a parameter with
no `in` belongs to every set, as it does in a PowerShell parameter block that names no set. The default set is the one key the command
itself carries, because it belongs to no single parameter and may be a set no parameter names, the shape a call with none of the set-bound
parameters takes. Mandatory stays one flag per parameter: a parameter that is mandatory in one set and optional in another would need a flag
per set, and that shape is rare enough to be refused rather than given a grammar.

### Placement says the rest

`Nothing in the asset that the path already says`

The folder names the module and the file names the command, so the asset carries neither. The real file is the command's file under the
module's root, where its public functions sit, so the module needs no target root for its commands. The version is the unit's. The
implementation language is read from that file, through the file-language registry, and the engines are the engine registry's: a command
contracted for one engine would be a half-promise, and a consumer reaches the command through whichever engine it has.

### A checker per language

`Prove the contract from the file, not from a running module`

The check compares text with text: the contract on one side, the parsed file on the other. Loading the module to introspect the command
would make the gate depend on the import, on the module's dependencies and on the engine's state, and would prove the loaded shape rather
than the committed one. Each implementation language has its own file shape, so each has its own checker, and a language with no checker
refuses loudly rather than passing silently. A non-constant default is reported as computed, not failed: the contract promises the
parameter, not the value an expression produces at run time. The per-engine proof is cheap and separate: that each engine's start resolves
each contracted command is one generated test per command, from the same enumeration the checks use.

### A language that is used

`A document nobody reads is not a contract`

A command contract earns its place by being read in three places. The reader is the one parser, so every consumer sees the same record. The
reference page shows the signature beside the asset's module and direction, so a reader finds a command's interface without opening the
asset. And `cats` reads the generated lookup before it starts an engine: a wrong call is rejected in the shell, with the contract's message,
instead of after a start and an import, and a value is passed in its stated type, so a switch is a flag and an integer is an integer rather
than a quoted string. For a command with parameter sets, the call is held to the set its parameter names fit, the default set when they fit
several, so a parameter from another set or a mandatory one missing from that set is rejected the same way. The lookup is generated from the
contracts and committed beside the entry point's script, through the root-config generator, never edited by hand.

### Pinned by the unit

`A signature change is a contract change`

Because the asset states the signature, a change to the signature is a change to the asset, in the same change, or the draft's check fails.
That friction is the point: it makes a public signature change a reviewed, visible act. Once the unit is released, the frozen asset holds
the signature a consumer of that version relies on, and the frozen folder's check fails any change that breaks it until the folder is
retired, the one place backwards compatibility is owed
([ADR-REPO-CONTRACT-KEPTWHILEPINNED](api-contracts.md#rule-adr-repo-contract-keptwhilepinned)).

### Rejected alternatives

1. **A list of maps per parameter** (`- name: Path`, `type: string`, `mandatory: true`) — rejected: about three times the lines for the same
   facts, and a long form beside the short one would be two notations for one thing.

2. **One signatures file per module** (a `commands.yml` with one signature string per command) — rejected: it invents a larger grammar for a
   whole file and breaks one file per asset, which is what makes an asset's name pick its kind and its target.

3. **`<Verb-Noun>.ps1.command.yml` under a per-module target root** — rejected: it needs a target-root entry per module to say what the
   module folder already says.

4. **Contracting every exported function at once**, generated from the functions' files — rejected: it freezes hundreds of signatures nobody
   chose to promise, and a contract that is generated from the file it checks proves nothing about that file.

5. **A `path` type** beside `string` — rejected: a PowerShell parameter block cannot tell the two apart, so the checker could not prove it;
   a type that cannot be proven is not promised.

6. **Named error conditions** in the contract (`errors:`) — rejected: no checker can prove them from the command's file, so they would be
   prose dressed as a contract.

7. **A `sets:` map** of set name to parameter names — rejected: it states a parameter's membership in a second place, away from its spec, so
   one fact would have two places to drift apart in.

8. **Reusing the fragment check** for a command asset — rejected: a fragment is contained by its target, and a signature is compared with a
   parsed file, a different relation with its own findings.

## Decision

A command contract is a provided contract asset, `<module>/<Verb-Noun>.command.yml`, that states one command's call interface in the
contract language: one string per parameter and an output type, over a closed type set, with the defaults declared once on its type. A
command is public exactly when a contract names it. Placement says the command, the module, the version, the implementation language and the
engines. One checker per implementation language proves the contract from the parsed file, a language without a checker throws, and each
engine's start resolves each contracted command. One reader parses it, the reference page shows it, and `cats` validates and types a call
against it before any engine starts. It versions with its unit, so a signature change is a contract change, and a released folder pins the
signature.

### How this is enforced

- **`Catzc.Base.Contracts`** carries the kind `Command` in `ContractAssetKind`, picked from the `.command.yml` suffix by the name rule
  ([ADR-REPO-CONTRACT-CONTRACTASSET](api-contracts.md#rule-adr-repo-contract-contractasset)), the types `ContractCommand` and
  `ContractParameter` that parse the contract language and hold its defaults, and `Get-ContractCommandFindings`, the PowerShell checker, run
  by `Test-Contracts` for every command asset (ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE).

- **`ContractCommand`** is the one grammar of the contract language, so a value that does not parse is a finding on the asset and no schema
  restates the grammar (ADR-REPO-CMDCONTRACT-CONTRACTLANGUAGE).

- **The data-driven L1 test** of the contracts module generates one test per command asset from the same enumeration as every other kind
  ([ADR-REPO-CONTRACT-PROVENBYTESTS](api-contracts.md#rule-adr-repo-contract-provenbytests)), and one per engine that the engine's start
  resolves the command.

- **`Get-CommandContract`** is the one reader; `Build-ContractReference` fills the signature column from it, and `Test-GeneratedFiles` fails
  when the page is stale (ADR-REPO-CMDCONTRACT-ONEREADER).

- **The `cats` lookup** is generated from the command contracts by the root-config generator in `Catzc.Base.RootConfig`, committed beside
  the entry point's script, and covered by one bats test per engine case; `Test-GeneratedFiles` fails when it is stale
  (ADR-REPO-CMDCONTRACT-ONEREADER).

- **Code review** guards what the checks cannot phrase: that a function nobody contracted is treated as internal, and that a contract is
  written by hand for a command someone chose to promise, never generated from the command's file (ADR-REPO-CMDCONTRACT-COMMANDCONTRACT).

## Consequences

- A caller outside the module system has one stated interface per public command, in a notation a shell can read without PowerShell.
- The public set is small and chosen: writing a contract is the act of making a command public, and every other function changes freely.
- A signature change to a public command is a contract change, caught where it is made, in the draft's check or in the frozen folder's.
- `cats` rejects a wrong call before an engine starts and passes typed values, so a switch is a flag and an integer is an integer.
- Each implementation language needs its own checker before a command of that language is promised; until it has one, the attempt throws.
- The cost is a hand-written asset per public command and the discipline of editing it with the signature; the first contracted set is a
  small coherent one, widened a family at a time.
