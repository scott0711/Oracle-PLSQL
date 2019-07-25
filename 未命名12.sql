declare 
salesorder_id number:=114045360;
oe_header_id number:=0;
return_status varchar2(100):='Hello World';
begin

inv_salesOrder.get_oeheader_for_salesorder(
		p_salesorder_id => salesorder_id,
		x_oe_header_id => oe_header_id		 ,
		x_return_status =>return_status		);
        
        dbms_output.put(return_status);
          dbms_output.put('return_status');
        
end;