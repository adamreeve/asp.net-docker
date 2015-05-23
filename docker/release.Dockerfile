FROM adreeve/aspnet:1.0.0-beta4

USER root

COPY ./HelloWorld /app
RUN chown -R aspnet:aspnet /app

USER aspnet

WORKDIR /app

RUN dnu restore

EXPOSE 5004
CMD ["dnx", ".", "kestrel"]
