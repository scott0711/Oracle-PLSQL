DECLARE
l_session_id NUMBER;
l_return_status VARCHAR2(1);
l_msg_count NUMBER := 0;
l_msg_data VARCHAR2(1000);
l_msg_index_out NUMBER;

l_count NUMBER;
l_org_cnt NUMBER;
l_vendor_cnt NUMBER;
l_org_class VARCHAR2(3);
l_org_num NUMBER;

l_line_num NUMBER := 0;
l_err_count NUMBER := 0;
P NUMBER;
l_sourcing_rule_rec MRP_SOURCING_RULE_PUB.SOURCING_RULE_REC_TYPE;
l_sourcing_rule_val_rec MRP_SOURCING_RULE_PUB.SOURCING_RULE_VAL_REC_TYPE;

l_receiving_org_tbl MRP_SOURCING_RULE_PUB.RECEIVING_ORG_TBL_TYPE;

l_receiving_org_val_tbl MRP_SOURCING_RULE_PUB.RECEIVING_ORG_VAL_TBL_TYPE;

l_shipping_org_tbl MRP_SOURCING_RULE_PUB.SHIPPING_ORG_TBL_TYPE;

l_shipping_org_val_tbl MRP_SOURCING_RULE_PUB.SHIPPING_ORG_VAL_TBL_TYPE;

o_sourcing_rule_rec MRP_SOURCING_RULE_PUB.SOURCING_RULE_REC_TYPE;

o_sourcing_rule_val_rec MRP_SOURCING_RULE_PUB.SOURCING_RULE_VAL_REC_TYPE;

o_receiving_org_tbl MRP_SOURCING_RULE_PUB.RECEIVING_ORG_TBL_TYPE;

o_receiving_org_val_tbl MRP_SOURCING_RULE_PUB.RECEIVING_ORG_VAL_TBL_TYPE;

o_shipping_org_tbl MRP_SOURCING_RULE_PUB.SHIPPING_ORG_TBL_TYPE;

o_shipping_org_val_tbl MRP_SOURCING_RULE_PUB.SHIPPING_ORG_VAL_TBL_TYPE;


BEGIN

fnd_message.clear;

l_sourcing_rule_rec := MRP_SOURCING_RULE_PUB.G_MISS_SOURCING_RULE_REC;
l_sourcing_rule_rec.sourcing_rule_name := '&sr_name_please_enter'; --SR Name
l_sourcing_rule_rec.description := '&sr_description'; -- Description
l_sourcing_rule_rec.organization_id := FND_API.G_MISS_NUM;  -- 83; -- Rcv Org
l_sourcing_rule_rec.planning_active := 1; -- Active?
l_sourcing_rule_rec.status := 1; -- Create New record
l_sourcing_rule_rec.sourcing_rule_type := 1; -- 1:
--Sourcing Rule 2:Bill Of Distribution
l_sourcing_rule_rec.operation := 'CREATE';

l_receiving_org_tbl := MRP_SOURCING_RULE_PUB.G_MISS_RECEIVING_ORG_TBL;

l_shipping_org_tbl := MRP_SOURCING_RULE_PUB.G_MISS_SHIPPING_ORG_TBL;

l_receiving_org_tbl(1).receipt_organization_id := FND_API.G_MISS_NUM; --83;
l_receiving_org_tbl(1).effective_date := trunc(sysdate)+6;
l_receiving_org_tbl(1).disable_date := trunc(sysdate)+17;
l_receiving_org_tbl(1).operation := 'CREATE'; -- Create or Update
/*
l_shipping_org_tbl(1).rank := 1;
l_shipping_org_tbl(1).allocation_percent := 40; -- Allocation 40
l_shipping_org_tbl(1).source_type := 1;
l_shipping_org_tbl(1).source_organization_id := 84;
l_shipping_org_tbl(1).receiving_org_index := 1;
l_shipping_org_tbl(1).operation := 'CREATE';
*/
l_shipping_org_tbl(1).rank := 1;
l_shipping_org_tbl(1).allocation_percent := 60; -- Allocation 60 - total 100
l_shipping_org_tbl(1).source_type := 3;
l_shipping_org_tbl(2).source_organization_id := FND_API.G_MISS_NUM;
l_shipping_org_tbl(1).receiving_org_index := 1;
l_shipping_org_tbl(1).operation := 'CREATE';
l_shipping_org_tbl(1).vendor_id :=85346;

dbms_output.put_line('before call');
dbms_output.put_line('Operation before call '||l_sourcing_rule_rec.operation);
MRP_SOURCING_RULE_PUB.PROCESS_SOURCING_RULE(
p_api_version_number =>1.0
,p_init_msg_list =>fnd_api.g_true
--,p_return_values =>
,p_commit => fnd_api.g_true
,x_return_status =>l_return_status
,x_msg_count =>l_msg_count
,x_msg_data =>l_msg_data
,p_sourcing_rule_rec => l_sourcing_rule_rec
,p_sourcing_rule_val_rec => l_sourcing_rule_val_rec
,p_receiving_org_tbl => l_receiving_org_tbl
,p_receiving_org_val_tbl => l_receiving_org_val_tbl
,p_shipping_org_tbl => l_shipping_org_tbl
,p_shipping_org_val_tbl => l_shipping_org_val_tbl
,x_sourcing_rule_rec => o_sourcing_rule_rec
,x_sourcing_rule_val_rec => o_sourcing_rule_val_rec
,x_receiving_org_tbl => o_receiving_org_tbl
,x_receiving_org_val_tbl => o_receiving_org_val_tbl
,x_shipping_org_tbl => o_shipping_org_tbl
,x_shipping_org_val_tbl => o_shipping_org_val_tbl
);

if l_return_status = FND_API.G_RET_STS_SUCCESS then
dbms_output.put_line('Success!');
else
dbms_output.put_line('count:'||l_msg_count);

IF l_msg_count > 0 THEN
FOR l_index IN 1..l_msg_count LOOP
l_msg_data := fnd_msg_pub.get(
p_msg_index => l_index,
p_encoded => FND_API.G_FALSE);
dbms_output.put_line(substr(l_msg_data,1,250));
END LOOP;

dbms_output.put_line('MSG:'||o_sourcing_rule_rec.return_status);
END IF;
dbms_output.put_line('Failure!');
end if;

END;


