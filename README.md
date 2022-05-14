# Phala PRB V2 集群全新部署教程

### 如果你是PRB V0 升级 V2 [点击此处](https://github.com/suugee/phala-prb/blob/next/V0-V2.md)

### 本教程使用的集群架构：
![本方案使用的集群架构](https://github.suugee.workers.dev/https://raw.githubusercontent.com/suugee/phala-prb/main/prb.png)

本方案适合50台内小型集群，也可以单独一台机器运行prb，如果集群更大，考虑node稳定性问题可以使用多node做主备、负载均衡或者[联系苏格](#联系苏格)为您定制集群方案，公益教程不提供其他免费指导请谅解。


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
wget -O /opt/phala/node.yml https://github.suugee.workers.dev/https://raw.githubusercontent.com/suugee/phala-prb/next/node.yml

docker-compose -f /opt/phala/node.yml up -d
```
- 如果需要指定Node数据存储位置请修改 /opt/phala/node.yml 好后再启动。
---
### 2. Prb机部署
#### 如果和node机部署在同一台则无需重复安装Docker环境和下载配置文件：
```
# 下载yml配置文件
wget -O /opt/phala/docker-compose.yml https://github.suugee.workers.dev/https://raw.githubusercontent.com/suugee/phala-prb/next/docker-compose.yml

# 一键启动所有服务
docker-compose -f /opt/phala/docker-compose.yml up -d

```
#### 访问monitor：http://prb机器ip地址:3000     （在Monitor上可以手动单个添加Pool和Worker也可以通过下面的API批量添加。）

### 批量添加pools和workers

- 导入pools
```
curl --location --request POST 'http://path.to.monitor/ptp/proxy/Qmbz...RjpwY/CreatePool' \
--header 'Content-Type: application/json' \
--data-raw '{
    "pools": [
        {
            "pid": 2,
            "name": "test2",
            "owner": {
                "mnemonic": "boss...chase"
            },
            "enabled": true,
            "realPhalaSs58": "3zieG9...1z5g"
        }
    ]
}'
```
- 导入workers
```
curl --location --request POST 'http://path.to.monitor/ptp/proxy/Qmbz...RjpwY/CreateWorker' \
--header 'Content-Type: application/json' \
--data-raw '{
    "workers": [
        {
            "pid": 2,
            "name": "test-node-1",
            "endpoint": "http://path.to.worker1:8000",
            "enabled": true,
            "stake": "4000000000000000"
        },
        {
            "pid": 2,
            "name": "test-node-2",
            "endpoint": "http://path.to.worker2:8000",
            "enabled": true,
            "stake": "4000000000000000"
        }
    ]
}'
```

---

### 3. Worker机部署
#### 安装基础环境
  1.docker
  2.docker-compose
  3.sgx driver
  注：可以使用手动部署或者通过修改官方solo脚本来达到环境和pruntime部署
#### 启动pruntime

---

### 常用命令
+ Node机常用操作
```
启动容器：docker-compose -f /opt/phala/node.yml up -d
停止容器：docker stop node
重启容器：docker restart node
移除容器: docker rm node
查看日志：docker logs -f node -n 100
```
+ Prb机常用操作
```
cd /opt/phala
docker-compose up -d redis io	#启动基础服务
docker-compose up -d data_provider	#启动data_provider服务
docker-compose up -d trade	#启动trade服务
docker-compose up -d lifecycle	#启动lifecycle服务
docker-compose up -d monitor	#启动monitor服务
docker ps -a   #查看容器状态
docker restart 容器名   #重启某个容器
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
