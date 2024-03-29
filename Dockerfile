FROM zhiqiangwang/palworld-server:base

RUN sudo apt-get update 

RUN sudo apt install -y python3-pip

ENV DASHBOARD_ENVIRONMENT="prd"
ENV PALWORLDSETTINGS_FILE=/home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
ENV RESTARTPALSERVER_COMMAND="supervisorctl restart palserver"
ENV DASHBOARD_BASICUSER="dashboard"
ENV DASHBOARD_BASICPWD="123456"

ADD dashboard/ /home/steam/dashboard

RUN python3 -m pip install -r /home/steam/dashboard/requirements.txt  -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY ./conf/supervisor.conf /etc/supervisor/conf.d/palworld.conf

RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*
RUN sudo rm -rf /tmp/*

EXPOSE 8000