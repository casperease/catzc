# pwsh/Base.Contracts/types/ContractsConfig.cs

The typed record for the contracts config: how a contract group folder is named, and nothing else. Contracts are addressed by root, version,
group and file (`ContractLayout`), never by a mode set here.

## Keys

Under `groups`:

- **`form`** — how a group is built. The one form, `track_module`, is the module's track and its folder in the normal form, so
  `Catzc.Base.VSCode` has the group `pwsh.base.vs_code`.
- **`exceptions`** — a map of a module's full name to its group, for the rare module the form names wrongly.

Construction collects every violation into one `ArgumentException`, so an unknown key fails at load. `GroupOf` answers the group of a module
and `ExceptionModuleOf` the module an exception names for a group.
