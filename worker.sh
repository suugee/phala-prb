#!/bin/bash

function install_depenencies()
{
	log_info "----------更新系统源----------"
	apt-get update
	if [ $? -ne 0 ]; then
		log_err "系统源更新失败"
		exit 1
	fi

	log_info "----------安装依赖----------"
	for i in `seq 0 4`; do
		for package in jq curl wget unzip zip docker docker-compose node yq dkms; do
			if ! type $package > /dev/null; then
				case $package in
					jq|curl|wget|unzip|zip|dkms)
						apt-get install -y $package
						;;
					docker)
						curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
						add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
						apt-get install -y docker-ce docker-ce-cli containerd.io
						usermod -aG docker $USER
						;;
					docker-compose)
						curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
						chmod +x /usr/local/bin/docker-compose
						;;
					node)
						curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
						apt-get install -y nodejs
						;;
					yq)
						wget https://github.suugee.workers.dev/https://github.com/mikefarah/yq/releases/download/v4.11.2/yq_linux_amd64.tar.gz -O /tmp/yq_linux_amd64.tar.gz
						tar -xvf /tmp/yq_linux_amd64.tar.gz -C /tmp
						mv /tmp/yq_linux_amd64 /usr/bin/yq
						rm /tmp/yq_linux_amd64.tar.gz
						;;
					*)
						break
				esac
			fi
		done
		if type jq curl wget unzip zip docker docker-compose node yq dkms > /dev/null; then
			break
		else
			log_err "----------依赖下载失败，请检查安装日志！----------"
			exit 1
		fi
	done
}

function remove_dirver()
{
	if [ -f /opt/intel/sgxdriver/uninstall.sh ]; then
		log_info "----------删除旧版本 dcap/isgx 驱动----------"
		/opt/intel/sgxdriver/uninstall.sh
	fi
}

function install_dcap()
{
	log_info "----------下载 DCAP 驱动----------"
	for i in `seq 0 4`; do
		wget $dcap_driverurl -O /tmp/$dcap_driverbin
		if [ $? -ne 0 ]; then
			log_err "----------下载 DCAP 驱动失败，重新下载！----------"
		else
			break
		fi
	done

	if [ -f /tmp/$dcap_driverbin ]; then
		log_info "----------添加运行权限----------"
		chmod +x /tmp/$dcap_driverbin
	else
		log_err "----------未成功下载 DCAP 驱动，请检查您的网络！----------"
		exit 1
	fi

	log_info "----------安装DCAP驱动----------"
	/tmp/$dcap_driverbin
	if [ $? -ne 0 ]; then
		log_err "----------安装DCAP驱动失败，请检查驱动安装日志！----------"
		exit 1
	else
		log_success "----------删除临时文件----------"
		rm /tmp/$dcap_driverbin
	fi

	return 0
}

function install_isgx()
{
	log_info "----------下载 isgx 驱动----------"
	for i in `seq 0 4`; do
		wget $isgx_driverurl -O /tmp/$isgx_driverbin
		if [ $? -ne 0 ]; then
			log_err "----------下载 isgx 驱动失败，重新下载！----------"
		else
			break
		fi
	done

	if [ -f /tmp/$isgx_driverbin ]; then
		log_info "----------添加运行权限----------"
		chmod +x /tmp/$isgx_driverbin
	else
		log_err "----------未成功下载 isgx 驱动，请检查您的网络！----------"
		exit 1
	fi

	log_info "----------安装 isgx 驱动----------"
	/tmp/$isgx_driverbin
	if [ $? -ne 0 ]; then
		log_err "----------安装isgx驱动失败，请检查驱动安装日志！----------"
		exit 1
	else
		log_success "----------删除临时文件----------"
		rm /tmp/$isgx_driverbin
	fi

	return 0
}

function install_driver()
{
	remove_dirver
	install_dcap
	if [ $? -ne 0 ]; then
		install_isgx
		if [ $? -ne 0 ]; then
			log_err "----------安装DCAP/isgx驱动均失败，请检查安装日志！----------"
			exit 1
		fi
	fi
}

if [ $(lsb_release -r | grep -o "[0-9]*\.[0-9]*") == "18.04" ]; then
	dcap_driverurl=https://download.01.org/intel-sgx/latest/dcap-latest/linux/distro/ubuntu18.04-server/sgx_linux_x64_driver_1.41.bin
	dcap_driverbin=sgx_linux_x64_driver_1.41.bin
	isgx_driverurl=https://download.01.org/intel-sgx/latest/linux-latest/distro/ubuntu18.04-server/sgx_linux_x64_driver_2.11.0_2d2b795.bin
	isgx_driverbin=sgx_linux_x64_driver_2.11.0_2d2b795.bin
elif [ $(lsb_release -r | grep -o "[0-9]*\.[0-9]*") = "20.04" ]; then
	dcap_driverurl=https://download.01.org/intel-sgx/latest/dcap-latest/linux/distro/ubuntu20.04-server/sgx_linux_x64_driver_1.41.bin
	dcap_driverbin=sgx_linux_x64_driver_1.41.bin
	isgx_driverurl=https://download.01.org/intel-sgx/latest/linux-latest/distro/ubuntu20.04-server/sgx_linux_x64_driver_2.11.0_2d2b795.bin
	isgx_driverbin=sgx_linux_x64_driver_2.11.0_2d2b795.bin
else
	log_err "----------系统版本不支持，phala目前仅支持Ubuntu 18.04/Ubuntu 20.04----------"
	exit 1
fi


### 查看pRuntime日志
worker_pruntime_logs(){
docker logs -f pruntime
}
### 重启pRuntime容器
worker_pruntime_restart(){
docker restart phala-pruntime
}


while true 
	do
	echo -e "\e[33m------------------------------\e[0m"
	echo -e "\e[33m|  Phala-cluster 集群脚本    |\e[0m"
	echo -e "\e[33m|  Author @苏格 QQ6559178    |\e[0m"
	echo -e "\e[33m------------------------------\e[0m"
cat << EOF
(1) 安装系统环境
(2) 安装SGX驱动
(3) 删除SGX驱动
(4) 查看pruntime日志
(5) 重启pruntime容器
(0) 退出
================================================================
EOF
		read -p "请输入要执行的选项: " input
		case $input in
			1)
				install_depenencies
				install_driver
				;;
			2)
				install_dcap
				install_isgx
				;;
			3)
				remove_dirver
				;;
			4)
				worker_pruntime_logs
				;;
			5)
				worker_pruntime_restart
				;;
			*)
				break
				;;
		esac
done
