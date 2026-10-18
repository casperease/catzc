# automation/Catzc.Base.QualityGates/ConvertTo-Guid.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Converts a sentence into a valid GUID whose hex digits best-effort spell the sentence.

### description

The mint for readable placeholder GUIDs: each character maps to its closest hex look-alike (s→5, o→0, i/l→1, z→2, g→6, t→7, q→9; a–f and
digits pass through; anything else renders as 0, so one character is always one digit and a human can decode the sentence positionally).
Whitespace instead skips to the GUID's next dash group, so each word lands in its own segment. The result is padded with zeros to 32 hex
digits, truncated past 32, and formatted as a canonical lowercase GUID. The conversion is deterministic and total — every non-empty input
yields a valid `[guid]`, down to the all-zeros GUID for an input with no mappable characters.

Run by a human or an LLM to mint entries for the managed-GUID registry (Catzc.Base.QualityGates/configs/guids.yml) — never called by
production code. The engine is the native type Catzc.Base.QualityGates.SentenceGuid.

### parameter `Sentence`

The sentence to convert. Case-insensitive; must be non-empty and non-whitespace.

### outputs

`[guid]` The minted GUID.

### example 1

```powershell
ConvertTo-Guid 'sample test data'
Returns 5a001e00-7e57-da7a-0000-000000000000 — one word per dash group.
```

### example 2

```powershell
ConvertTo-Guid 'alpha test tenant'
Returns a100a000-7e57-7e0a-0700-000000000000.
```
