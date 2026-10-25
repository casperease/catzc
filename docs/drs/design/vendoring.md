# Design: Vendoring — a vendor is a tool vendored into the repository

## Rules: DDR-VENDOR

### Rule DDR-VENDOR-VENDORISVENDORED

A **vendor** is a tool, a core, a plugin or an external dependency that the repository vendors: it keeps a copy of what it uses, and the
copy is part of the commit. A vendor is named by the tool, and a short form is fine (`git`, `azure`, `ado`, `ai`). The name says what is
vendored, never the platform that reads a file and never the third party that wrote it.

- [What a vendor is](#what-a-vendor-is)

### Rule DDR-VENDOR-ONEUMBRELLA

Everything vendored sits under **one vendor umbrella**: every `.vendor` folder holding third-party code, and every vendor's settings, the
files the repository keeps to configure that tool. A vendor's settings are never a separate kind from its code, and a vendor is never mixed
into another vendor's track ([DDR-TRACKTYPE-OPTIONALVENDOR](track-types.md#rule-ddr-tracktype-optionalvendor)). The track name of a vendor
starts with the vendor, per DDR-TRACKTYPE naming (pending).

- [One umbrella](#one-umbrella)

### Rule DDR-VENDOR-HEADREPRODUCIBLE

Vendoring is how **HEAD stays reproducible and atomic through BVT**. The repository holds the vendored copy and the settings that drive it,
so one commit is everything the build, the verification and the promotion read: no fetch from a feed at build time, and no tool version that
moved between two stages of one commit. A change to a vendor, its code or its settings, is a change to the commit like any other, reviewed
and promoted with it.

- [Why vendor](#why-vendor)

## Context

The repository leans on tools it does not write: a shell framework, a linter, a cloud toolchain, an assistant's settings, a pipeline
platform's configuration. Some are code the repository carries (`pwsh/.vendor`, `bash/.vendor`); some are files that configure a tool
(`.gitignore`, `.editorconfig`, `.claude`). Treating the two as different things scattered the same concern: which tool is this, and does
the commit hold everything of it.

### What a vendor is

The tool is the unit. `.gitignore`, `.gitattributes` and `.github` are git's and its host's; a Bicep toolchain and its parameters are
azure's; the assistant's settings are ai's. The test is that the repository keeps the tool's copy or configuration in itself, so the commit,
and nothing outside it, decides what the tool does.

### One umbrella

One umbrella means one place to ask "what does this repository vendor", one definition of the word, and one rule for how a vendor's files
are tracked, so a gate, a filter and a lamp never carry a second list. The umbrella is a concept the tracks realise, declared once with the
tracks ([DDR-TRACKTYPE-DECLAREDONCE](track-types.md#rule-ddr-tracktype-declaredonce)).

### Why vendor

BVT must prove the commit that will be promoted. A tool fetched at build time makes the proof depend on a moment, and a setting kept outside
the repository makes it depend on a console. Vendoring puts both into HEAD, so the verdict of an earlier stage still holds for the later one
([TDR-ONETRUTH](../thesis/one-source-of-truth.md), [PDR-ONELIVE](../principles/one-living-version.md)).

## Decision

Name the vendor by its tool ([DDR-VENDOR-VENDORISVENDORED](#rule-ddr-vendor-vendorisvendored)), keep all vendored code and all vendor
settings under one umbrella ([DDR-VENDOR-ONEUMBRELLA](#rule-ddr-vendor-oneumbrella)), and vendor so that HEAD is the whole input of BVT
([DDR-VENDOR-HEADREPRODUCIBLE](#rule-ddr-vendor-headreproducible)).

## Consequences

- "What does the repository vendor" has one answer, read from the track declarations.
- A tool upgrade is a reviewed commit, not a moment in a pipeline.
- The repository carries the weight of the copies, and an update path for each vendor.
