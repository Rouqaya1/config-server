FROM openjdk:17-jdk-slim

# Install dockerize (pour attendre que le discovery-server soit prêt)
ENV DOCKERIZE_VERSION v0.7.0

RUN apt-get update && \
    apt-get install -y wget ca-certificates && \
    wget -O dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize.tar.gz && \
    rm dockerize.tar.gz && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    apt-get clean

# Copie du JAR compilé
COPY target/spring-petclinic-config-server-3.0.2.jar app.jar

# Commande d’exécution avec dockerize pour attendre discovery-server
ENTRYPOINT ["dockerize", "-wait=tcp://discovery-server:8761", "-timeout=60s", "java", "-jar", "app.jar"]
#test pour le push r 