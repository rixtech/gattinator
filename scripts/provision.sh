#!/bin/bash

# Apache/PHP

apt-get update
apt-get install -y apache2 php libapache2-mod-php php-mcrypt php-mysql
usermod -a -G www-data ubuntu
echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
chown -R ubuntu:www-data /var/www

# MySQL

apt-get install -y debconf-utils

export DEBIAN_FRONTEND="noninteractive"

PW=$(openssl rand -base64 12)

cat<<End_PW>/root/.my.cnf
[client]
user=root
password=$PW
End_PW
chmod 0400 /root/.my.cnf

apt-get install debconf-utils
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PW"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PW"

apt-get install -y mysql-server 

# Add a webservice user and test database
mysql<<EndSQL
USE mysql;
CREATE DATABASE testdb;
CREATE USER webapp IDENTIFIED BY 'webappPW';
GRANT ALL ON testdb.* TO 'webapp'@'%';
FLUSH PRIVILEGES;
USE testdb;
CREATE table test (c CHAR(255));
INSERT INTO test (c) VALUES ("hello world");
EndSQL

# Load Gatt-speak tables
mysql<<'EndofLoadSQL'
CREATE DATABASE IF NOT EXISTS gattspeak;;
USE gattspeak;

DROP TABLE IF EXISTS adjective;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE adjective (
  word varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
LOCK TABLES adjective WRITE;
/*!40000 ALTER TABLE adjective DISABLE KEYS */;
INSERT INTO adjective VALUES ('24/365'),('24/7'),('B2B'),('B2C'),('back-end'),('best-of-breed'),('bleeding-edge'),('bricks-and-clicks'),('clicks-and-mortar'),('collaborative'),('compelling'),('cross-platform'),('cross-media'),('customized'),('cutting-edge'),('distributed'),('dot-com'),('dynamic'),('e-business'),('efficient'),('end-to-end'),('enterprise'),('extensible'),('frictionless'),('front-end'),('global'),('granular'),('holistic'),('impactful'),('innovative'),('integrated'),('interactive'),('intuitive'),('killer'),('leading-edge'),('magnetic'),('mission-critical'),('next-generation'),('one-to-one'),('open-source'),('out-of-the-box'),('plug-and-play'),('proactive'),('real-time'),('revolutionary'),('rich'),('robust'),('scalable'),('seamless'),('sexy'),('sticky'),('strategic'),('synergistic'),('transparent'),('turn-key'),('ubiquitous'),('user-centric'),('value-added'),('vertical'),('viral'),('virtual'),('visionary'),('web-enabled'),('wireless'),('world-class');
/*!40000 ALTER TABLE adjective ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS noun;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE noun (
  word varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
LOCK TABLES noun WRITE;
/*!40000 ALTER TABLE noun DISABLE KEYS */;
INSERT INTO noun VALUES ('action-items'),('applications'),('applets'),('architectures'),('bandwidth'),('barriers'),('channels'),('communities'),('compatabilites'),('comprehension'),('collaboration'),('consistency'),('consolidation'),('content'),('containers'),('convergence'),('deliverables'),('derivatives'),('e-business'),('e-commerce'),('e-markets'),('e-services'),('e-tailers'),('experiences'),('expectations'),('eyeballs'),('functionalities'),('infomediaries'),('infrastructures'),('initiatives'),('interfaces'),('markets'),('methodologies'),('metrics'),('mindshare'),('models'),('networks'),('niches'),('paradigms'),('partnerships'),('persistence'),('platforms'),('plug-ins'),('portals'),('relationships'),('ROI'),('synergies'),('virtual machines'),('web-readiness'),('schemas'),('sharing'),('solutions'),('stories'),('supply-chains'),('systems'),('technologies'),('uptake'),('users'),('vortals'),('web services');
/*!40000 ALTER TABLE noun ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS verb;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE verb (
  word varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
LOCK TABLES verb WRITE;
/*!40000 ALTER TABLE verb DISABLE KEYS */;
INSERT INTO verb VALUES ('aggregate'),('architect'),('benchmark'),('brand'),('cultivate'),('deliver'),('deploy'),('disintermediate'),('drive'),('e-enable'),('embrace'),('empower'),('enable'),('engage'),('engineer'),('enhance'),('envisioneer'),('evolve'),('expedite'),('exploit'),('extend'),('facilitate'),('generate'),('grow'),('harness'),('implement'),('incentivize'),('incubate'),('innovate'),('integrate'),('iterate'),('leverage'),('matrix'),('maximize'),('mesh'),('monetize'),('morph'),('optimize'),('orchestrate'),('productize'),('recontextualize'),('redefine'),('reintermediate'),('reinvent'),('repurpose'),('revolutionize'),('scale'),('seize'),('strategize'),('streamline'),('syndicate'),('synergize'),('synthesize'),('target'),('transform'),('transition'),('unleash'),('utilize'),('visualize'),('whiteboard');
/*!40000 ALTER TABLE verb ENABLE KEYS */;
UNLOCK TABLES;

EndofLoadSQL

