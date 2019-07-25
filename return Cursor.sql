create or replace procedure GetAllUser ( L_CURSOR OUT SYS_REFCURSOR)
is
begin
    OPEN L_CURSOR FOR
       SELECT user_id, user_name, start_date,end_date,description,last_logon_date FROM fnd_user;
end;

