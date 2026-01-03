# Use the official SQL Server 2022 image as the base
FROM mcr.microsoft.com/mssql/server:2022-latest


USER root


RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list > /etc/apt/sources.list.d/mssql-server.list && \
    apt-get update && \
    apt-get install -y mssql-server-fts && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER mssql

# (Optional) Enable the SQL Agent if you need it for scheduling jobs
# RUN /opt/mssql/bin/mssql-conf set sqlagent.enabled true
