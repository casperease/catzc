# pwsh/Base.Drs/Format-DrsCode.ps1

Writes a rule code in one of its forms: the full code, or a shorter citation of its record, kind or rule segment.

## help

### synopsis

Formats a rule code as its full form or a shorter citation form.

### description

Asserts the code names a rule (Assert-DrsCode -Rule), then returns it whole, its record and rule segments, its kind and rule segments, or
its rule segment alone.

### parameter `Code`

The rule code, from the pipeline or by position.

### parameter `Form`

`Full` (the default) for the whole code, `RecordRule` for the last two segments, `KindRule` for the first and the last, `Rule` for the last
alone.

### outputs

`[string]`, one per code.
