# Phala PRB VO 集群部署教程
---
### ❀ PRB V2 部署教程请[切换到Next分支](https://github.com/suugee/phala-prb/tree/next)

### 本教程使用的集群架构：
![本方案使用的集群架构](https://github.suugee.workers.dev/https://raw.githubusercontent.com/suugee/phala-prb/main/prb.png)

本方案适合2-50台机器小型集群，也可以单独一台机器运行prb，如果集群更大，考虑node稳定性问题可以使用多node做主备、负载均衡或者[联系苏格](#联系苏格)为您定制集群方案，公益教程不提供其他免费指导请谅解。


# 目录
- [系统要求](#系统要求)
- [Node机部署](#1-node机部署)
  - [安装docker环境](#安装docker环境)
  - [启动Node容器](#安装docker环境)
- [Prb机部署](#2-prb机部署)
  - [启动Prb容器](#2-prb机部署)
  - [访问Monitor](#访问monitorhttpprb机器ip地址3000)
- [Worker机部署](#3-worker机部署)
  - [安装docker环境](#worker安装基础环境)
  - [启动pruntime容器](#启动pruntime)
---
### 系统要求
- Ubuntu LTS 20.04
- Docker ≥ 20.10或更新
- Docker ≥ Compose 1.29 或更新
- CPU ≥ 10核以上高主频（i9十代、AMD3950X等）
- 内存 ≥ 32G
- 硬盘 ≥ 2T M.2 NVME
- 内网 千兆交换机，千兆网卡，六类/超六类千兆网线
- 以上为跑node+prb机器的建议配置，非worker机要求，worker机必须要支持SGX。
---
### 1. Node机部署

#### 安装Docker环境
```
# 切换root
sudo -i
# 安装Docker
curl -sSL https://get.daocloud.io/docker | sh
# 安装Docker-compose
wget -O /usr/local/bin/docker-compose https://get.daocloud.io/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64
chmod +x /usr/local/bin/docker-compose
```
#### 安装好基础环境后下载docker-compose配置文件，并启动node。
```
# 创建目录
mkdir -p /opt/phala
# 下载yml文件
wget -O /opt/phala/docker-compose.yml https://raw.githubusercontent.com/suugee/phala-prb/main/pha_cluster.yml
cd /opt/phala/ && docker-compose up -d node
```
- 如果需要指定Node数据存储位置请修改/opt/phala/docker-compose.yml 好后再启动。
---
### 2. Prb机部署
#### 如果和node机部署在同一台则无需重复安装Docker环境和下载配置文件：
```
cd /opt/phala/
docker-compose up -d redis io	  #启动基础服务
docker-compose up -d fetch	  #启动fetch服务
docker-compose up -d trade	  #启动trade服务
docker-compose up -d lifecycle	  #启动lifecycle服务
docker-compose up -d monitor	  #启动monitor服务
```
#### 访问monitor：http://prb机器ip地址:3000
- Monitor添加pool，worker等操作就不写了，按照页面上的提示操作即可，添加worker地址记得 http://ip:8000 带上8000端口，添加完worker后需要重启lifecycle容器，实在搞不明白可以联系苏格付费指导。
---

### 3. Worker机部署
#### 安装基础环境
  - 1.docker
  - 2.docker-compose
  - 3.sgx driver
  - 注：可以使用手动部署或者通过修改官方solo脚本来达到环境和pruntime部署
#### 启动pruntime

---
### 常用命令
+ Node机常用操作
```
启动容器：docker-compose up -d node
停止容器：docker stop node
移除容器: docker rm node
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
启动容器：docker-compose up -d pruntime
停止容器: docker stop pruntime
移除容器: docker rm pruntime
查看日志: docker logs -f pruntime
```
---
+ 官方论坛：https://forum.phala.network/
+ 官方wiki：https://wiki.phala.network/
+ 官方Github: https://github.com/Phala-Network
+ 官方Telegram：https://t.me/phalaCN

### 联系苏格
+ 苏格VX：suugee_bit
+ 苏格QQ：6559178
+ 苏格Telegram：https://t.me/sparksure
+ 苏格Github：https://github.com/suugee/phala-prb
