# pwsh/Base.Contracts/configs/contracts.yml

The contracts config: it says how a contract group folder is named, and nothing else. Contracts are addressed by root, version, group and
file, so the group name is the only thing that needs a rule.

## groups

A group is the module's track and its folder in the normal form, for example `pwsh.base.vs_code` for Catzc.Base.VSCode. `form` names the
rule, `track_module` today. `exceptions` maps a module's full name to its group, only for a module whose folder would not give the right
one; it is empty when the form fits every module. Get-ContractGroup reads both.
