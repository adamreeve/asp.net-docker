using Microsoft.AspNet.Mvc;
using HelloMvc.Web.Models;
using System.Net;

namespace HelloMvc.Web
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View(Hello());
        }

        public Hello Hello()
        {
            return new Hello
            {
                Name = "World",
                Host = Dns.GetHostName(),
            };
        }
    }
}
