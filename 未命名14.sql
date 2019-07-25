declare
    remain number:=0;
    relief_qty number:=0;
begin
for somds_rec in (select lookup_code orgname, lookup_code || to_char(sysdate+1,'MMDD') mdsname ,flv.meaning from FND_LOOKUP_VALUES flv
where flv.lookup_type='MDS_BACKUP_ORG'
and flv.language='US') loop
                    DBMS_OUTPUT.PUT_LINE('--');
                    DBMS_OUTPUT.PUT_LINE(somds_rec.mdsname);
                  
                    insert into MRP_SCHEDULE_DESIGNATORS (schedule_designator,organization_id,SCHEDULE_TYPE,MPS_RELIEF,INVENTORY_ATP_FLAG,
                    last_update_date,last_updated_by, creation_date,created_by)
                    VALUES (somds_rec.mdsname,to_number(somds_rec.meaning), 1,2,2,
                    sysdate,6186,sysdate,6186);
                    
                    insert into mrp_schedule_items ( inventory_item_id, organization_id, schedule_designator,last_update_date,last_updated_by, creation_date,
                          created_by, last_update_login,mps_explosion_level)
                    select inventory_item_id, organization_id, somds_rec.mdsname,last_update_date,last_updated_by, creation_date,
                        created_by, last_update_login,mps_explosion_level
                    from mrp_schedule_items
                     where schedule_designator = 'MD-' || somds_rec.orgname;               
end loop;    
end;

select to_char(sysdate,'MMDD') from dual;

select * from MRP_SCHEDULE_DESIGNATORS 
where schedule_designator = 'TW1MDS0711';