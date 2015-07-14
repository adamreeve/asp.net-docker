using Microsoft.AspNet.Builder;
using Microsoft.AspNet.Diagnostics;
using Microsoft.AspNet.Http;
using Microsoft.AspNet.Routing;
using Microsoft.Framework.DependencyInjection;
using Microsoft.Framework.Runtime;
using Microsoft.Framework.Logging;
using ServiceStack.Redis;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace HelloMvc
{
    public class Startup
    {
        private const string redisConnectionString = "redis";

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc();
            services.AddLogging();

            // Register redis client with ASP.NET dependency injection
            services.AddScoped<IRedisClientsManager>(c =>
                        new BasicRedisClientManager(redisConnectionString));
        }

        public void Configure(
                IApplicationBuilder app,
                IApplicationShutdown applicationShutdown,
                ILoggerFactory loggerFactory)
        {
            app.UseLogRequests();

            // Add MVC to the request pipeline
            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller}/{action}/{id?}",
                    defaults: new { controller = "Home", action = "Index" });
            });

            app.UseErrorPage();

            loggerFactory.AddConsole();

            applicationShutdown.OnUnixSignals();
        }
    }

    public static class LogRequestsExtension
    {
        public static IApplicationBuilder UseLogRequests(this IApplicationBuilder app)
        {
            return app.UseMiddleware<LogRequestsMiddleware>();
        }
    }

    public class LogRequestsMiddleware
    {
        RequestDelegate _next;
        private ILogger _logger;

        public LogRequestsMiddleware(RequestDelegate next, ILoggerFactory loggerFactory)
        {
            _next = next;
            _logger = loggerFactory.CreateLogger("Request");
        }

        public async Task Invoke(HttpContext context)
        {
            Action log = () =>
                {
                    _logger.LogInformation(String.Format(
                        "{0} {1}{2}{3} ({4})",
                        context.Request.Method,
                        context.Request.PathBase,
                        context.Request.Path,
                        context.Request.QueryString,
                        context.Response.StatusCode
                        ));
                };
            context.Response.OnStarting((state) =>
                {
                    return Task.Run(log);
                }, null);

            await _next(context);
        }
    }
}
