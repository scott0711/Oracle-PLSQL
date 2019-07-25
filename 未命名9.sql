select * from mrp_schedule_items
where inventory_item_id = 2979266
and schedule_designator in ('0104MDS','0612MDS');

insert into mrp_schedule_items ( inventory_item_id, organization_id, schedule_designator, mps_explosion_level,
last_updated_by, last_update_date,
created_by, creation_date )
select 
distinct (ola.inventory_item_id),83, '0613MDS', 20,
11187, sysdate,
11187, sysdate
from oe_order_headers_all oha, oe_order_lines_all ola
where oha.header_id = ola.header_id
and ola.schedule_ship_date >= TO_DATE('2019-04-01', 'YYYY-MM-DD')
and ola.schedule_ship_date <= TO_DATE('2020-02-11', 'YYYY-MM-DD')
-- and ola.request_date >= TO_DATE('2019-04-01', 'YYYY-MM-DD')
-- and ola.request_date <= TO_DATE('2020-02-11', 'YYYY-MM-DD')
and ola.ship_from_org_id = 83
--and oha.booked_flag ='Y'
and oha.open_flag ='Y'
and ola.open_flag = 'Y'
and ola.visible_demand_flag='Y';

--
select * from mrp_schedule_dates
where inventory_item_id = 3748266
and schedule_designator in ('0104MDS','0612MDS');

insert into mrp_schedule_dates
( mps_transaction_id, schedule_level, supply_demand_type,inventory_item_id, organization_id, schedule_designator, schedule_date,
schedule_workdate,schedule_quantity,original_schedule_quantity,schedule_origination_type,
source_organization_id,source_schedule_designator,source_sales_order_id,source_code,source_line_id,
request_id,program_application_id,program_id,
last_updated_by, last_update_date,
created_by, creation_date )
select
MRP_SCHEDULE_DATES_S.nextval, 2, 1                       ,inventory_item_id,83,              '0613MDS', schedule_ship_date,
schedule_ship_date,ordered_quantity,ordered_quantity,3,
83, null,
inv_salesorder.get_salesorder_for_oeheader(oha.header_id),'MRCSAL',ola.line_id,
-1,704,778899,
11187, sysdate,
11187, sysdate
--oha.order_number,oha.header_id
from oe_order_headers_all oha, oe_order_lines_all ola
where oha.header_id = ola.header_id
and ola.schedule_ship_date >= TO_DATE('2019-04-01', 'YYYY-MM-DD')
and ola.schedule_ship_date <= TO_DATE('2020-02-11', 'YYYY-MM-DD')
-- and ola.request_date >= TO_DATE('2019-04-01', 'YYYY-MM-DD')
-- and ola.request_date <= TO_DATE('2020-02-11', 'YYYY-MM-DD')
and ola.ship_from_org_id = 83
--and oha.booked_flag ='Y'
and oha.open_flag ='Y'
and ola.open_flag = 'Y'
and ola.visible_demand_flag='Y';