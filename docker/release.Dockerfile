FROM adreeve/aspnet:1.0.0-beta6

USER root

COPY ./HelloWorld /app
RUN chown -R aspnet:aspnet /app

USER aspnet

WORKDIR /app

RUN ./restore.sh

EXPOSE 5004
CMD ["dnx", ".", "kestrel"]
