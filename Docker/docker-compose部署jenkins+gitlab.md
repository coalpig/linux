```
services:
  jenkins:
    image: abc.com/jenkins/jenkins:lts-jdk17
    container_name: jenkins
    user: root
    volumes:
      - /usr/bin/docker:/usr/bin/docker
      - /root/.ssh:/root/.ssh
      - /run/docker.sock:/run/docker.sock
      - /etc/docker:/etc/docker
      - /root/.docker:/root/.docker
      - /usr/libexec/docker/:/usr/libexec/docker/
      - /etc/docker/certs.d/abc.com/ca.crt:/usr/local/share/ca-certificates/ca.crt
      - /data/jenkins_home:/var/jenkins_home
    ports:
      - 8080:8080
      - 50000:50000

  gitlab:
    image: abc.com/gitlab/gitlab-ce
    container_name: gitlab
    user: root
    volumes:
      - /data/gitlab/config:/etc/gitlab
      - /data/gitlab/logs:/var/log/gitlab
      - /data/gitlab/data:/var/opt/gitlab
    ports:
      - 80:80
      - 2222:22
    environment:
      GITLAB_OMNIBUS_CONFIG: |
	    external_url 'http://10.0.0.21'
        gitlab_rails['gitlab_shell_ssh_port'] = 2222

  nexus:
    image: abc.com/sonatype/nexus3
    container_name: nexus 
    user: root
    ports:
      - 8081:8081
    volumes:
      - /data/nexus-data:/sonatype-work
```