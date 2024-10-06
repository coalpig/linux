
```
FROM maven:3.9.6
COPY xzs /xzs
COPY settings.xml /usr/share/maven/conf
COPY m2 /root/.m2
RUN cd /xzs && mvn clean package 


FROM openjdk:8
COPY --from=0 /xzs/target/xzs-3.9.0.jar /opt
COPY start.sh /opt/
CMD ["bash","/opt/start.sh"]
EXPOSE 8000
```


