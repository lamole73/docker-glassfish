## Glassfish v2ur2 image ##
#  Glassfish v2ur2
#
# docker build --rm --tag="lamole73/glassfish-v2ur2:1" ./
# docker run -d -p 8080:8080 -p 4848:4848 --name docker_app_1 lamole73/glassfish-v2ur2:1
#
# to remove intermediate container and images if build fails use (with CAUTION)
# docker ps -a | grep "/bin/sh -c" | awk '{system("docker rm -v " $1)}' && docker images | grep "<none>" | awk '{system("docker image rm " $3)}'
#
# to remove container and image if build succeeds run
# docker rm -v docker_app_1 && docker image rm lamole73/glassfish:v2ur2:1
#
###
FROM openjdk:7u151-jdk-alpine

# [TEST ONLY] Only enable next line for testing, but make sure you add glassfish-installer-v2ur2-b04-linux.jar to the current folder
#ADD glassfish-installer-v2ur2-b04-linux.jar /usr/local

# Set environment variables
ENV GLASSFISH_PKG=/usr/local/glassfish-installer.jar \
    GLASSFISH_URL=http://dlc-cdn.sun.com/javaee5/v2ur2/promoted/Linux/glassfish-installer-v2ur2-b04-linux.jar \
#    GLASSFISH_URL=http://dlc-cdn.sun.com/javaee5/v2.1.1_branch/promoted/Linux/glassfish-installer-v2.1.1-b31g-linux.jar \
    GLASSFISH_HOME=/usr/local/glassfish \
    PATH=$PATH:/usr/local/glassfish/bin

# Download and install GlassFish on /usr/local
RUN \
    # Download and extract glassfish installation jar
	# [TEST ONLY] Only disable next line for testing, but make sure you add glassfish-installer-v2ur2-b04-linux.jar to the current folder and enable above ADD line
    wget -q -O $GLASSFISH_PKG $GLASSFISH_URL && \
    cd /usr/local && \
    echo A|java -jar $GLASSFISH_PKG && \
    rm -f $GLASSFISH_PKG && \
    \
    # Remove Windows .bat and .exe files to save space
    cd $GLASSFISH_HOME && \
    find . -name '*.bat' -delete && \
    find . -name '*.exe' -delete && \
    # Configure executables, modify setup.xml to support Java 7 then run setup
    cd $GLASSFISH_HOME && \
    chmod -R +x lib/ant/bin && \
    sed -i 's/1.6/1.7/g' setup.xml && \
    lib/ant/bin/ant -f setup.xml && \
    chmod a+x bin/asadmin && \
    # Remove expired key from certificate (SEC5054 Certificate has expired error)
    # Solution from: https://stackoverflow.com/a/19591433/1700053
    keytool -storepass changeit -delete -v -alias gtecybertrustglobalca -keystore $GLASSFISH_HOME/domains/domain1/config/cacerts.jks && \
    keytool -storepass changeit -delete -v -alias gtecybertrust5ca -keystore $GLASSFISH_HOME/domains/domain1/config/cacerts.jks && \
    keytool -storepass changeit -delete -v -alias verisignserverca -keystore $GLASSFISH_HOME/domains/domain1/config/cacerts.jks

# Ports being exposed
EXPOSE 4848 8080 8181

WORKDIR /usr/local/glassfish

# Copy in and set the entrypoint
COPY docker-entrypoint.sh $GLASSFISH_HOME/
ENTRYPOINT ["/usr/local/glassfish/docker-entrypoint.sh"]

# Start the GlassFish domain
CMD ["asadmin", "start-domain", "--verbose"]

LABEL maintainer="Lampros Oikonomou <lamole73@gmail.com>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="GlassFish" \
      org.label-schema.version="2ur2" \
      org.label-schema.url="https://glassfish.java.net" \
      org.label-schema.vcs-url="https://github.com/lamole73/docker-glassfish/glassfish-v2ur2"

# Expose volume
VOLUME ["/docker-entrypoint.d/"]
