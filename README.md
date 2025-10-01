# Code Analyzers Reusable StyleCop Nuget Package Library

[![NuGet](https://img.shields.io/nuget/v/Bet.CodeAnalyzers.svg)](https://www.nuget.org/packages?q=Bet.CodeAnalyzers)
![Nuget](https://img.shields.io/nuget/dt/Bet.CodeAnalyzers)

![I Stand With Israel](./img/IStandWithIsrael.png)

> The second letter in the Hebrew alphabet is the ב bet/beit. Its meaning is "house". In the ancient pictographic Hebrew it was a symbol resembling a tent on a landscape.

## Project Features and Benefits

- Re-usable, versioned ruleset and analyzer packaging that can be shared across solutions and teams.
- Ships a curated set of StyleCop and Roslyn analyzer rules tuned for consistency and maintainability.
- Includes an optional default `.editorconfig` package to standardize formatting and code-style settings.
- Easy integration via NuGet with minimal project changes.

Benefits:

- Ensures consistent code quality across teams and CI pipelines.
- Reduces onboarding time by providing a shared, tested ruleset.
- Simplifies policy enforcement in multi-repository organizations.

## Hire me

Please send [email](mailto:info@kingdavidconsulting.com) if you consider to **hire me**.

[![buymeacoffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/vyve0og)

## Give a Star! :star:

If you like or are using this project to learn or start your solution, please give it a star. Thanks!

## Install

```bash
     # analyzers and rules
     dotnet add package Bet.CodeAnalyzers

     # default .editorconfig
     dotnet add package Bet.EditorConfig
```

## Supported Analyzers

- StyleCop Analyzers (packaged rulesets)
- Roslyn-based analyzers (custom rules included in the package)
- .editorconfig settings delivered via `Bet.EditorConfig` package

## Usage Examples

Common scenarios:

- Enforce consistent naming, ordering, and layout rules across a solution.
- Fail CI builds on analyzer errors by treating warnings as errors in your CI configuration (see example below).

Treat warnings as errors (CI friendly example):

```xml
<PropertyGroup>
     <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
</PropertyGroup>
```

Best practices:

- Start by enabling the analyzers in a feature branch and fix high-priority warnings first.
- Use `.editorconfig` to tune formatting rules that are noisy for your codebase.
- Keep the NuGet package version pinned in CI to avoid unexpected changes.

## Requirements and Dependencies

- Supported .NET targets: netstandard2.0 (library), consumes analyzers in .NET Core and .NET Framework projects that support Roslyn analyzers.
- Compatible IDEs: Visual Studio 2019+, Visual Studio 2022+, JetBrains Rider, VS Code with C# extension (omnisharp/Roslyn support).
- Build tools: dotnet SDK 3.1+ / .NET SDK 5.0+ recommended for modern builds; analyzers work during msbuild-based builds.

## References

- [Shipping a cross-platform MSBuild task in a NuGet package](https://natemcmaster.com/blog/2017/07/05/msbuild-task-in-nuget/)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes to this project.
