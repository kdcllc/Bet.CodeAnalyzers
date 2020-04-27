# Code Analyzers Reusable StyleCop Nuget Package Library

[![Build status](https://ci.appveyor.com/api/projects/status/ywdhk854tdo6ne1s/branch/master?svg=true)](https://ci.appveyor.com/project/kdcllc/bet-codeanalyzers/branch/master)
[![NuGet](https://img.shields.io/nuget/v/Bet.CodeAnalyzers.svg)](https://www.nuget.org/packages?q=Bet.CodeAnalyzers)
![Nuget](https://img.shields.io/nuget/dt/Bet.CodeAnalyzers)
[![MyGet](https://img.shields.io/myget/kdcllc/v/Bet.CodeAnalyzers.svg?label=myget)](https://www.myget.org/F/kdcllc/api/v2)

Re-usable 'ruleset' nuget package for Code Analyzers.

## Publish Nuget Package

Update version # in the following files:

1. Bet.CodeAnalyzers.nuspec
2. Bet.CodeAnalyzers.props

```bash
    dotnet pack -c Release /p:NuspecFile=Bet.CodeAnalyzers.nuspec /p:GeneratePackageOnBuild=true
```

## References

- [Sharing configuration among solutions](https://github.com/DotNetAnalyzers/StyleCopAnalyzers/blob/master/documentation/Configuration.md#sharing-configuration-among-solutions)
- [MyCustomStyleCopAnalyzerPackage](https://github.com/markvincze/MyCustomStyleCopAnalyzerPackage)
- [Create a NuGet package using the dotnet CLI](https://docs.microsoft.com/en-us/nuget/create-packages/creating-a-package-dotnet-cli)
- [How to get a stylecop ruleset trough nuget in a .net standard project](https://stackoverflow.com/questions/52742473/how-to-get-a-stylecop-ruleset-trough-nuget-in-a-net-standard-project)