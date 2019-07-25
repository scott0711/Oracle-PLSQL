+---------------------------------------------------------------------------+
物料需求計劃管理系統: Version : 12.0.0

Copyright (c) 1979, 1999, Oracle Corporation. All rights reserved.

MRCFCC module: 沖銷預測集
+---------------------------------------------------------------------------+

目前的系統時間是 29-01-2019 20:15:29

+---------------------------------------------------------------------------+

Page Length = 59, Page Width = 80

===================================================================
除錯模式 :        已停用
輸出至終端機 : 否
引數方式 :   資料庫擷取
追蹤模式 :        已停用

===================================================================
引數 1 (ORG_ID) = 83
引數 2 (FORECAST_SET) = FC_SET
引數 3 (SALES_ORDERS) = 2
引數 4 (DEMAND_TF) = 2
引數 5 (START_DATE) = 

===================================================================
已從 MRP_FORECAST_UPDATES 刪除                                         0    0:00
已從 MRP_FORECAST_DATES 刪除                                           0    0:00
已從 MRP_FORECAST_ITEMS 刪除                                           0    0:00
更新的 MRP_FORECAST_DATES                                             73    0:00
SELECT  updates.inventory_item_id,
        NVL(items.product_family_item_id, -23453),
        items.bom_item_type,
        items.pick_components_flag,
        items.mrp_planning_code,
        DECODE(items.bom_item_type, 
            2, 0,
            1, DECODE(updates.ordered_item_id,
                                NULL, 0, NVL(items.fixed_lead_time,0)),
            NVL(items.fixed_lead_time, 0)),
        DECODE(items.bom_item_type, 
            2, 0,
            1, DECODE(updates.ordered_item_id,
                                NULL, 0, NVL(items.variable_lead_time,0)),
            NVL(items.variable_lead_time, 0)),
        DECODE(items.bom_item_type, 
            2, 0,
            1, DECODE(updates.ordered_item_id,
                                NULL, 0, CEIL(NVL(items.full_lead_time,0))),
            CEIL(NVL(items.full_lead_time, 0))),
        NVL(items.base_item_id, -23453),
        updates.sales_order_id,
        updates.organization_id,
        TO_NUMBER(TO_CHAR(updates.old_schedule_date, 'J')),
        -23453,
        updates.old_schedule_quantity,
        0.0,
        updates.previous_available_to_mrp,
        ' ',
        updates.previous_customer_id,
        -23453,
        updates.previous_ship_id,
        -23453,
        updates.previous_bill_id,
        -23453,
        NVL(NVL(updates.previous_demand_class, mtl.default_demand_class), '734jkhJK24'),
        NVL(mtl.default_demand_class, '734jkhJK24'),
        NVL(updates.line_num, ' '),
        NVL(updates.base_model_id, updates.inventory_item_id),
        DECODE(updates.old_schedule_date, NULL, 1, 2),
        updates.previous_territory_id,
        2,
        updates.update_seq_num,
        TO_CHAR(TRUNC(items.creation_date), 'J'),
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        'BOGUS ROWID'
FROM    mrp_so_updates_summary_v  updates,
        mtl_system_items          items,
                 mtl_parameters            mtl
WHERE   items.inventory_item_id IN
           (SELECT items.inventory_item_id
            FROM   mrp_forecast_designators   desig,
                   mrp_forecast_items         items
            WHERE  items.forecast_designator = desig.forecast_designator
            AND    items.organization_id = desig.organization_id
            AND    desig.organization_id = :org_id
            AND    NVL(desig.forecast_set,desig.forecast_designator) = :forecast_set
            UNION
            SELECT bill.assembly_item_id
            FROM   bom_inventory_components comp,
                   bom_bill_of_materials    bill,
                   mtl_system_items         sys
            WHERE  comp.component_item_id IN
                   (SELECT items.inventory_item_id
                    FROM   mrp_forecast_designators   desig,
                           mrp_forecast_items         items
                    WHERE  items.forecast_designator = desig.forecast_designator
                    AND    items.organization_id = desig.organization_id
                    AND    desig.organization_id = :org_id
                    AND    NVL(desig.forecast_set,desig.forecast_designator) = :forecast_set)
            AND    comp.bill_sequence_id  = bill.common_bill_sequence_id
            AND    (sys.base_item_id IS NOT NULL
                    OR   sys.bom_item_type = 1
                    OR   sys.bom_item_type = 2)
            AND    sys.organization_id    = bill.organization_id
            AND    sys.inventory_item_id  = bill.assembly_item_id
            AND    bill.organization_id   = :org_id
            UNION
            SELECT comp.component_item_id
            FROM   bom_inventory_components comp,
                   bom_bill_of_materials    bill,
                   mtl_system_items         sys
            WHERE  bill.assembly_item_id IN
                   (SELECT items.inventory_item_id
                    FROM   mrp_forecast_designators   desig,
                           mrp_forecast_items         items
                    WHERE  items.forecast_designator = desig.forecast_designator
                    AND    items.organization_id = desig.organization_id
                    AND    desig.organization_id = :org_id
                    AND    NVL(desig.forecast_set,desig.forecast_designator) = :forecast_set)
            AND    bill.organization_id   = :org_id
            AND    comp.bill_sequence_id  = bill.common_bill_sequence_id
            AND    sys.bom_item_type = 5
            AND    sys.organization_id    = bill.organization_id
            AND    sys.inventory_item_id  = bill.assembly_item_id)
AND     items.organization_id = updates.organization_id
AND     items.inventory_item_id = updates.inventory_item_id
AND     mtl.organization_id = items.organization_id
         AND     updates.old_schedule_date >= DECODE(:sales_orders, 3, TRUNC(SYSDATE), 4, to_date(:start_date,'J'),updates.old_schedule_date - 1)
AND     updates.previous_available_to_mrp = 'Y'
AND     updates.error_message IS NULL
AND     updates.old_schedule_date IS NOT NULL
AND     updates.old_schedule_quantity IS NOT NULL
AND     updates.process_status IN (5, 2, 3)
AND     mtl.organization_id = :org_id
ORDER BY
        updates.organization_id,
        updates.inventory_item_id,
        updates.old_schedule_date,
        updates.old_schedule_quantity desc,
        updates.line_num,
        updates.sales_order_id

Start Date : -23453
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

.正在載入 工作天工作曆. 請稍候 .                                            0:00
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

.正在載入 期間. 請稍候 .                                                    0:00
載入 銷售訂單                                                      1,009    0:02
.載入 銷售訂單                                                     1,009    0:00
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

.正在載入 週. 請稍候 .                                                      0:00
預測沖銷 已完成                                                             0:01
設定檔選項 'MRP_ROUND_SOURCE_ENTRIES' 的值為 N
更新的 Flex                                                            0    0:00

***** 程式結束 - 沖銷預測集 *****