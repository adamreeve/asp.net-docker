FROM adreeve/aspnet:1.0.0-beta6-12226

USER root

COPY ./HelloWorld /app
RUN chown -R aspnet:aspnet /app

USER aspnet

WORKDIR /app

COPY ./docker/nuget_cache /home/aspnet/.local
COPY ./docker/dnx_packages /home/aspnet/.dnx

EXPOSE 5004
CMD ["dnx", ".", "kestrel"]
