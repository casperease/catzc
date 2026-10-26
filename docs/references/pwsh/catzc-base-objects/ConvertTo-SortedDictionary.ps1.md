# pwsh/Base.Objects/ConvertTo-SortedDictionary.ps1

The converter that makes dictionaries ordered all the way down, so serialized output is stable.

## help

### synopsis

Recursively converts dictionaries to ordered form for stable output.

### description

OrderedDictionaries keep their original key order. Plain Hashtables get their keys sorted alphabetically. Nested dictionaries are processed
recursively.

### parameter `Dictionary`

The dictionary to process.
