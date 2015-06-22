using Microsoft.AspNet.Builder;
using Microsoft.AspNet.Diagnostics;
using Microsoft.AspNet.Routing;
using Microsoft.Framework.DependencyInjection;
using Microsoft.Framework.Runtime;
using ServiceStack.Redis;

namespace HelloMvc
{
    public class Startup
    {
        private const string redisConnectionString = "redis";

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc();

            // Register redis client with ASP.NET dependency injection
            services.AddScoped<IRedisClientsManager>(c =>
                        new BasicRedisClientManager(redisConnectionString));
        }

        public void Configure(IApplicationBuilder app, IApplicationShutdown applicationShutdown)
        {
            // Add MVC to the request pipeline
            app.UseMvc(routes =>
            {
                routes.MapRoute(
                    name: "default",
                    template: "{controller}/{action}/{id?}",
                    defaults: new { controller = "Home", action = "Index" });
            });

            app.UseErrorPage();

            applicationShutdown.OnUnixSignals();
        }
    }
}
