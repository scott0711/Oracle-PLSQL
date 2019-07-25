declare
    remain number:=0;
    relief_qty number:=0;
begin
for somds_rec in ( select mps_transaction_id,inventory_item_id,msd.schedule_quantity,msd.schedule_date,
                          msd.source_sales_order_id,source_line_id
                   -- msd.*
                    from mrp_schedule_dates msd
                    where msd.schedule_designator = '0613MDS'
                      and msd.schedule_level = 2
                      and inventory_item_id in (1977268,2124279)
                    --  and rownum < 20
                    order by msd.inventory_item_id, msd.schedule_date ) loop
                    DBMS_OUTPUT.PUT_LINE('--');
                    dbms_output.put_line( somds_rec.mps_transaction_id);
                    DBMS_OUTPUT.PUT_LINE('--');
                    remain := somds_rec.schedule_quantity;
                    for mainmds_rec in ( select mps_transaction_id,inventory_item_id,msd.schedule_quantity,msd.schedule_date 
                                          from mrp_schedule_dates msd
                                         where msd.schedule_designator = 'KP-MDS-WEI'  -- Main MDS
                                           and msd.schedule_level = 2
                                           and msd.schedule_quantity > 0    -- 忽略無量可沖銷
                                           and msd.inventory_item_id = somds_rec.inventory_item_id                      
                                         order by msd.inventory_item_id, msd.schedule_date ) loop
                                         
                                         DBMS_OUTPUT.PUT_line('2nd loop');
                                         DBMS_OUTPUT.PUT_line(remain);
                                         dbms_output.put_line( mainmds_rec.mps_transaction_id);
                                         dbms_output.put_line( mainmds_rec.schedule_quantity);
                                         DBMS_OUTPUT.PUT_LINE('');
                                         if mainmds_rec.schedule_quantity >= remain then
                                       
                                                relief_qty := remain;
                                                update mrp_schedule_dates
                                                    set schedule_quantity = mainmds_rec.schedule_quantity - remain
                                                where mps_transaction_id = mainmds_rec.mps_transaction_id;
                                                /*
                                                update mrp_schedule_dates
                                                    set schedule_quantity = 0
                                                where mps_transaction_id = somds_rec.mps_transaction_id;
                                                */
                                                remain := 0;
                                                DBMS_OUTPUT.PUT('>=');
                                                                            
                                         else
                                                relief_qty := mainmds_rec.schedule_quantity;
                                                remain := remain - mainmds_rec.schedule_quantity;
                                                
                                                update mrp_schedule_dates
                                                    set schedule_quantity = 0
                                                where mps_transaction_id = mainmds_rec.mps_transaction_id;
                                                /*
                                                update mrp_schedule_dates
                                                    set schedule_quantity = remain - mainmds_rec.schedule_quantity 
                                                where mps_transaction_id = somds_rec.mps_transaction_id;
                                                */
                                                DBMS_OUTPUT.PUT('<');
                                         end if;
                                         
                                         
                                         insert into mrp_schedule_consumptions
                                                (transaction_id, relief_type, disposition_type, disposition_id, line_num, 
                                                 order_date, order_quantity, relief_quantity,schedule_date,
                                                 last_updated_by, last_update_date,
                                                 created_by, creation_date )
                                         select mps_transaction_id,1,3,somds_rec.source_sales_order_id,somds_rec.source_line_id,
                                                schedule_date,original_schedule_quantity,relief_qty,
                                                   schedule_date, 
                                                    11187, sysdate,
                                                    11187, sysdate
                                                    from mrp_schedule_dates
                                                    where mps_transaction_id = mainmds_rec.mps_transaction_id
                                                    and schedule_level = 2;
           
                                         DBMS_OUTPUT.PUT_line(remain);
--                                         if remain = 0 then
--                                            break;
--                                        end if;
                                        exit when remain = 0;
                    end loop;
                                         
end loop;    
end;