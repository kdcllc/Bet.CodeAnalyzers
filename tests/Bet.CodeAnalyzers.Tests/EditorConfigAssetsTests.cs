using System.IO;
using System.Linq;
using Xunit;

namespace Bet.CodeAnalyzers.Tests
{
    public class EditorConfigAssetsTests
    {
        [Fact]
        public void AssetsFolderContainsFiles()
        {
            // Find repository root by walking up until solution file is found
            var dir = new DirectoryInfo(Directory.GetCurrentDirectory());
            DirectoryInfo repoRoot = null;
            while (dir != null)
            {
                if (File.Exists(Path.Combine(dir.FullName, "Bet.CodeAnalyzers.sln")))
                {
                    repoRoot = dir;
                    break;
                }
                dir = dir.Parent;
            }

            Assert.NotNull(repoRoot);

            var assetsDir = Path.Combine(repoRoot.FullName, "src", "Bet.EditorConfig", "assets");
            Assert.True(Directory.Exists(assetsDir), $"Expected assets directory at {assetsDir}");

            var files = Directory.EnumerateFiles(assetsDir, "*", SearchOption.AllDirectories).ToList();
            Assert.True(files.Count > 0, "Expected at least one file under src/Bet.EditorConfig/assets/");
        }
    }
}
