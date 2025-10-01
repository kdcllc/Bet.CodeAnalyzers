<!-- GitHub Copilot / AI Agent instructions for the Bet.CodeAnalyzers repo -->
# Bet.CodeAnalyzers — Quick instructions for AI coding agents

Purpose: give an AI agent the minimal, high-value knowledge to be productive in this repository: how the project is organized, build & packaging conventions, common patterns, and integration points.

1) Big-picture architecture
- Repo contains two main deliverables under `src/`:
  - `Bet.CodeAnalyzers` (library of Roslyn/StyleCop analyzer rules and packaging artifacts). Key files: `src/Bet.CodeAnalyzers/Bet.CodeAnalyzers.csproj`, `src/Bet.CodeAnalyzers/build/Bet.CodeAnalyzers.ruleset`, `stylecop.json`.
  - `Bet.EditorConfig` (MSBuild task + assets that provide a packaged `.editorconfig`). Key files: `src/Bet.EditorConfig/Bet.EditorConfig.csproj`, `src/Bet.EditorConfig/InstallEditorConfigTask.cs`, `src/Bet.EditorConfig/assets/`.

- Packaging model: both projects are marked as DevelopmentDependency and packaged via MSBuild/NuGet. `Directory.Build.props` imports `build/settings.props` which controls versioning and packaging (GeneratePackageOnBuild=true). The editorconfig project includes assets under `assets/` and writes them to `build` in the nupkg.

2) Why the layout matters
- The `Bet.EditorConfig` project ships an MSBuild task (`InstallEditorConfigTask`) that copies a `.editorconfig` into consumer projects when the package is installed. Keep changes to that task minimal and keep asset paths intact so packaging works.
- The analyzers project places packaging-related files under `build\` (ruleset, props/targets) and includes `stylecop.json` to be embedded in the package. Changing paths or ItemGroup PackagePath settings will break packaging.

3) Build, pack, and local test workflows
- Typical local build (restore, build, pack): use dotnet CLI at repo root. The repo uses properties in `build/settings.props` for package metadata.
  - dotnet restore
  - dotnet build -c Release
  - dotnet pack -c Release  (pack is normally triggered by GeneratePackageOnBuild)

- Fast clean: run `./clean.sh` to remove `bin/` and `obj/` folders across the repo.

4) Important files and conventions to reference when editing
- `Directory.Build.props` and `build/settings.props` — global build/package settings (version, pack on build, authors, RepositoryUrl).
- `src/Bet.CodeAnalyzers/Bet.CodeAnalyzers.csproj` — references analyzers (StyleCop, Roslynator) and includes `build\**` into the package. If adding new analyzer rules, update PackageReference and `build/` content as needed.
- `src/Bet.EditorConfig/InstallEditorConfigTask.cs` — MSBuild Task used at install time; uses AppContext.BaseDirectory to locate the packaged `.editorconfig`. If modifying, preserve behavior that uses package base directory.
- `src/Bet.EditorConfig/assets/` — files that are packaged into the nupkg root. Do not change PackagePath in csproj unless you understand NuGet packaging consequences.

5) Patterns and code style specific to this repo
- DevelopmentDependency: both projects use `DevelopmentDependency=true` in csproj. This signals these packages are developer-only and should not be transitively applied as runtime dependencies.
- Packaging approach: content and build folder packaging is used to deliver MSBuild targets and editorconfig files via NuGet; maintain the `None Include=... Pack=true` and `PackagePath="build\"` patterns shown in `Bet.CodeAnalyzers.csproj`.

6) Typical small tasks an AI might be asked to do (how to proceed)
- Add a new analyzer dependency: update `src/Bet.CodeAnalyzers/Bet.CodeAnalyzers.csproj` PackageReference and validate by building and inspecting `build/bin`/nupkg contents.
- Update the default `.editorconfig` shipped by `Bet.EditorConfig`: edit files under `src/Bet.EditorConfig/assets/`, run `dotnet build` and inspect the produced package under `build/bin` to verify the file is present at package root.
- Modify `InstallEditorConfigTask`: keep logging and exception handling consistent; ensure `ReferenceEditorConfig` default path (AppContext.BaseDirectory + ".editorconfig") is preserved for package-installed behavior.

7) Tests and CI
- This repo does not contain an automated test project. Validate changes locally by building and inspecting the generated nupkg or the `build/bin` output under `src/Bet.EditorConfig` and `src/Bet.CodeAnalyzers/obj/Debug`.

8) Troubleshooting tips (observed issues and fixes)
- If a packaged `.editorconfig` is missing, check `Bet.EditorConfig.csproj` Packaging ItemGroup and the `Content Include="assets\**" PackagePath="\"` line.
- If analyzers are not applied by consumer projects, ensure the package includes `build\` folder content (msbuild props/targets and ruleset) — check `ItemGroup` that includes `build\**` with `Pack='True'` and `PackagePath='build\'`.

9) Examples to reference in PRs
- Mention file changes to these when editing packaging behavior: `build/settings.props`, `src/Bet.CodeAnalyzers/Bet.CodeAnalyzers.csproj`, `src/Bet.EditorConfig/InstallEditorConfigTask.cs`, `src/Bet.EditorConfig/assets/`.

10) What not to change lightly
- Do not rename or move files under `src/*/build/` or `src/*/assets/` unless also updating packaging settings and verifying the nupkg contents. These are sensitive to path changes.

If anything here is unclear or you'd like deeper examples (package validation steps, how to add an analyzer rule, or sample PR templates), tell me which area to expand and I will update this file.
