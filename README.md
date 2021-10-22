# Phala-prb 集群部署教程
# 目录
- [系统要求](#系统要求)
- [Node机部署](#1-node机部署)
  - [安装docker环境](#安装docker环境)
  - [启动Node容器](#安装docker环境)
- [Prb机部署](#2-prb机部署)
  - [启动Prb容器](#安装docker环境)
- [Worker机部署](#3-worker机部署)
  - [安装docker环境](#worker安装基础环境)
  - [启动pruntime容器](#启动pruntime)
---
### 系统要求
- Ubuntu LTS 20.04
- Docker 20.10或更新
- Docker Compose 1.29 或更新
- CPU 10核以上高主频（i9-10850K AMD3950X等）
- 内存 32G
- 硬盘 1T M.2 NVME
---
### 1. Node机部署

#### 安装Docker环境
```
# 切换root
sudo -i
# 安装Docker
curl -sSL https://get.daocloud.io/docker | sh
# 安装Docker-compose
curl -L https://get.daocloud.io/docker/compose/releases/download/v2.0.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```
#### 安装好基础环境后下载docker-compose配置文件，并启动node。
```
# 创建目录
mkdir -p /opt/phala
# 下载yml文件
wget -O /opt/phala/docker-compose.yml https://raw.githubusercontent.com/suugee/phala-prb/main/pha_cluster.yml
cd /opt/phala/
# 启动node
docker-compose up -d node
```
如果需要指定Node数据存储位置请修改/opt/phala/docker-compose.yml 好后再启动。
---
### 2. Prb机部署
#### 如果和node机部署在同一台则无需重复安装Docker环境：
```
# 切换root
sudo -i
# 创建目录
mkdir -p /opt/phala
# 下载yml文件
wget -O /opt/phala/docker-compose.yml https://raw.githubusercontent.com/suugee/phala-prb/main/pha_cluster.yml
cd /opt/phala/
docker-compose up -d redis io	  #启动基础服务
docker-compose up -d fetch	  #启动fetch服务
docker-compose up -d trade	  #启动trade服务
docker-compose up -d lifecycle	  #启动lifecycle服务
docker-compose up -d monitor	  #启动monitor服务
```
#### 访问monitor：http://prb机器ip地址:3000
---
### 3. Worker机部署
#### worker安装基础环境
```
sudo -i
cd ~
wget https://raw.githubusercontent.com/suugee/phala-prb/main/worker.sh
chmod +x worker.sh
./worker.sh install
```
#### 启动pruntime
```
sudo -i
mkdir -p /opt/phala
cd /opt/phala
mv docker-compose.yml docker-compose.yml.bak
wget -O /opt/phala/docker-compose.yml https://raw.githubusercontent.com/suugee/phala-prb/main/pha_cluster.yml
docker-compose up -d pruntime
```
---
### 常用命令
+ Node机常用操作
```
启动容器：docker-compose up -d node
查看日志：docker logs -f node -n 100
```
+ Prb机常用操作
```
docker-compose up -d redis io	#启动基础服务
docker-compose up -d fetch	#启动fetch服务
docker-compose up -d trade	#启动trade服务
docker-compose up -d lifecycle	#启动lifecycle服务
docker-compose up -d monitor	#启动monitor服务
docker ps -a   #查看容器状态
docker logs -f fetch   #查看fetch日志
```
+ Worker机常用操作
```
停止容器: docker stop pruntime
移除容器: docker rm pruntime
查看日志: docker logs -f pruntime
```
