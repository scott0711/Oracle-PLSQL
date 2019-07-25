declare
    v_user_id number;
    v_resp_id number;
    v_resp_appl_id number;
    v_request_id number;
begin
SELECT user_id
   INTO v_user_id
  FROM applsys.fnd_user
  WHERE user_name = '91638';
  
  SELECT responsibility_id
   INTO v_resp_id
   FROM apps.fnd_responsibility_vl
   WHERE responsibility_name ='配銷_NEW'; --Responsibility Name
   
   SELECT application_id
   INTO v_resp_appl_id
   FROM applsys.fnd_application
   WHERE application_short_name = 'ONT'; --application name
   
   
   fnd_global.apps_initialize (user_id => v_user_id,
                            resp_id => v_resp_id,
                            resp_appl_id => v_resp_appl_id
                            );
    v_request_id:=Fnd_Request.submit_request (
--    application   => 'MRP',
--    Program       => 'MRCSAL',
--    description   => 'Load/Copy/Merge MDS',
--    start_time    => '',
--    sub_request   => FALSE,
    'MRP','MRCSAL','Load/Copy/Merge MDS','',FALSE,
   1, 83, '0104MDS', 6, 83, '0104來源', 2, null , 1, 1, '2019/06/26 00:00:00', '2020/02/26 00:00:00', 2, 1, 2, 0, 0, 0, 1, 0, 0, 100, 1, 1  );
/*
IF l_request_status THEN
    IF l_dev_status = 'NORMAL' THEN
        NULL;
    ELSE
        Fnd_Message.Debug('Request執行失敗：'||l_dev_status);
        RETURN;
    END IF;
  ELSE
    Fnd_Message.Debug('Request執行失敗');
    RETURN;
END IF;
*/
end;
