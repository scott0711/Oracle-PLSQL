select msi.segment1,bor.routing_sequence_id ,bos.operation_seq_num,bd.department_code,a.*
from bom_operational_routings bor,mtl_system_items msi,bom_operation_sequences bos,bom_departments bd,
(select bors.operation_sequence_id,br.resource_id,br.resource_code,br.description,
bors.resource_seq_num,bors.usage_rate_or_amount,schedule_flag from bom_operation_resources bors,bom_resources br
where br.resource_id = bors.resource_id ) a 
where bor.organization_id = msi.organization_id
and msi.organization_id = 83
and bor.assembly_item_id = msi.inventory_item_id
and msi.segment1 = '2N7002_R1_00001'
and bor.alternate_routing_designator is null
and bos.routing_sequence_id = bor.routing_sequence_id
and bd.department_id = bos.department_id
and a.operation_sequence_id(+) = bos.operation_sequence_id
order by bos.operation_seq_num,a.resource_seq_num;


select * from bom_operation_sequences bos
where bos.routing_sequence_id =2635329;

select * from bom_operation_resources bors
where bors.operation_sequence_id =4016784;

select br.resource_id,br.resource_code,br.description from bom_resources br
where br.resource_id = 456205