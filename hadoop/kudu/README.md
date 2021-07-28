#执行以下语句
export KUDU_QUICKSTART_IP=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 |  awk '{print $2}' | tail -1)


CREATE EXTERNAL TABLE AREA_20210716
STORED AS KUDU
TBLPROPERTIES (
  'kudu.table_name' = 'AREA_20210716'
);