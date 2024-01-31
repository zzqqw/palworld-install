#### 服务器配置推荐

| 人数     | 配置    |
| -------- | ------- |
| 4～8     | 4核16G  |
| 10～20人 | 8核32G  |
| 16～24   | 16核32G |
| 32人     | 16核64G |

#### Dokcer环境

~~~
git clone https://github.com/zzqqw/palworld-install.git
cd palworld-install
//单独启动
docker-compose -f docker-compose.base.yml up -d
~~~

#### **一键脚本部署环境**
- 服务器套餐配置：以CPU 4核、内存 16GB为例（通常可以满足6-8人同时在线联机）
- 操作系统：Ubuntu 22.04 LTS

#### root用户

~~~
useradd -m -s /bin/bash steam
echo 'steam ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
su steam
~~~

#### 运行部署命令

登陆服务器执行shell命令进行幻兽帕鲁的部署。

```shell
wget -O - https://raw.githubusercontent.com/zzqqw/palworld-install/main/install.sh|sh
```
或
~~~
wget -O - https://cdn.jsdelivr.net/gh/zzqqw/palworld-install@main/install.sh|sh
~~~

> **⚠️**注意
>
> 1. 有可能因为网络原因导致脚本运行失败，建议您多次重试或换个时间段再次部署。此处的原因主要是安装过程中需要请求Steam的服务器，网络连接状况可能不稳定。
>
> 2. 非root账号执行

一键部署脚本执行成功后，会在服务器中创建一个名为`pal-server`的服务，您可以使用如下命令检查服务是否正常启动，如出现图示的效果，则证明服务器已经部署成功。

```shell
sudo systemctl status pal-server
```

如果您后续想管理该服务，可以参考以下命令来进行：

~~~
# 启动幻兽帕鲁的服务
sudo systemctl start pal-server
# 重启幻兽帕鲁的服务
sudo systemctl restart pal-server
# 关闭幻兽帕鲁的服务
sudo systemctl stop pal-server
# 查询幻兽帕鲁服务的状态
sudo systemctl status pal-server
~~~

#### 强制更新

~~~
sudo -u steam steamcmd_path +login anonymous +app_update 2394010 validate +quit
sudo systemctl restart pal-server
~~~

#### 开放端口8211

幻兽帕鲁默认使用8211端口进行通信，进入服务商放通8211端口，协议UDP

#### 配置项
1、复制并执行以下命令为配置文件增加权限，避免后续步骤中由于权限问题导致无法编辑。

~~~
sudo chmod 777 /home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
~~~

2、使用如下命令，将默认配置文件复制到幻兽帕鲁下的LinuxServer目录中：

默认情况下，PalWorldSettings.ini文件是空的，手动配置的门槛很高，因此我们推荐在默认配置文件的基础上进行修改。

~~~
sudo cp /home/steam/Steam/steamapps/common/PalServer/DefaultPalWorldSettings.ini /home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
~~~

3、使用如下命令打开游戏参数的配置文件：PalWorldSettings.ini。

~~~
sudo vim /home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
~~~

#### 备份数据

~~~
tar -cvf backup_saved.tar /home/steam/Steam/steamapps/common/PalServer/Pal/Saved
~~~

#### 配置zram提高系统内存使用率，减少物理磁盘读写

~~~
sudo apt update -y
sudo apt-get install zram-config -y
sudo systemctl start zram-config.service
~~~

#### 配置Swap

~~~
//创建一个swap文件
sudo fallocate -l 8G /swapfile
//设置文件权限
sudo chmod 600 /swapfile
//将文件格式化为swap格式
sudo mkswap /swapfile
//启用swap文件
sudo swapon /swapfile
//设置永久使用swap文件
echo /swapfile   none    swap    sw    0   0 >> /etc/fstab
//重新加载fstab文件
sudo swapon --all
//验证swap设置是否成功
swapon --show
~~~

#### 监控内存占用并在占用比例达到 90% 时自动重启

~~~
cd ~/auto_restart.sh
wget https://raw.githubusercontent.com/zzqqw/palworld-install/main/auto_restart.sh
* * * * * /bin/bash ~/auto_restart.sh > /dev/null 2>&1
~~~

