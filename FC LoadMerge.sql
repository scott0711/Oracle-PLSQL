+---------------------------------------------------------------------------+
物料需求計劃管理系統: Version : 12.0.0

Copyright (c) 1979, 1999, Oracle Corporation. All rights reserved.

MRCFAL1 module: 複製/合併預測
+---------------------------------------------------------------------------+

目前的系統時間是 29-01-2019 20:12:57

+---------------------------------------------------------------------------+

Page Length = 59, Page Width = 132

===================================================================
除錯模式 :        已停用
輸出至終端機 : 否
引數方式 :   資料庫擷取
追蹤模式 :        已停用

===================================================================
引數 1 (REPORT_TYPE) = 1
引數 2 (ORG_ID) = 83
引數 3 (DEST_DESIGNATOR) = 1901_FC
引數 4 (LOAD_SOURCE) = 2
引數 5 (SOURCE_ORG_ID) = 83
引數 6 (SOURCE_DESIGNATOR) = 1812PH
引數 7 (SALES_CODE) = 1
引數 8 (SO_DEMAND_CL) = 
引數 9 (DEMAND_FENCE) = 1
引數 10 (OVERWRITE) = 1
引數 11 (START_DATE) = 2019/01/29 00:00:00
引數 12 (CUTOFF_DATE) = 2019/09/29 00:00:00
引數 13 (EXPLODE_FCST) = 1
引數 14 (QUANTITY_TYPE) = 1
引數 15 (CONSUME_FCST) = 2
引數 16 (MODIFICATION) = 0
引數 17 (FORWARD_DAYS) = 0
引數 18 (QUERY_ID) = 0
引數 19 (CONSUME_SALES_CODE) = 1
引數 20 (FWD_TIME_FENCE) = 0
引數 21 (BWD_TIME_FENCE) = 0
引數 22 (OUTLIER_PERCENT) = 100
引數 23 (LOAD_DESTINATION) = 2
引數 24 (SELECTION_LIST_TYPE) = 2

===================================================================
Buf : ()... 
In Parse arguments ...
After long date conversion ...
After short date conversion ...
Checking parameters valid ...
After parameters valid ...
Before insert/update mrp_load_parameters...
Complete parse arguments ... 
After get profile ...
Before Starting Planning MGR Proc (SO)...
=====================================
計算訂單變更 已開始
設定檔選項 'MRP_COMPUTE_SO_CHANGES' 的值為 Y
計算訂單變更 已完成                                                         0:00
Before Starting Planning MGR Proc (FC)...
=====================================
預測沖銷 已開始
設定檔選項 'MRP_FORECAST_CONSUMPTION' 的值為 Y
設定檔選項 'MRP_SCHED_MGR_BATCH_SIZE' 的值為 500
設定檔選項 'MRP_SCHED_MGR_MAX_WORKERS' 的值為 2
declare 
var_handle  varchar(128);
begin
dbms_lock.allocate_unique ('FC_CONSUME_LOCK', var_handle);
:var_output := dbms_lock.request(var_handle, 6, 32767, TRUE);
end;

UPDATE /*+ index(upd mrp_sales_order_updates_n4) */
mrp_sales_order_updates upd
SET upd.request_id = :sql_req_id, 
process_status = 3 
WHERE  (upd.new_schedule_date != 
        NVL(upd.old_schedule_date, upd.new_schedule_date + 1) 
    OR  upd.new_schedule_quantity != 
        NVL(upd.old_schedule_quantity, upd.new_schedule_quantity+1) 
    OR  upd.current_customer_id != 
        NVL(upd.previous_customer_id, 
            upd.current_customer_id + 1) 
    OR  upd.current_bill_id != NVL(upd.previous_bill_id, 
                               upd.current_bill_id + 1) 
    OR  upd.current_ship_id != NVL(upd.previous_ship_id,
                               upd.current_ship_id + 1) 
    OR  NVL(upd.current_available_to_mrp,'N') != 
                NVL(upd.previous_available_to_mrp,
                    'N')
    OR  NVL(upd.current_demand_class,'734jkhJK24') != 
        NVL(upd.previous_demand_class, 
            '734jkhJK24')) 
AND     upd.process_status = 2 
AND     upd.error_message IS NULL 
AND     upd.request_id IS NULL 
AND     upd.inventory_item_id IN
        (SELECT number2 
                 FROM   mrp_form_query
                 WHERE  query_id = :in_process_items
                 AND    number1 = -1 
                 )

鎖定表格 已完成                                                             0:00
PLSQL:將 料號 插入 mrp_form_query(1:11146303)                          0   00:00
PLSQL:將 料號 插入 mrp_form_query(2:11146303)                          0   00:00
PLSQL:將 料號 插入 mrp_form_query(3:11146303)                          0   00:00
介面表格資料列更新 已完成                                              0    0:00
已從 mrp_form_query 刪除                                               0    0:00
Before Starting Planning MGR Proc (MDS)...
=====================================
mds_relief 已開始
設定檔選項 'MRP_MDS_CONSUMPTION' 的值為 Y
設定檔選項 'MRP_SCHED_MGR_BATCH_SIZE' 的值為 500
設定檔選項 'MRP_SCHED_MGR_MAX_WORKERS' 的值為 2
declare 
var_handle  varchar(128);
begin
dbms_lock.allocate_unique ('MDS_RELIEF_LOCK', var_handle);
:var_output := dbms_lock.request(var_handle, 6, 32767, TRUE);
end;

UPDATE mrp_relief_interface 
SET request_id = :sql_req_id, 
process_status = 3 
WHERE   inventory_item_id  IN 
        (SELECT inventory_item_id
         FROM   mrp_relief_interface rel2
         WHERE  rel2.request_id IS NULL 
         AND    rel2.error_message IS NULL 
         AND    rel2.relief_type = 1
         AND    rel2.process_status = 2
         AND    rownum <= :batch_size
         AND    inventory_item_id NOT IN 
           (SELECT number1
            FROM   mrp_form_query
            WHERE  query_id = :in_process_items))
AND request_id IS NULL 
AND error_message IS NULL 
AND relief_type = 1 
AND process_status = 2 

鎖定表格 已完成                                                             0:00
PLSQL:將 料號 插入 mrp_form_query(1:11146304)                          0   00:00
PLSQL:將 料號 插入 mrp_form_query(2:11146304)                          0   00:00
介面表格資料列更新 已完成                                              0    0:00
已從 mrp_form_query 刪除                                               0    0:00
設定檔選項 'MRP_RETAIN_DATES_WTIN_CAL_BOUNDARY' 的值為 Y

SELECT  TO_NUMBER(TO_CHAR(MIN(calendar_date),'j')),
TO_NUMBER(TO_CHAR(MAX(calendar_date),'j'))
FROM    bom_calendar_dates 
WHERE   calendar_code = :calendar_code 
AND    seq_num IS NOT NULL
 AND     exception_set_id = :exception_set_id

正在載入 工作天工作曆. 請稍候 ..
SELECT TO_CHAR(calendar_date, 'j')
FROM   bom_calendar_dates
WHERE  calendar_code = :calendar_code
AND    exception_set_id = :exception_set_id
AND seq_num IS NOT NULL
 ORDER BY calendar_date
正在載入 工作天工作曆. 請稍候 ...

..正在載入 工作天工作曆. 請稍候 .                                           0:00
設定檔選項 'MRP_RETAIN_DATES_WTIN_CAL_BOUNDARY' 的值為 Y

SELECT  TO_NUMBER(TO_CHAR(MIN(week_start_date),'j')),
TO_NUMBER(TO_CHAR(MAX(week_start_date),'j'))
FROM    bom_cal_week_start_dates 
WHERE   calendar_code = :calendar_code 
 AND     exception_set_id = :exception_set_id

正在載入 週. 請稍候 ..
SELECT TO_CHAR(week_start_date, 'j')
FROM   bom_cal_week_start_dates
WHERE  calendar_code = :calendar_code
AND    exception_set_id = :exception_set_id
  ORDER BY week_start_date
正在載入 週. 請稍候 ...

...正在載入 週. 請稍候 .                                                    0:00
設定檔選項 'MRP_RETAIN_DATES_WTIN_CAL_BOUNDARY' 的值為 Y

SELECT  TO_NUMBER(TO_CHAR(MIN(period_start_date),'j')),
TO_NUMBER(TO_CHAR(MAX(period_start_date),'j'))
FROM    bom_period_start_dates 
WHERE   calendar_code = :calendar_code 
 AND     exception_set_id = :exception_set_id

正在載入 期間. 請稍候 ..
SELECT TO_CHAR(period_start_date, 'j')
FROM   bom_period_start_dates
WHERE  calendar_code = :calendar_code
AND    exception_set_id = :exception_set_id
  ORDER BY period_start_date
正在載入 期間. 請稍候 ...

...正在載入 期間. 請稍候 .                                                  0:00
..mrlrt1_load_tree 有 已讀取 73 資料列來自 MRP_FORECAST_DATES               0:00
.將 1 插件的預測/排程項目載入至樹狀結構 (NUMBER=73)                         0:00
自動載入 有 已更新 1 資料列來自 MRP_LOAD_PARAMETERS                         0:00
.預測展開 已完成                                                            0:00
.預測展開 已完成                                                            0:00
設定檔選項 'MRP_ROUND_SOURCE_ENTRIES' 的值為 N
.更新的 Flex                                                          73    0:00
自動載入 有 已更新 1 資料列來自 MRP_LOAD_PARAMETERS                         0:01
Buf : ()... 