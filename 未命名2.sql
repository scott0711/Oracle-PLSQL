select d.user_name "User Name",
b.sid SID,b.serial# "Serial#", c.spid "srvPID", a.SPID "OS_PID",
to_char(START_TIME,'DD-MON-YY HH:MM:SS') "STime"
from fnd_logins a, v$session b, v$process c, fnd_user d
where b.paddr = c.addr
and a.pid=c.pid
and a.spid = b.process
and d.user_id = a.user_id

select * from v$session v, v$process p
where v.sid = 1142
and v.paddr = p.addr


select s.sid, p.spid "Thread ID", b.name "Background Process", s.username
"User Name",
s.osuser "OS User", s.status "STATUS", s.sid "Session ID",
s.serial# "Serial No.",
s.program "OS Program",s.machine,s.module
from v$process p, v$bgprocess b, v$session s
where s.paddr = p.addr and b.paddr(+) = p.addr
order by 1,s.sid,s.status; 


-- Who is using Undo
select s.sid, 
       s.username,
       sum(ss.value) / 1024 / 1024 as undo_size_mb,
       s.sql_id
from  v$sesstat ss
  join v$session s on s.sid = ss.sid
  join v$statname stat on stat.statistic# = ss.statistic#
where stat.name = 'undo change vector size'
and s.type <> 'BACKGROUND'
and s.username IS NOT NULL
group by s.sid, s.username,s.sql_id
order by 3;


select sum(ss.value) / 1024 / 1024 as undo_size_mb
from
v$sesstat ss
join v$statname stat on stat.statistic# = ss.statistic#
where stat.name = 'undo change vector size'


select sum(undoblks)* 8196 /1024/1024 from V$UNDOSTAT;

-- 1. To check the current size of the Undo tablespace:
select sum(a.bytes) as undo_size 
from v$datafile a, v$tablespace b, dba_tablespaces c 
where c.contents = 'UNDO' and c.status = 'ONLINE' and b.name = c.tablespace_name and a.ts# = b.ts#;

-- 2. To check the free space (unallocated) space within Undo tablespace:
select sum(bytes)/1024/1024 "mb" from dba_free_space where tablespace_name ='APPS_UNDOTS1';

select tablespace_name , sum(blocks)*8/(1024) space_in_use from dba_undo_extents where status IN ('ACTIVE','UNEXPIRED') group by  tablespace_name;



SELECT s.inst_id,
        r.name                   rbs,
        nvl(s.username, 'None')  oracle_user,
        s.osuser                 client_user,
        p.username               unix_user,
        s.Machine,
        s.program,
        to_char(s.sid)||','||to_char(s.serial#) as sid_serial,
        p.spid                   unix_pid,
        TO_CHAR(s.logon_time, 'mm/dd/yy hh24:mi:ss') as login_time,
        t.used_ublk * 8192  as undo_BYTES,
                st.sql_text as sql_text
   FROM gv$process     p,
        v$rollname     r,
        gv$session     s,
        gv$transaction t,
        gv$sqlarea     st
  WHERE p.inst_id=s.inst_id
    AND p.inst_id=t.inst_id
    AND s.inst_id=st.inst_id
    AND s.taddr = t.addr
    AND s.paddr = p.addr(+)
    AND r.usn   = t.xidusn(+)
    AND s.sql_address = st.address
 --   AND t.used_ublk * 8192 > 10000
  -- AND t.used_ublk * 8192 > 1073741824
  ORDER
       BY undo_BYTES desc;