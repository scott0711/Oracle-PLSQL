select * from PO_ASL_SUPPLIERS_V
-- PO_ASL_STATUSES PAST , PO_APPROVED_SUPPLIER_LIST PASL1 , 
-- PO_ASL_ATTRIBUTES PAA , PO_APPROVED_SUPPLIER_LIST PASL
select * from po_asl_attributes;

select * from po_vendors;

select * from po_vendor_sites;

select * from po_approved_supplier_list;

select * from dba_objects
where object_name like 'PO_ASL_TH%';


select pv.vendor_name,msi.segment1,pasl.* 
from po_approved_supplier_list pasl, po_vendors pv,mtl_system_items msi
where pasl.vendor_id (+)= pv.vendor_id
and pasl.item_id = msi.inventory_item_id
and pasl.owning_organization_id = msi.organization_id;

DECLARE

x_row_id VARCHAR2(20);
x_asl_id NUMBER;

BEGIN

apps.po_asl_ths.insert_row
(x_row_id,
x_asl_id,
83, --using_organization_id
83, --owning_organization_id,
'DIRECT', --vendor_business_type,
2, --status_id,
SYSDATE, --last_updated_date
11187, --last_updated_by,
SYSDATE, --creation_date,
11187, --created_by,
NULL,
497, --vendor_id,
239, --inventory_item_id,
NULL,
181, --vendor_site_id,
null, --primary_vendor_item,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL);
COMMIT;
END;

;

DECLARE
x_row_id VARCHAR2(20);

BEGIN
apps.po_asl_attributes_ths.insert_row
(x_row_id,
182, --asl_id
83, --using_organization_id,
SYSDATE, --last_updated_date
11187, --last_updated_by,
SYSDATE, --creation_date
11187, --created_by,
'ASL', --document_sourcing_method
'CREATE_AND_APPROVE', --release_generation_method
NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
497, --vendor_id,
181, --vendor_site_id,
239, --inventory_item_id,
NULL,
'2476', --attribute_category
'09', --state(attribute1),
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,
'TW', --country_of_origin_code,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
NULL,NULL,NULL,NULL,NULL,NULL,NULL);

COMMIT;
END;