# pwsh/Base.Objects/types/SentenceGuid.cs

The static type that deterministically converts a sentence into a valid GUID whose hex digits best-effort spell the sentence, leet-style: s
becomes 5, o becomes 0, i and l become 1. It is the mint behind `ConvertTo-Guid`, run by a human or an LLM to produce readable placeholder
GUIDs for the managed-GUID registry (`guids.yml`), and never called by production code. It is BCL only
([ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES](../../../../drs/automation/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types-hostguaranteedassemblies)).

## Shape

One input character yields exactly one hex digit, so the rendering is positionally stable and human-decodable. A character with no hex
look-alike becomes `0` rather than being skipped. Whitespace instead advances to the next GUID dash group, so each word lands in its own
segment: "sample test data" becomes `5a001e00-7e57-da7a-…`. Validity is structural: any 32 hex digits form a parseable GUID, so every input
yields one.

## The map

The map is a visual best guess into the hex alphabet. Identity hex letters map to themselves and digits pass through in `Convert`;
characters absent from the table have no honest hex look-alike and render as `0`. The table is data: extending it changes only GUIDs minted
after the change, never registered ones.

## Dash groups

The group boundaries are the digit positions where the GUID's 8-4-4-4-12 dash groups begin and end. Whitespace advances to the next of
these, so words align with segments, and the leading boundary 0 makes leading whitespace a no-op. Advancing fills to the next group boundary
so the next word starts its own segment; at a boundary it is a no-op, so runs of whitespace collapse.
