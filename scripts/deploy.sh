#!/bin/bash


# Create BS database and load tables 
mysql<<'EndofLoadSQL'
USE mysql;
CREATE DATABASE IF NOT EXISTS bsgen;
GRANT ALL ON bsgen.* TO 'webapp'@'%';
USE bsgen;

DROP TABLE IF EXISTS adjective;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE adjective (
  word varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
LOCK TABLES adjective WRITE;
/*!40000 ALTER TABLE adjective DISABLE KEYS */;
INSERT INTO adjective VALUES ('24/365'),('24/7'),('B2B'),('B2C'),('back-end'),('best-of-breed'),('bleeding-edge'),('bricks-and-clicks'),('clicks-and-mortar'),('collaborative'),('compelling'),('cross-platform'),('cross-media'),('customized'),('cutting-edge'),('distributed'),('dot-com'),('dynamic'),('e-business'),('efficient'),('end-to-end'),('enterprise'),('extensible'),('frictionless'),('front-end'),('global'),('granular'),('holistic'),('impactful'),('innovative'),('integrated'),('interactive'),('intuitive'),('killer'),('leading-edge'),('magnetic'),('mission-critical'),('next-generation'),('one-to-one'),('open-source'),('out-of-the-box'),('plug-and-play'),('proactive'),('real-time'),('revolutionary'),('rich'),('robust'),('scalable'),('seamless'),('sexy'),('sticky'),('strategic'),('synergistic'),('transparent'),('turn-key'),('ubiquitous'),('user-centric'),('value-added'),('vertical'),('viral'),('virtual'),('visionary'),('web-enabled'),('wireless'),('world-class'),('iterative');
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
INSERT INTO noun VALUES ('action-items'),('applications'),('applets'),('architectures'),('bandwidth'),('barriers'),('channels'),('communities'),('compatabilites'),('comprehension'),('collaboration'),('consistency'),('consolidation'),('content'),('containers'),('convergence'),('deliverables'),('derivatives'),('e-business'),('e-commerce'),('e-markets'),('e-services'),('e-tailers'),('experiences'),('expectations'),('eyeballs'),('functionalities'),('infomediaries'),('infrastructures'),('initiatives'),('interfaces'),('markets'),('methodologies'),('metrics'),('mindshare'),('models'),('networks'),('niches'),('paradigms'),('partnerships'),('persistence'),('platforms'),('plug-ins'),('portals'),('relationships'),('ROI'),('synergies'),('virtual machines'),('web-readiness'),('schemas'),('sharing'),('solutions'),('stories'),('supply-chains'),('systems'),('technologies'),('uptake'),('users'),('verticals'),('web services'),('iterations');
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
INSERT INTO verb VALUES ('aggregate'),('architect'),('benchmark'),('brand'),('cultivate'),('deliver'),('deploy'),('disintermediate'),('drive'),('e-enable'),('embrace'),('empower'),('enable'),('engage'),('engineer'),('enhance'),('envisioneer'),('evolve'),('expedite'),('exploit'),('extend'),('facilitate'),('generate'),('grow'),('harness'),('implement'),('incentivize'),('incubate'),('innovate'),('integrate'),('iterate'),('leverage'),('matrix'),('maximize'),('mesh'),('monetize'),('morph'),('optimize'),('orchestrate'),('productize'),('recontextualize'),('redefine'),('reintermediate'),('reinvent'),('repurpose'),('revolutionize'),('scale'),('seize'),('strategize'),('streamline'),('syndicate'),('synergize'),('synthesize'),('target'),('transform'),('transition'),('unleash'),('utilize'),('visualize'),('whiteboard'),('iterate');
/*!40000 ALTER TABLE verb ENABLE KEYS */;
UNLOCK TABLES;

EndofLoadSQL


# Create PHP landing page
cat<<'EndofPHP'>/var/www/html/index.php
<?php
print <<<'EOH'
<!DOCTYPE html>

<html>
  <head>
    <title>BS Generator</title>
    <style>
      body {
        background-color: #80bfff;
      }
      p{
        font-size:150%;
        color: #004f99
      }
      p.phrase {
        font-size:400%;
        font-weight:bold;
        color: #001a33;
      }
      
    </style>
  </head>
  <body>
    <div align="center">
      <p style="margin-top:100px;margin-bottom:100px;">
        Just another LAMP stack Bullshit Generator
      </p>
  
EOH;


$db_username="webapp";
$db_password="webappPW";
$db_host="localhost";
$db_name="bsgen";

$mysqli = new \mysqli($db_host, $db_username, $db_password, $db_name) or die(mysqli_error());

if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    print "  </body>\n</html>\n";
    exit();
}

$result = $mysqli->query("SELECT * FROM verb ORDER BY RAND() LIMIT 0,1");
while($row = mysqli_fetch_array($result))
{
  printf("<p class=\"phrase\">%s ",$row['word']);
}
$result = $mysqli->query("SELECT * FROM adjective ORDER BY RAND() LIMIT 0,1");
while($row = mysqli_fetch_array($result))
{
  printf("%s ",$row['word']);
}
$result = $mysqli->query("SELECT * FROM noun ORDER BY RAND() LIMIT 0,1");
while($row = mysqli_fetch_array($result))
{
  printf("%s</p>",$row['word']);
}

mysqli_close($mysqli);

print <<<'EOF'
      <p style="margin-top:5em;">
        &nbsp;
      </p>
      <form>
      <input type="button" onClick="location.reload(true)" value="Generate Bullshit">
      </form>
    </div>  
  </body>
</html>
EOF;
?>


EndofPHP

[ -f /var/www/html/index.html ] && mv /var/www/html/index.html /var/www/html/_index.html
chown ubuntu:www-data /var/www/html/index.php
chmod 0644 /var/www/html/index.php
