select * from ra_cust_trx_types_all


select * from RA_ACCOUNT_DEFAULT_SEGMENTS 


select * from org_organization_definitions

select * from mtl_system_items
where segment1 = 'BAV99W-L_R1_000A1'
and organization_id = 84

select * from oe_order_headers_all oha,oe_order_lines_all ola
where oha.header_id = ola.header_id
and oha.order_number = '3219000081'
and ola.inventory_item_id = 18346

select * from mtl_demand
where organization_id = 84
and inventory_item_id = 18346

select * from MTL_DEMAND_OMOE
where inventory_item_id = 18346
and organization_id = 84

select * from mtl_supply_demand_temp
where inventory_item_id = 18346
and organization_id = 84

/* Sales Order Statistics */
SELECT
    fu.user_name,
    last_name,
    fu.description,
    a.*
FROM
    (
        SELECT
            ola.org_id,
            ola.created_by,
            ola.header_id,
            trunc(ola.creation_date, 'MONTH') ym,
            COUNT(ola.line_id) lines,
            SUM(ola.invoiced_quantity * ola.unit_selling_price_per_pqty) billed_amt,
            SUM(ola.ordered_quantity * ola.unit_selling_price) selling_amt
        FROM
            oe_order_lines_all ola
        WHERE
            ola.creation_date >= trunc(SYSDATE,'year')
        GROUP BY
            ola.org_id,
            ola.created_by ,
            ola.header_id,
            trunc(ola.creation_date,'MONTH')
    ) a,
    fnd_user                                                                                                                                                                                                                                                                                                                                                                                           fu,
    per_people_v7                                                                                                                                                                                                                                                                                                                                                                                      pp
WHERE
    a.created_by = fu.user_id
    AND pp.person_id = fu.employee_id