# pwsh/Base.Contracts/private/ConvertTo-AccostedCallText.ps1

The renderer of one accosted command as call text for one execution engine. The text is derived from the contract form, never written by
hand, so what an article shows is what the engine runs.

## help

### synopsis

Writes one accosted command as the call text an engine runs: PowerShell's own names under pwsh, the cats kebab form under every other
engine.

### description

An accosted command names its command and arguments in the normal form
([ADR-AUTO-ACCOSTED](../../../../drs/automation/accosted-language.md)); this turns it into the text the engine reads. Under pwsh the command
is `Verb-Noun` and each argument a `-Pascal` flag; under every other engine both are kebab, the flag prefixed `--`. The contract's parameter
types decide each value: a switch is its flag alone, and only when true; a boolean is `$true`/`$false` under pwsh and `true`/`false`
elsewhere; an integer is written bare; anything else is quoted by the engine.

### parameter `Command`

The accosted command: its normal-form name and its arguments.

### parameter `Contract`

The command's contract, whose `parameters` give each argument's type.

### parameter `Engine`

The execution engine the text is written for; it decides the name case and quotes the string values.

### outputs

`[string]` The call text, its parts joined by single spaces.

### example 1

```powershell
ConvertTo-AccostedCallText -Command $widgetCommand -Contract $widgetContract -Engine ([Catzc.Base.Engines.ExecutionEngines]::Pwsh)
```

## comment:1

Above `$normalForm = (Get-Config -Config languages).naming_normal_form`, written with `#`.

```text
pwsh takes the command as PowerShell names it; every other engine takes it through cats, in the shell's kebab
case.
```
