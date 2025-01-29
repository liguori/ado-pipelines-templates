using System;
using Xunit;

namespace Demo.NET.Tests
{
    public class FooTest
    {
        [Fact]
        public void Bar_IsExecuting()
        {
            var page = new Demo.NET.Web.Pages.IndexModel(null);
            page.OnGet();
            Assert.True(true, "Bar test is executing");
        }


        [Fact]
        public void AlphaTest_IsExecuting()
        {
            Assert.True(true, "AlphaTest test is executing");
        }
    }
}
