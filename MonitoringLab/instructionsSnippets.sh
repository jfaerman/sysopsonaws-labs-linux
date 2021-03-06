# ============================= #
# Interacting with CloudWatch   #
# ============================= #

# Topic 2.2
# =========

aws cloudwatch put-metric-data \
  --region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed -e 's/.$//') \
  --namespace Student \
  --metric-name AttentionLevel \
  --value 8 \
  --debug

# Topic 4.1
# =========

aws cloudwatch get-metric-statistics \
 --region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed -e 's/.$//') \
 --metric-name "AttentionLevel" \
 --namespace="Student" \
 --start-time=$(date -d yesterday -I) \
 --end-time=$(date -d tomorrow -I) \
 --period=300 \
 --statistics="Minimum"
 

# Topic 3.4
# =========

aws cloudwatch put-metric-data \
  --region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/ | sed -e 's/.$//') \
  --namespace Student \
  --metric-name AttentionLevel \
  --value 4 \
  --debug

# ==================================== #
# Integrating with Monitoring Services #
# ==================================== #

# Start the Monitoring Server - Topic 4
# =====================================

#!/bin/bash
easy_install pip
pip install setuptools --no-use-wheel --upgrade
pip install Flask
curl -s -O -L https://github.com/awstrainingandcertification/sysopsonaws-labs-linux/archive/master.zip
unzip master.zip -d /usr/local/
python /usr/local/sysopsonaws-labs-linux-master/MonitoringLab/server.py &

# Client Self-Registration - Topic 7
# =====================================

#!/bin/bash
curl -X PUT \
  -d instanceId=$(curl -s http://169.254.169.254/latest/meta-data/instance-id) \
 [monitoring_server_url]

# Schedule the config script - Topic 2
# =====================================

echo "*/2 * * * * /usr/local/sysopsonaws-labs-linux-master/MonitoringLab/pollInstances.sh [monitoring_server_url]" | crontab -

# Consume Auto Scaling Events - Topic 2
# =====================================

/usr/local/sysopsonaws-labs-linux-master/MonitoringLab/consumeEvents.sh [queue_url] [monitoring_server_url]
