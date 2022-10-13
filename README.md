## Universal-Deployment

利用Jenkins统一打包部署k8s服务

### 工作流程 
* 在Jenkins中配置统一调用./bin/redeploy.sh, 传入两个参数${DEPLOY_SERVICE} ${DEPLOY_ENV}
* ./bin/redeploy.sh会根据DEPLOY_SERVICE指定的名称，调用./service-scripts/${DEPLOY_SERVICE}/redeploy.sh
* ./bin/commons/中提供几种通用的脚本，可用来执行通用功能
* ./service-scripts/${DEPLOY_SERVICE}/redeploy.sh 即可以调用通用脚本，也可以调用自己编写的特有脚本进行k8s服务发布

### 通用脚本说明


## service name 对应

| 服务                | host_name |    内网端口号| 在公司链接调试用port | 
| --- | --- | --- | ---|
| redis             |  redis.default               |默认| 32701 |
| mysql             |  mysql.default               |默认| 32700 root/P@ssw0rd jinxin/jinxin |
| orientdb          |  orientdb.default            |默认| 32702,32703 |
| elasticsearch     |  elasticsearch.default       |默认| 32704,32705 |
| rocketmq          |  rocketmq.default            |默认| 无 |
| mongodb           |  mongodb.default             |默认| 32706 |
| eureka            |  eureka-service              |默认|  -     |     
| ambry             |  ambry-client.default        |1174| 32708  |
| zookeeper          | commons-zookeeper.default   |2181|30002|
| kafka                |commons-kafka.default       |9092|30003|
| flink             |http://10.1.1.176:30001        |8081|30001 |
| kafka-manager        |http://10.1.1.176:30004     |9000|30004|
| zookeeper ui        |http://10.1.1.176:30005      |9090|30005  admin/manager|       
| drools ui         |http://10.1.1.176:31001/business-central|8080|31001 admin/admin|
| drools ssh         |                              |8001|31002|


| demo host name| dev host name |
| --- | --- | 
| mds-all-frontier.demo | mds-all-frontier.dev |
| auth-frontier.demo    | auth-frontier.dev |
| auth-frontier.demo    | auth-frontier.dev |
| auth-service.demo     | auth-service.dev |
| dqs-service.demo      | dqs-service.dev |
| ds-service.demo       | ds-service.dev |
| eureka-service.demo   | eureka-service.dev |
| idcenter-service.demo | idcenter-service.dev |
| mds-service.demo      | mds-service.dev |
| tag-service.demo      | tag-service.dev |
| uc-service.demo       | uc-service.dev |
| workflow-service.demo | workflow-service.dev | 
| dlc-service.demo      | dlc-service.dev | 
| d4a-service.demo      | d4a-service.dev | 

* Java服务务端口均为 `8080`




## redis port log

| project | dev_env_db_num |  demo_evn_db_num | 
| ---     | --- | --- |
| mds-all-frontier  | 1  | 2 |
| auth-server       | 1  | 2 |
 
* redis db1 为 `mds-all-frontier` 和　`auth-server` 的demo库
* redis db2 为 `mds-all-frontier` 和　`auth-server` 的demo库

## mysql

库名以_dev _demo区分 帐号为 `jinxin/jinxin`

| demo mysql | dev mysql | 
| --- | --- |
| auth_server_demo     | auth_server_dev      |
| dqs_server_demo      | dqs_server_dev       |
| ds_server_demo       | ds_server_dev        |
| mds_server_demo      | mds_server_dev       |
| tag_server_demo      | tag_server_dev       |
| uc_server_demo       | uc_server_dev        |
| workflow_server_demo | workflow_server_dev  |
| dlc_server_demo      | dlc_server_dev       |
| d4a_server_demo      | d4a_server_dev       |

## elasticsearch

索引名以_dev _demo区分 

| demo | dev | 
| --- | --- |
| mds_server_demo | mds_server_dev |



### 可通过浏览器访问的一些页面，需要自行修改host
- Dev 环境
    * 10.1.1.176 eureka.dev.jinxin.cloud
    * 10.1.1.176 mds.dev.jinxin.cloud
- Demo环境
    * 10.1.1.176 mds.demo.jinxin.cloud
    * 10.1.1.176 eureka.demo.jinxin.cloud


### mysql审计插件安装步骤

```
查看审计插件可调参数：  SHOW GLOBAL VARIABLES LIKE '%audi%'; 

参数说明：
        server_audit_output_type：指定日志输出类型，可为SYSLOG或FILE
        server_audit_logging：启动或关闭审计
        server_audit_events：指定记录事件的类型，可以用逗号分隔的多个值(connect,query,table)，如果开启了查询缓存(query cache)，查询直接从查询缓存返回数据，将没有table记录
        server_audit_file_path：如server_audit_output_type为FILE，使用该变量设置存储日志的文件，可以指定目录，默认存放在数据目录的server_audit.log文件中
        server_audit_file_rotate_size：限制日志文件的大小
        server_audit_file_rotations：指定日志文件的数量，如果为0日志将从不轮转
        server_audit_file_rotate_now：强制日志文件轮转
        server_audit_incl_users：指定哪些用户的活动将记录，connect将不受此变量影响，该变量比server_audit_excl_users优先级高
        server_audit_syslog_facility：默认为LOG_USER，指定facility
        server_audit_syslog_ident：设置ident，作为每个syslog记录的一部分
        server_audit_syslog_info：指定的info字符串将添加到syslog记录
        server_audit_syslog_priority：定义记录日志的syslogd priority
        server_audit_excl_users：该列表的用户行为将不记录，connect将不受该设置影响
        server_audit_mode：标识版本，用于开发测试

1、执行安装 命令： INSTALL PLUGIN server_audit SONAME 'server_audit.so';
2、开启审计：SET GLOBAL server_audit_logging=ON;
3、调整审计监控数据库操作事件：  SET GLOBAL server_audit_events = 'CONNECT,QUERY,TABLE,QUERY_DDL,QUERY_DML' ;
4、调整审计日志文件大小： SET GLOBAL server_audit_file_rotate_size = 200000000;

```