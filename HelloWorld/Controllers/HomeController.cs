using HelloMvc.Web.Models;
using Microsoft.AspNet.Mvc;
using Microsoft.Framework.Logging;
using ServiceStack.Redis;
using System;
using System.Globalization;
using System.Net;

namespace HelloMvc.Web
{
    public class HomeController : Controller
    {
        private IRedisClientsManager _redisManager;
        private ILogger _logger;

        public HomeController(IRedisClientsManager redisManager, ILoggerFactory loggerFactory)
        {
            _redisManager = redisManager;
            _logger = loggerFactory.CreateLogger(typeof(HomeController).FullName);
        }

        public IActionResult Index()
        {
            return View(Hello());
        }

        public IActionResult Ping()
        {
            return new HttpStatusCodeResult(200);
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
                Name = "Xero Unconference",
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
                _logger.LogWarning(String.Format("Redis error: {0}", re.Message));
                return f();
            }

        }
    }
}
