/*
---
catzc:
  immutable:
    with_body_sha: "3463e641cf90"
  edges:
    test: pwsh/Catzc.Base.Languages/tests/types/BashConfig.Tests.ps1
    docs: "[BashConfig.cs.md](../../../docs/references/pwsh/catzc-base-languages/types/BashConfig.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-FOLDERS-LITERALNAMES
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class BashConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The Bash root when the repository has this folder: a Bash root track.
    public const string DefaultRoot = "bash";

    // The Bash root otherwise: the dot-prefixed tooling folder.
    public const string FallbackRoot = ".bash";

    // The vendored bats-core runner, relative to the Bash root.
    public const string BatsFolder = ".vendor/bats-core";

    // A test whose name starts with this reads the shipped artifacts and is `integrity`.
    public const string IntegrityPrefix = "integrity:";

    private const string Failed = "bash config validation failed:\n";
    private static readonly string[] AllowedKeys = { "root", "bats_version", "bats_sha256" };
    private static readonly Regex Root = new Regex(@"^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$");
    private static readonly Regex Version = new Regex(@"^[0-9]+\.[0-9]+\.[0-9]+$");
    private static readonly Regex Sha256 = new Regex(@"^[0-9a-f]{64}$");

    // The declared Bash root folder, repository-relative ('/'-separated). Null when the file declares none.
    public string root { get; }

    // The vendored bats-core release, X.Y.Z.
    public string bats_version { get; }

    // The SHA-256 of that release's source archive, lowercase hex.
    public string bats_sha256 { get; }

    public BashConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null)
        {
            foreach (object k in raw.Keys)
            {
                string key = Convert.ToString(k, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }

            if (raw.Contains("root") && raw["root"] != null)
            {
                string value = Convert.ToString(raw["root"], CultureInfo.InvariantCulture);
                bool dotSegment = Array.Exists(value.Split('/'), s => s == "." || s == "..");
                if (raw["root"] is string && Root.IsMatch(value) && !dotSegment) { root = value; }
                else
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture,
                        "invalid root '{0}' (a repository-relative folder: '/'-separated segments, no leading or trailing slash, no '.' or '..' segment, e.g. 'bash')", value));
                }
            }

            string version = raw.Contains("bats_version") ? Convert.ToString(raw["bats_version"], CultureInfo.InvariantCulture) : null;
            if (version != null && Version.IsMatch(version)) { bats_version = version; }
            string sha = raw.Contains("bats_sha256") ? Convert.ToString(raw["bats_sha256"], CultureInfo.InvariantCulture) : null;
            if (sha != null && Sha256.IsMatch(sha)) { bats_sha256 = sha; }
        }
        if (bats_version == null)
        {
            errors.Add("bats_version must be the vendored bats-core release, X.Y.Z (e.g. 1.14.0)");
        }
        if (bats_sha256 == null)
        {
            errors.Add("bats_sha256 must be the SHA-256 of that release's source archive, 64 lowercase hex digits");
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    public string ResolveRoot(string repositoryRoot)
    {
        if (root != null) { return root; }
        if (string.IsNullOrWhiteSpace(repositoryRoot))
        {
            throw new ArgumentException("BashConfig.ResolveRoot requires the repository root");
        }
        return Directory.Exists(Path.Combine(repositoryRoot, DefaultRoot)) ? DefaultRoot : FallbackRoot;
    }
}
