select
ola.inventory_item_id, msi.segment1,oha.creation_date,schedule_ship_date,
schedule_ship_date,ordered_quantity,ordered_quantity,3,
83, null,
inv_salesorder.get_salesorder_for_oeheader(oha.header_id),'MRCSAL',ola.line_id,

oha.order_number,oha.header_id
from oe_order_headers_all oha, oe_order_lines_all ola,mtl_system_items msi
where oha.header_id = ola.header_id
--and ola.schedule_ship_date >= TO_DATE('2019-04-01', 'YYYY-MM-DD')
--and ola.schedule_ship_date <= TO_DATE('2020-02-11', 'YYYY-MM-DD')
-- and ola.request_date >= TO_DATE('2019-04-01', 'YYYY-MM-DD')
-- and ola.request_date <= TO_DATE('2020-02-11', 'YYYY-MM-DD')
and ola.ship_from_org_id = 83
--and oha.booked_flag ='Y'
and oha.open_flag ='Y'
and ola.open_flag = 'Y'
and msi.organization_id = 83
and msi.inventory_item_id = ola.inventory_item_id
and msi.segment1 = '2N7002_R2_00001'
--and ola.visible_demand_flag='Y'

order by ola.schedule_ship_date asc