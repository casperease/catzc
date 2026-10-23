---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-BCL-TYPES-LINEENDINGINSENSITIVEKEY
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# The types cache key ignores line endings and the build is content addressed

This article is one rule:
[ADR-BCL-TYPES-LINEENDINGINSENSITIVEKEY](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-lineendinginsensitivekey) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

The compiled-type cache key is byte-exact but line-ending-insensitive: `Import-CSharpTypes` hashes each `types/*.cs` with the
carriage-return bytes stripped, so a CRLF or an LF working tree yields the same `Catzc.Types.<hash>.dll` name on every machine. The build is
immutable and content-addressed in the same spirit: the same commit yields a byte-identical build on any machine.
