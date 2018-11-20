export APP_HOME=/alidata/sinosoft/app
export TOMCAT_HOME=/alidata/sinosoft/soft/apache-tomcat-7.0.73
export APPWEB_HOME=/alidata/sinosoft/soft/apache-tomcat-7.0.73/webapps
export UPGRADE_HOME=/alidata/sinosoft/upgrade/20181119/2.应用-全量包
export UPGRADE_CFG_HOME=/alidata/sinosoft/upgrade/20181119/2.应用-全量包/ascore-comm-配置

export LC_ALL="zh_CN.GB18030"
export LANG="zh_CN.GB18030"
unzip 20181022.zip 
convmv -rf cp936 -t utf8 --notest  20181022

export LC_ALL="zh_CN.UTF-8"
export LANG="zh_CN.UTF-8"

##数据库升级
export ORACLE_HOME=/usr/lib/oracle/11.2/client64
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
##设置变量oracle客户端环境为utf-8,因为开发提供的文件内容编码是utf-8
export NLS_LANG=AMERICAN_AMERICA.UTF8
cd /alidata/sinosoft/db/20181022/脚本
sqlplus64 "apps/apps@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=10.19.1.3)(PORT=1531))(CONNECT_DATA=(SID=uat)))"


diff -c ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/application.properties  ${UPGRADE_CFG_HOME}/WEB-INF/classes/config/application.properties
diff -c ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/db.properties  ${UPGRADE_CFG_HOME}/WEB-INF/classes/config/db.properties
diff -c ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/redis.properties  ${UPGRADE_CFG_HOME}/WEB-INF/classes/config/redis.properties
diff -c ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/etl/kettle/toacc/datasource.properties  ${UPGRADE_CFG_HOME}/WEB-INF/classes/etl/kettle/toacc/datasource.properties

cp -rf ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/application.properties  ${UPGRADE_CFG_HOME}/WEB-INF/classes/config
cp -rf ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/db.properties  ${UPGRADE_CFG_HOME}/WEB-INF/classes/config
cp -rf ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/redis.properties  ${UPGRADE_CFG_HOME}/WEB-INF/classes/config
cp -rf ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/etl/kettle/toacc/datasource.properties  ${UPGRADE_CFG_HOME}/WEB-INF/classes/etl/kettle/toacc


cd /alidata/sinosoft
mkdir $(date +%Y%m%d%H)_bakup
tar -cvf $(date +%Y%m%d%H)_bakup/$(date +%Y%m%d%H).tar /alidata/sinosoft/app


diff -c ${UPGRADE_CFG_HOME}/WEB-INF/classes/config/application.properties        ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/application.properties 
diff -c ${UPGRADE_CFG_HOME}/WEB-INF/classes/config/db.properties        ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/db.properties
diff -c ${UPGRADE_CFG_HOME}/WEB-INF/classes/config/redis.properties        ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/redis.properties
diff -c ${UPGRADE_CFG_HOME}/WEB-INF/classes/etl/kettle/toacc/datasource.properties        ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/etl/kettle/toacc/datasource.properties 

rm -rf ${APP_HOME}/actuary
rm -rf ${APP_HOME}/ascore-comm

cp -rf ${UPGRADE_HOME}/actuary  ${APP_HOME}
cp -rf ${UPGRADE_HOME}/ascore-comm ${APP_HOME}

cp ${UPGRADE_CFG_HOME}/WEB-INF/classes/config/application.properties        ${APP_HOME}/ascore-comm/WEB-INF/classes/config
cp ${UPGRADE_CFG_HOME}/WEB-INF/classes/config/db.properties        ${APP_HOME}/ascore-comm/WEB-INF/classes/config
cp ${UPGRADE_CFG_HOME}/WEB-INF/classes/config/redis.properties        ${APP_HOME}/ascore-comm/WEB-INF/classes/config
cp ${UPGRADE_CFG_HOME}/WEB-INF/classes/etl/kettle/toacc/datasource.properties        ${APP_HOME}/ascore-comm/WEB-INF/classes/etl/kettle/toacc

cd ${TOMCAT_HOME}/bin
杀进程
ps -ef|grep 'apache-tomcat-7.0.73'|awk '{print$2}'|xargs kill -9 

rm -rf ${APPWEB_HOME}/ascore-comm
cp -rf ${APP_HOME}/ascore-comm  ${APPWEB_HOME}/

more    ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/application.properties
more    ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/db.properties | grep -E 'db.kettle|db.core'
more    ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/config/redis.properties
more    ${APPWEB_HOME}/ascore-comm/WEB-INF/classes/etl/kettle/toacc/datasource.properties | grep -E 'src_|des_'


cd ${TOMCAT_HOME}/bin
ps -ef|grep 'apache-tomcat-7.0.73'|awk '{print$2}'|xargs kill -9 
nohup ./catalina.sh run >actuary_comm.log 2>&1 &      
tail -f actuary_comm.log
