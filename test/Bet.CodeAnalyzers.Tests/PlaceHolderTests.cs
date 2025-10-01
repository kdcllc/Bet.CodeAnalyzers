using Xunit;
using Bet.CodeAnalyzers;

namespace Bet.CodeAnalyzers.Tests
{
    public class PlaceHolderTests
    {
        [Fact]
        public void CanInstantiatePlaceHolder()
        {
            var p = new PlaceHolder();
            Assert.NotNull(p);
        }
    }
}
