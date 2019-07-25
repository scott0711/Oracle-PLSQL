select * from fnd_lookup_values
where lookup_type = 'ITEM_TYPE'
and language = 'US';


select * from MRP_ORDERS_SC_V
where compile_designator ='MYMPS'
--and transaction_id in (92788121,92788123);
and source_table ='MRP_RECOMMENDATIONS'
order by new_due_date;

select to_char(mgr.using_assembly_demand_date,'WW'),mgr.using_requirements_quantity from mrp_gross_requirements mgr
where compile_designator='MYMRP'
and inventory_item_id = 76297
and demand_id = 133592683;

select * from MRP_RECOMMENDATIONS
where compile_designator='MYMRP'
and inventory_item_id = 76297;

select msi.segment1,bom.alternate_bom_designator from BOM_BILL_OF_MATERIALS bom, mtl_system_items msi
where bom.organization_id = 83
and bom.organization_id = msi.organization_id
and bom.assembly_item_id = msi.inventory_item_id
and bom.alternate_bom_designator is not null
and msi.item_type='FG'
and msi.inventory_item_flag = 'Y'
minus
select msi.segment1,wdj.alternate_bom_designator from wip_discrete_jobs wdj, mtl_system_items msi
where wdj.creation_date > sysdate -360
and wdj.organization_id = 83
and wdj.alternate_bom_designator is not null
and wdj.organization_id = msi.organization_id
and wdj.primary_item_id = msi.inventory_item_id
and msi.item_type='FG'
and msi.inventory_item_flag = 'Y'
;


select * from mtl_transaction_types;

select msi.segment1,bom.alternate_bom_designator, bic.operation_seq_num,bic.component_item_id ,msi1.segment1,bic.component_quantity,
qty as onhand, txn_date
from BOM_INVENTORY_COMPONENTS bic, BOM_BILL_OF_MATERIALS bom,mtl_system_items msi,mtl_system_items msi1
,(
select organization_id,inventory_item_id,NVL(SUM(MOQ.TRANSACTION_QUANTITY), 0) QTY from MTL_ONHAND_QUANTITIES moq --_DETAIL  moq
where moq.organization_id = 83
group by organization_id, inventory_item_id
--and moq.inventory_item_id = 2470675;
) a,
(
select organization_id,inventory_item_id,max(transaction_date) txn_date from mtl_material_transactions mmt
where mmt.organization_id = 83
and mmt.transaction_type_id = 35 
group by organization_id , inventory_item_id
--and mmt.inventory_item_id = 2470675
--and transaction_date >= sysdate - 180;
) b
where bom.organization_id = 83
--and bom.organization_id = bic.organization_id
and bom.organization_id = msi.organization_id
and bom.assembly_item_id = msi.inventory_item_id
and msi1.organization_id = 83
and msi.segment1 = '2N7002_R1_00001'
and bic.bill_sequence_id = bom.bill_sequence_id
and bic.component_item_id = msi1.inventory_item_id
and bom.alternate_bom_designator is not null
--and a.organization_id = 83
and a.inventory_item_id (+)= bic.component_item_id
and b.inventory_item_id (+)= bic.component_item_id
and msi1.segment1 like 'WAF%'
order by msi.segment1, bom.alternate_bom_designator, operation_seq_num;

-- WIP Issue
select max(transaction_date) from mtl_material_transactions mmt
where mmt.organization_id = 83
and mmt.transaction_type_id = 35 
and mmt.inventory_item_id = 2470675
and transaction_date >= sysdate - 180;

-- Onhand
select NVL(SUM(MOQ.TRANSACTION_QUANTITY), 0) QTY from MTL_ONHAND_QUANTITIES moq --_DETAIL  moq
where moq.organization_id = 83
and moq.inventory_item_id = 3646283;

select segment1 from mtl_system_items msi
where msi.organization_id = 83
and msi.inventory_item_id = 2470675;
