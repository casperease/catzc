using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Exporter;

// The package identity and metadata block of exporter.yml, which Build-Modules hands to the build engine.
public sealed class ExporterPackage : Catzc.Base.Objects.DictionaryRecord
{
    // The manifest Author.
    public string author { get; }

    // The manifest CompanyName.
    public string company { get; }

    // The manifest Description.
    public string description { get; }

    // The manifest Tags (PSData), in file order. Never empty.
    public string[] tags { get; }

    // The manifest ProjectUri.
    public string project_uri { get; }

    // The manifest LicenseUri.
    public string license_uri { get; }

    public ExporterPackage(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("package must be a map"); }
        List<string> errors = new List<string>();

        author = Field(d, "author", errors);
        company = Field(d, "company", errors);
        description = Field(d, "description", errors);
        project_uri = Field(d, "project_uri", errors);
        license_uri = Field(d, "license_uri", errors);
        tags = StrArr(d, "tags");
        if (tags.Length == 0) { errors.Add("package.tags is required and must be a non-empty list"); }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    private static string Field(IDictionary d, string key, List<string> errors)
    {
        string value = OptStr(d, key);
        if (value == null) { errors.Add(string.Format("package.{0} is required and must be a non-empty string", key)); }
        return value;
    }
}
