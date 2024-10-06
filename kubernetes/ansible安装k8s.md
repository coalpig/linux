```
1.官方文档
https://github.com/easzlab/kubeasz/blob/master/docs/setup/00-planning_and_overall_intro.md

2.部署节点ssh免密认证
cat > /etc/hosts <<EOF
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
::1 localhost localhost.localdomain localhost6 localhost6.localdomain6
10.0.0.11 master-01
10.0.0.12 master-02
10.0.0.13 master-03
10.0.0.21 node-01
10.0.0.22 node-02
EOF
yum install -y sshpass
ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa
for ip in {master-01,master-02,master-03,node-01,node-02};do sshpass -pyhhlcc ssh-copy-id -p 22 ${ip} -o StrictHostKeyChecking=no;done
for ip in {master-01,master-02,master-03,node-01,node-02};do ssh ${ip} hostname;done

3.部署节点安装管理工具并下载离线软件
export release=3.2.0
wget https://github.com/easzlab/kubeasz/releases/download/${release}/ezdown
chmod +x ./ezdown
./ezdown -D
./ezdown -P

4.部署k8s集群
#安装docker
wget https://download.docker.com/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
sed -i 's#download.docker.com#mirrors.tuna.tsinghua.edu.cn/docker-ce#' /etc/yum.repos.d/docker-ce.repo
yum -y install docker-ce-20.10.15 docker-ce-cli-20.10.15
systemctl start docker

#运行容器
./ezdown -S

#容器内执行集群初始化命令
docker exec -it kubeasz ezctl new k8s-01

#编辑节点host文件及集群配置文件
添加节点的地址
/etc/kubeasz/clusters/k8s-01/hosts

修改为离线安装
/etc/kubeasz/clusters/k8s-01/config.yml

#安装部署k8s
docker exec -it kubeasz ezctl setup k8s-01 all

5.安装新节点
ssh-copy-id 10.0.0.23
docker exec -it kubeasz ezctl add-node k8s-01 10.0.0.23


```