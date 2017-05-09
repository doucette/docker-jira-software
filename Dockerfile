FROM doucette/oracle-java:8

RUN groupadd -r jira && useradd -r -g jira jira

ENV JIRA_HOME /var/atlassian/jira
ENV JIRA_INSTALL /opt/atlassian/jira
ENV JIRA_VERSION 7.3.6

RUN set -ex; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        ; \
    mkdir -p "${JIRA_HOME}"; \
    mkdir -p "${JIRA_INSTALL}"; \
    curl -Ls "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz" | \
        tar -xzC "${JIRA_INSTALL}" --strip-components=1; \
    chown -R jira:jira "${JIRA_HOME}"; \
    chown -R jira:jira "${JIRA_INSTALL}"; \
    chmod -R 700 "${JIRA_HOME}"; \
    chmod -R 700 "${JIRA_INSTALL}"; \
    echo "jira.home=${JIRA_HOME}" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties"; \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8080/tcp

VOLUME ["${JIRA_HOME}", "${JIRA_INSTALL}/logs"]

WORKDIR "${JIRA_INSTALL}"

USER jira

CMD ["./bin/start-jira.sh", "-fg"]
