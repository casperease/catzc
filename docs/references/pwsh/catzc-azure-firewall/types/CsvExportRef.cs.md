# pwsh/Azure.Firewall/types/CsvExportRef.cs

The typed reference to one exported firewall-rules CSV on disk: which rule kind it holds, where the local file is, and the provenance of
the blob it came from. It is the handle passed down the export-to-convert chain, so the rule kind and the provenance travel with the file.
