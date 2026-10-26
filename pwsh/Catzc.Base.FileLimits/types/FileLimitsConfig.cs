/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-file-limits/types/FileLimitsConfig.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using static Catzc.Base.FileLimits.FileLimitsReaders;

namespace Catzc.Base.FileLimits;

public sealed class FileLimitsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const int DefaultLengthMin = 100;
    public const int DefaultLengthMax = 500;
    public const int DefaultWidthMin = 80;
    public const int DefaultWidthMax = 200;
    // The most body lines one PowerShell function may have; the analyzer rule FunctionLength reads it from file-limits.yml.
    public const int DefaultFunctionBodyLength = 300;

    public const string Unmeasured = "none";

    public static readonly string[] Classes = { "code", "config", "prose" };

    private static readonly string[] AllowedKeys =
    {
        "bounds", "classes", "defaults", "exempt", "extensions", "function_body_length", "languages", "string_overflow", "width_mode",
    };
    private static readonly string[] WidthModes = { "report", "fail" };
    public const string DefaultWidthMode = "report";

    // Whether a line whose part past the width lies wholly inside one string literal breaches (breach) or passes (exempt).
    private static readonly string[] StringOverflowModes = { "exempt", "breach" };
    public const string DefaultStringOverflow = "exempt";

    private static readonly Dictionary<string, string> DefaultExtensions = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
    {
        [".psd1"] = "config",
        [".gitignore"] = "config",
        [".gitattributes"] = "config",
        [".editorconfig"] = "config",
        [".gitattributes-template"] = "config",
        [".markdownlintignore"] = "config",
        [".prettierignore"] = "config",
        // One record per line is data whose lines cannot wrap, so a delimited table is not measured.
        [".csv"] = Unmeasured,
        [".tsv"] = Unmeasured,
        ["LICENSE"] = "prose",
        [".gitkeep"] = Unmeasured,
        ["gitkeep"] = Unmeasured,
        [".pyc"] = Unmeasured,
    };

    private static readonly Dictionary<string, FileLimit> DefaultLimits = new Dictionary<string, FileLimit>(StringComparer.Ordinal)
    {
        ["code"] = new FileLimit(400, 120),
        ["config"] = new FileLimit(300, 140),
        ["prose"] = new FileLimit(400, 140),
    };

    private static readonly Dictionary<string, string> DefaultClasses = new Dictionary<string, string>(StringComparer.Ordinal)
    {
        ["powershell"] = "code",
        ["bcl"] = "code",
        ["bicep"] = "code",
        ["python"] = "code",
        ["go"] = "code",
        ["bash"] = "code",
        ["javascript"] = "code",
        ["css"] = "code",
        ["html"] = "code",
        ["yaml"] = "config",
        ["pipeline-yaml"] = "config",
        ["accosted"] = "config",
        ["json"] = "config",
        ["jsonl"] = Unmeasured,
        ["xml"] = "config",
        ["solution"] = "config",
        ["markdown"] = "prose",
        ["stamp"] = Unmeasured,
        ["asset"] = Unmeasured,
    };

    private readonly Dictionary<string, ResolvedFileLimit> resolved = new Dictionary<string, ResolvedFileLimit>(StringComparer.Ordinal);

    public int length_min { get; }
    public int length_max { get; }
    public int width_min { get; }
    public int width_max { get; }
    public IReadOnlyDictionary<string, FileLimit> defaults { get; }
    public IReadOnlyDictionary<string, FileLimit> languages { get; }
    public IReadOnlyDictionary<string, string> classes { get; }
    public IReadOnlyDictionary<string, string> extensions { get; }
    public IReadOnlyDictionary<string, string> width_mode { get; }
    public IReadOnlyDictionary<string, string> exempt { get; }
    public int function_body_length { get; } = DefaultFunctionBodyLength;
    public string string_overflow { get; } = DefaultStringOverflow;

    public FileLimitsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null)
        {
            function_body_length = ReadWhole(raw, "function_body_length", "file-limits", errors) ?? DefaultFunctionBodyLength;
            if (raw.Contains("string_overflow") && raw["string_overflow"] != null)
            {
                string overflow = raw["string_overflow"] as string;
                if (overflow == null || Array.IndexOf(StringOverflowModes, overflow) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "string_overflow '{0}' must be one of {1}", raw["string_overflow"], string.Join(", ", StringOverflowModes)));
                }
                else
                {
                    string_overflow = overflow;
                }
            }
        }
        int lengthMin = DefaultLengthMin, lengthMax = DefaultLengthMax, widthMin = DefaultWidthMin, widthMax = DefaultWidthMax;
        Dictionary<string, FileLimit> defaultsValue = new Dictionary<string, FileLimit>(DefaultLimits, StringComparer.Ordinal);
        Dictionary<string, FileLimit> languagesValue = new Dictionary<string, FileLimit>(StringComparer.Ordinal);
        Dictionary<string, string> classesValue = new Dictionary<string, string>(DefaultClasses, StringComparer.Ordinal);
        Dictionary<string, string> widthModeValue = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (string name in Classes)
        {
            widthModeValue[name] = DefaultWidthMode;
        }

        Dictionary<string, string> exemptValue = new Dictionary<string, string>(StringComparer.Ordinal);
        Dictionary<string, string> extensionsValue = new Dictionary<string, string>(DefaultExtensions, StringComparer.OrdinalIgnoreCase);

        if (raw != null)
        {
            CheckKeys(raw, AllowedKeys, "file-limits", errors);

            IDictionary bounds = Section(raw, "bounds", errors);
            if (bounds != null)
            {
                CheckKeys(bounds, LimitKeys, "bounds", errors);
                ReadBound(bounds, "length", ref lengthMin, ref lengthMax, errors);
                ReadBound(bounds, "width", ref widthMin, ref widthMax, errors);
            }

            IDictionary defaultsRaw = Section(raw, "defaults", errors);
            if (defaultsRaw != null)
            {
                CheckKeys(defaultsRaw, Classes, "defaults", errors);
                foreach (string name in Classes)
                {
                    if (defaultsRaw.Contains(name) && defaultsRaw[name] != null)
                    {
                        FileLimit given = ReadLimit(defaultsRaw[name], "defaults." + name, errors);
                        if (given != null)
                        {
                            FileLimit shipped = DefaultLimits[name];
                            defaultsValue[name] = new FileLimit(given.length ?? shipped.length, given.width ?? shipped.width);
                        }
                    }
                }
            }

            IDictionary classesRaw = Section(raw, "classes", errors);
            if (classesRaw != null)
            {
                classesValue.Clear();
                foreach (object key in classesRaw.Keys)
                {
                    string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                    string value = classesRaw[key] as string;
                    if (value == null || (value != Unmeasured && Array.IndexOf(Classes, value) < 0))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "classes.{0} '{1}' must be one of {2}, {3}", name, classesRaw[key], string.Join(", ", Classes), Unmeasured));
                    }
                    else
                    {
                        classesValue[name] = value;
                    }
                }
            }

            IDictionary extensionsRaw = Section(raw, "extensions", errors);
            if (extensionsRaw != null)
            {
                extensionsValue.Clear();
                foreach (object key in extensionsRaw.Keys)
                {
                    string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                    string value = extensionsRaw[key] as string;
                    if (string.IsNullOrWhiteSpace(name) || name.IndexOfAny(new[] { '/', '\\' }) >= 0)
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "extensions: '{0}' must be an extension starting with a dot or a bare file name", name));
                    }
                    else if (value == null || (value != Unmeasured && Array.IndexOf(Classes, value) < 0))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "extensions.{0} '{1}' must be one of {2}, {3}", name, extensionsRaw[key], string.Join(", ", Classes), Unmeasured));
                    }
                    else
                    {
                        extensionsValue[name] = value;
                    }
                }
            }

            IDictionary widthModeRaw = Section(raw, "width_mode", errors);
            if (widthModeRaw != null)
            {
                CheckKeys(widthModeRaw, Classes, "width_mode", errors);
                foreach (string name in Classes)
                {
                    if (widthModeRaw.Contains(name) && widthModeRaw[name] != null)
                    {
                        string mode = widthModeRaw[name] as string;
                        if (mode == null || Array.IndexOf(WidthModes, mode) < 0)
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "width_mode.{0} '{1}' must be one of {2}", name, widthModeRaw[name], string.Join(", ", WidthModes)));
                        }
                        else
                        {
                            widthModeValue[name] = mode;
                        }
                    }
                }
            }

            IDictionary exemptRaw = Section(raw, "exempt", errors);
            if (exemptRaw != null)
            {
                foreach (object key in exemptRaw.Keys)
                {
                    string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                    string reason = exemptRaw[key] as string;
                    if (string.IsNullOrWhiteSpace(reason))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "exempt.{0} must give a one-line reason", name));
                    }
                    else
                    {
                        exemptValue[name.Replace('\\', '/')] = reason;
                    }
                }
            }

            IDictionary languagesRaw = Section(raw, "languages", errors);
            if (languagesRaw != null)
            {
                foreach (object key in languagesRaw.Keys)
                {
                    string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                    if (string.IsNullOrWhiteSpace(name))
                    {
                        errors.Add("languages: a language name must not be blank");
                        continue;
                    }

                    FileLimit given = ReadLimit(languagesRaw[key], "languages." + name, errors);
                    if (given != null)
                    {
                        languagesValue[name] = given;
                    }
                }
            }
        }

        if (lengthMin > lengthMax)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "bounds.length: min {0} is above max {1}", lengthMin, lengthMax));
        }

        if (widthMin > widthMax)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "bounds.width: min {0} is above max {1}", widthMin, widthMax));
        }

        foreach (KeyValuePair<string, FileLimit> pair in defaultsValue)
        {
            CheckInBounds("defaults." + pair.Key, pair.Value, lengthMin, lengthMax, widthMin, widthMax, errors);
        }

        foreach (KeyValuePair<string, FileLimit> pair in languagesValue)
        {
            CheckInBounds("languages." + pair.Key, pair.Value, lengthMin, lengthMax, widthMin, widthMax, errors);
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("file-limits configuration validation failed:\n" + string.Join("\n", errors));
        }

        length_min = lengthMin;
        length_max = lengthMax;
        width_min = widthMin;
        width_max = widthMax;
        defaults = defaultsValue;
        languages = languagesValue;
        classes = classesValue;
        extensions = extensionsValue;
        width_mode = widthModeValue;
        exempt = exemptValue;
    }

    public ResolvedFileLimit ResolveFile(string path, string language)
    {
        string fileName = System.IO.Path.GetFileName(path ?? string.Empty);
        string extension = System.IO.Path.GetExtension(fileName);
        string key = extensions.ContainsKey(fileName) ? fileName : extension;
        if (string.IsNullOrEmpty(key) || !extensions.TryGetValue(key, out string fileClass))
        {
            if (string.IsNullOrEmpty(language))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "'{0}' is unclassified: no language, extension or file name in file-limits declares it", path));
            }

            return Resolve(language);
        }

        string cacheKey = "extensions." + key.ToLowerInvariant();
        if (resolved.TryGetValue(cacheKey, out ResolvedFileLimit hit))
        {
            return hit;
        }

        ResolvedFileLimit result = fileClass == Unmeasured
            ? new ResolvedFileLimit(language, fileClass, null, null, null, null)
            : new ResolvedFileLimit(language, fileClass, defaults[fileClass].length, cacheKey, defaults[fileClass].width, cacheKey);
        resolved[cacheKey] = result;
        return result;
    }

    // One lookup per language, cached for the run: the language value if set, else its class default; no merging.
    public ResolvedFileLimit Resolve(string language)
    {
        if (resolved.TryGetValue(language, out ResolvedFileLimit hit))
        {
            return hit;
        }

        if (!classes.TryGetValue(language, out string fileClass))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "language '{0}' has no class in file-limits classes (allowed classes: {1}, {2})", language, string.Join(", ", Classes), Unmeasured));
        }

        ResolvedFileLimit result;
        if (fileClass == Unmeasured)
        {
            result = new ResolvedFileLimit(language, fileClass, null, null, null, null);
        }
        else
        {
            FileLimit classLimit = defaults[fileClass];
            languages.TryGetValue(language, out FileLimit own);
            bool ownLength = own != null && own.length.HasValue;
            bool ownWidth = own != null && own.width.HasValue;
            result = new ResolvedFileLimit(language, fileClass,
                ownLength ? own.length : classLimit.length, ownLength ? "languages." + language : "defaults." + fileClass,
                ownWidth ? own.width : classLimit.width, ownWidth ? "languages." + language : "defaults." + fileClass);
        }

        resolved[language] = result;
        return result;
    }
}
