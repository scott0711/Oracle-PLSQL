update mrp_schedule_dates
set schedule_quantity = original_schedule_quantity
where schedule_designator = '0612MDS'  -- Main MDS
 and schedule_level = 2;
 
 
 select * from mrp_schedule_consumptions
 where creation_date > sysdate -100;
 
 select *
 from mrp_schedule_dates
 where mps_transaction_id = 87621148;
 
 select * from oe_order_headers_all
 where header_id = 87622120;
 
 select msi.segment1,msd.* 
 from mrp_schedule_dates msd,mtl_system_items msi
 where -- source_sales_order_id is not null  and 
 msd.creation_date > sysdate -100
 and msi.organization_id = 82
 and msi.inventory_item_id = msd.inventory_item_id
 and msd.mps_transaction_id = 87621148;
 
 select * from mtl_system_items
 where organization_id = 83
 and inventory_item_id = 2979266;
 
 select * from dba_objects
 where object_type = 'SEQUENCE'
 and object_name like 'MRP%';
 
 insert into mrp_schedule_consumptions
 (transaction_id, relief_type, disposition_type, disposition_id, line_num, 
 order_date, order_quantity, relief_quantity,schedule_date,
 last_updated_by, last_update_date,
created_by, creation_date )
select mps_transaction_id,1,3,source_sales_order_id,source_line_id,
schedule_date,original_schedule_quantity,100,schedule_date, 
11187, sysdate,
11187, sysdate
from mrp_schedule_dates
where mps_transaction_id = 92319878
and schedule_level = 2;


select * from mrp_schedule_consumptions
where transaction_id = 91569271;

select * from mrp_schedule_dates
where ;

select * from mrp_plans
where compile_designator = 'PD-MPS-LCS';