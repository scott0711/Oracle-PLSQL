SELECT FC.FORECAST_SET, FC.FORECAST_DESIGNATOR,fc.creation_date,fc.organization_id
FROM MRP.MRP_FORECAST_DESIGNATORS FC
WHERE FC.FORECAST_SET IS NOT NULL
AND (FC.DISABLE_DATE IS NULL OR FC.DISABLE_DATE > SYSDATE)
ORDER BY FC.FORECAST_SET, FC.FORECAST_DESIGNATOR;

select * from MRP_FORECAST_DESIGNATORS_V 
where forecast_designator = '1901_FC';

select * from MRP_FORECAST_ITEMS_V 
where forecast_designator = '1901_FC';

select msi.segment1,mfd.* 
  from MRP_FORECAST_DATES_V  mfd,mtl_system_items_b msi
where mfd.forecast_designator = '1901_FC'
and mfd.inventory_item_id = msi.inventory_item_id
and mfd.organization_id = msi.organization_id;


-- * 沖銷 ** --

MRP_FORECAST_UPDATES_V 



select distinct forecast_set from  MRP.MRP_FORECAST_DESIGNATORS mfv
where   not exists (select 1
                             from  mrp_forecast_designators_v b
                             where b.forecast_designator = mfv.forecast_set
                              and   b.organization_id     = mfv.organization_id
                              and   b.disable_date is not null 
                              and   trunc(b.disable_date) <= trunc(sysdate))
   and   mfv.forecast_set               is not null
   and    (trunc(mfv.disable_date) is null or trunc(mfv.disable_date) > trunc(sysdate))   
minus
select distinct forecast_set from PJ_BI_DEMAND_FORECAST

select * from mrp_schedule_interface;

------------------------------------------------
select *　from MRP_FORECAST_DESIGNATORS
where organization_id = 83;

select * from mrp_forecast_items
where organization_id = 83
and last_update_date > TO_DATE('20-JUN-2019','DD-MON-YYYY');

select * from fnd_user
where user_id in (9388,3331,12047,3424)
