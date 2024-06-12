FROM debian:bullseye

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget curl unzip libicu-dev

ENV UID=568
ENV GID=568

ENV APP_HOME=/app
ENV APP_CONFIG_DIR=${APP_HOME}/conf
ENV APP_CONFIG_TEMPLATE_FILE=${APP_HOME}/server_config.toml
ENV APP_CONFIG_FILE=${APP_CONFIG_DIR}/server_config.toml

ENV SERVER_BUILDS_PAGE="https://central.spacestation14.io/builds/wizards/builds.html"
ENV SERVER_BUILDS_PAGE_REGEX_PATTERN="<a href='https://cdn.centcomm.spacestation14.com/builds/wizards/builds/[a-z0-9]+/SS14.Server_linux-x64.zip'>Linux x64</a>"

# Set up a working directory
WORKDIR ${APP_HOME}

RUN mkdir /opt/dotnet

# Create a new group and user
RUN addgroup --gid $GID apps && \
    adduser --disabled-password --gecos '' --uid $UID --gid $GID apps

COPY entrypoint.sh /
RUN chown -R apps:apps ${APP_HOME} /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Switch to the apps user
USER apps

EXPOSE 1212/tcp
EXPOSE 1212/udp

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "./Robust.Server", "--config-file", "${APP_CONFIG_FILE}" ]
