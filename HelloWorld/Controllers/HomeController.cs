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
            var cachedTime = CachedValue("hello:time", TimeSpan.FromSeconds(60.0), () =>
                    {
                        var culture = new CultureInfo("en-NZ");
                        return DateTime.UtcNow.ToString(culture);
                    });

            return new Hello
            {
                Name = "World",
                Host = Dns.GetHostName(),
                CachedTime = cachedTime,
            };
        }

        private string CachedValue(string key, TimeSpan expiry, Func<string> f)
        {
            string val;
            try
            {
                using (IRedisClient redis = _redisManager.GetClient())
                {
                    val = redis.GetEntry(key);
                    if (val == null)
                    {
                        val = f();
                        redis.SetEntry(key, val, expiry);
                    }
                    return val;
                }
            }
            catch (RedisException re)
            {
                return f();
            }

        }
    }
}
