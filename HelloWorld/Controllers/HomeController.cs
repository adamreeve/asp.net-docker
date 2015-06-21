using Microsoft.AspNet.Mvc;
using HelloMvc.Web.Models;
using ServiceStack.Redis;
using System;
using System.Globalization;
using System.Net;

namespace HelloMvc.Web
{
    public class HomeController : Controller
    {
        private IRedisClientsManager _redisManager;

        public HomeController(IRedisClientsManager redisManager)
        {
            _redisManager = redisManager;
        }

        public IActionResult Index()
        {
            return View(Hello());
        }

        public Hello Hello()
        {
            string cachedTime;

            using (IRedisClient redis = _redisManager.GetClient())
            {
                cachedTime = redis.GetEntry("hello:time");
                if (cachedTime == null)
                {
                    var culture = new CultureInfo("en-NZ");
                    cachedTime = DateTime.UtcNow.ToString(culture);
                    redis.SetEntry("hello:time", cachedTime, TimeSpan.FromSeconds(60.0));
                }
            }

            return new Hello
            {
                Name = "World",
                Host = Dns.GetHostName(),
                CachedTime = cachedTime,
            };
        }
    }
}
