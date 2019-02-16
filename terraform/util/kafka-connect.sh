#!/bin/bash

########### Update and Install ###########

yum update -y
yum install wget -y
yum install unzip -y
yum install java-1.8.0-openjdk-devel.x86_64 -y

########### Initial Bootstrap ###########

cd /tmp
wget ${confluent_platform_location}
unzip confluent-5.1.0-2.11.zip
mkdir /etc/confluent
mv confluent-5.1.0 /etc/confluent
mkdir ${confluent_home_value}/etc/kafka-connect

########### Generating Props File ###########

cd ${confluent_home_value}/etc/kafka-connect

cat > kafka-connect-ccloud.properties <<- "EOF"
${kafka_connect_properties}
EOF

######## Twitter & Redis Connectors #########

${confluent_home_value}/bin/confluent-hub install jcustenborder/kafka-connect-twitter:0.2.32 --component-dir ${confluent_home_value}/share/java --no-prompt
${confluent_home_value}/bin/confluent-hub install jcustenborder/kafka-connect-redis:0.0.2.7 --component-dir ${confluent_home_value}/share/java --no-prompt

########### Creating the Service ############

cat > /lib/systemd/system/kafka-connect.service <<- "EOF"
[Unit]
Description=Kafka Connect

[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=${confluent_home_value}/bin/connect-distributed ${confluent_home_value}/etc/kafka-connect/kafka-connect-ccloud.properties

[Install]
WantedBy=multi-user.target
EOF

########### Enable and Start ###########

systemctl enable kafka-connect
systemctl start kafka-connect
