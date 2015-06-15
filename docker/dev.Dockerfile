FROM adreeve/aspnet:1.0.0-beta6

VOLUME /app
WORKDIR /app

# Volume for nuget package cache
RUN mkdir -p /home/aspnet/.local/
RUN chown -R aspnet:aspnet /home/aspnet/.local
VOLUME ["/home/aspnet/.local"]

# DNX package directory
RUN mkdir -p /home/aspnet/.dnx
RUN chown -R aspnet:aspnet /home/aspnet/.dnx
VOLUME ["/home/aspnet/.dnx"]

EXPOSE 5004
