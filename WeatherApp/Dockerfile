# Use the official Tomcat 10 image
FROM tomcat:10.1-jdk17
# Copy your built WAR file into the Tomcat webapps directory
# (Assuming you build it as WeatherApp.war)
COPY target/WeatherApp.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]