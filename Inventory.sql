select * from mtl_lot_numbers
where rownum < 20


select secondary_inventory_name subinventory,
description,
subinventory_type,
organization_id,
asset_inventory,
quantity_tracked,
inventory_atp_code,
availability_type,
reservable_type,
locator_type,
picking_order,
dropping_order,
location_id,
status_id
from mtl_secondary_inventories
where organization_id in (82,83)

select * from org_organization_definitions
where set_of_books_id = 2021


select * from gl_sets_of_books

select * from hr_all_organization_units
where name like '%TW%'

select * from hr_locations
where location_code like 'PanJit%';


select  distinct
        hp.party_name "Customer Name",
        hca.account_number,
        hca.status,
        hcsu.location,
        hcsu.site_use_code,
        hcsu.status loc_stat,
        ps.class,
        hcsu.site_use_id,
        hcpc.name profile_name,
        hl.address1,
        hl.address2,
        hl.address3,
        hl.city,
        hl.state,
        hl.postal_code,
        ps.customer_id,
        ps.customer_site_use_id,
        hps.identifying_address_flag,
        ps.trx_date,
        HOU.NAME "Operating Unit"
from    apps.hz_parties hp,
        apps.hz_party_sites hps,
        apps.hz_locations hl,
        apps.hz_cust_accounts hca,
        apps.hz_cust_acct_sites hcas,
        apps.hz_cust_site_uses hcsu,
        apps.hz_customer_profiles hcp,
        apps.hz_cust_profile_classes hcpc,
        apps.ar_payment_schedules_all ps,
        apps.hr_operating_units hou
where   hp.party_id = hca.party_id(+)
        and hp.party_id = hcp.party_id
        and hp.party_id = hps.party_id
        and hps.party_site_id = hcas.party_site_id
        and hps.location_id = hl.location_id
        and hca.cust_account_id = hcas.cust_account_id
        and hcas.cust_acct_site_id = hcsu.cust_acct_site_id
        and hca.cust_account_id = hcp.cust_account_id
        and hca.cust_account_id = ps.customer_id
        and hcp.profile_class_id = hcpc.profile_class_id
        and ps.customer_site_use_id = hcsu.site_use_id
        and hcsu.org_id = hou.organization_id;


Begin
fnd_global.apps_initialize(0,82,1);
end;
/

begin
fnd_client_info.set_org_context(52091);
end;

begin
dbms_application_info.set_client_info(143);           
end;
commit;

select * from V$NLS_PARAMETERS;

alter session set NLS_LANGUAGE ='SPANISH';


NLS_TERRITORY
NLS_CURRENCY
NLS_CALENDAR
NLS_DATE_LANGUAGE
NLS_DATE_FORMAT


select * from ar_customers;

select  userenv('LANG') from dual;


alter session set NLS_LANGUAGE = 'AMERICAN'

select * from oe_transaction_types_vl;

SELECT
    b.rowid   row_id,
    b.transaction_type_id,
    b.transaction_type_code,
    b.order_category_code,
    b.start_date_active,
    b.end_date_active,
    b.creation_date,
    b.created_by,
    b.last_update_date,
    b.last_updated_by,
    b.last_update_login,
    b.program_application_id,
    b.program_id,
    b.request_id,
    b.currency_code,
    b.conversion_type_code,
    b.cust_trx_type_id,
    b.cost_of_goods_sold_account,
    b.entry_credit_check_rule_id,
    b.shipping_credit_check_rule_id,
    b.price_list_id,
    b.enforce_line_prices_flag,
    b.warehouse_id,
    b.demand_class_code,
    b.shipment_priority_code,
    b.shipping_method_code,
    b.freight_terms_code,
    b.fob_point_code,
    b.ship_source_type_code,
    b.agreement_type_code,
    b.agreement_required_flag,
    b.po_required_flag,
    b.invoicing_rule_id,
    b.invoicing_credit_method_code,
    b.accounting_rule_id,
    b.accounting_credit_method_code,
    b.invoice_source_id,
    b.non_delivery_invoice_source_id,
    b.default_inbound_line_type_id,
    b.default_outbound_line_type_id,
    b.inspection_required_flag,
    b.depot_repair_code,
    b.auto_scheduling_flag,
    b.scheduling_level_code,
    b.default_fulfillment_set,
    b.default_line_set_code,
    b.context,
    b.attribute1,
    b.attribute2,
    b.attribute3,
    b.attribute4,
    b.attribute5,
    b.attribute6,
    b.attribute7,
    b.attribute8,
    b.attribute9,
    b.attribute10,
    b.attribute11,
    b.attribute12,
    b.attribute13,
    b.attribute14,
    b.attribute15,
    t.name,
    t.description,
    b.org_id,
    b.tax_calculation_event_code,
    b.picking_credit_check_rule_id,
    b.packing_credit_check_rule_id,
    b.min_margin_percent,
    b.sales_document_type_code,
    b.def_transaction_phase_code,
    b.quote_num_as_ord_num_flag,
    b.layout_template_id,
    b.contract_template_id
FROM
    oe_transaction_types_tl t,
    OE_TRANSACTION_TYPES_ALL b
WHERE
    b.transaction_type_id = t.transaction_type_id
    AND t.language = userenv('LANG');
    
    
    select * from oe_transaction_types_tl 
    where language =     userenv('LANG');
    
    select * from  oe_transaction_types_syn b
    
    
    select 'The Inventory Organization '
||oo.organization_code||'has the inventory organization ID of '
||oo.organization_id||' and is under the Operating Unit '
||hro.name||' which has the Operating Unit ID of '||oo.operating_Unit
from org_organization_definitions oo, hr_all_organization_units hro
where upper(oo.organization_code) like upper('%&INV_ORG_CODE%')
and hro.organization_id = oo.operating_unit;

