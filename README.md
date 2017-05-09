# Atlassian JIRA Software Dockerfile

A containerized copy of Atlassian JIRA Software that uses an external database.

## Setup

1. Create a network for the database server and JIRA Software containers to communicate.

   ```shell
   docker network create jira-network
   ```

1. Start a database server. This example uses PostgreSQL because it is recommended by Atlassian.

   ```shell
   docker volume create jira-postgres
   docker run --name jira-postgres \
              --network jira-network \
              -e LANG=C.UTF-8 \
              -e POSTGRES_USER=jira \
              -e POSTGRES_PASSWORD=REPLACE_WITH_YOUR_PASSWORD \
              -v jira-postgres:/var/lib/postgresql/data \
              -d postgres:9.3
   ```

1. Start JIRA.

   ```shell
   docker volume create jira-home
   docker volume create jira-logs
   docker run --name jira \
              --network jira-network \
              -v jira-home:/var/atlassian/jira \
              -v jira-logs:/opt/atlassian/jira/logs \
              -p 8080:8080/tcp \
              -d doucette/jira-software
   ```

1. Connect to JIRA and follow through the steps for JIRA Setup.
   1. Navigate to `http://[dockerhost]:8080/` in a browser.
   1. Select "I'll set it up myself" and press Next.
   1. Select "My Own Database" and fill out the details then press Next.
      - Database Type: PostgreSQL
      - Hostname: jira-postgres
      - Database: jira
      - Username: jira
      - Password: `POSTGRES_PASSWORD` from the database step.
   1. Continue with the remainder of the setup process.
