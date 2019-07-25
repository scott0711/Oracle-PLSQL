CREATE OR REPLACE procedure  pj_mrp_waitfor (v_compile_designator  IN    VARCHAR2)
is 
    v_flag number:=0;
begin

    loop 
            select nvl2(PLAN_COMPLETION_DATE,1,0) into v_flag
                 from mrp_plans
                where compile_designator = v_compile_designator;

            DBMS_LOCK.SLEEP( 10 );  -- DBMS_LOCK.SLEEP( 幾秒 );
            dbms_output.put_line('Waiting');
            exit when (v_flag > 0);
    end loop;
end pj_mrp_waitfor;


begin
    pj_mrp_waitfor('PD-MPS-LCS');
end;

