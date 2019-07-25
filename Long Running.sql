select distinct user_name,
decode( s.status, 'ACTIVE', '*', 'INACTIVE', null, 'KILLED', 'K', '?' ) status,
decode( s.lockwait, null, null, 'E' ) enqueue,
s.last_call_et/60 last_call_min,
s.module,
s.inst_id,
s.sid,
s.serial#,
-- s.username orcl_usr,
-- s.osuser osuser,
s.process,
p.spid,
to_char( trunc(sysdate) + ( sysdate - s.logon_time ), 'hh24:mi:ss' ) duration,
( i.block_gets + i.consistent_gets ) /
( ( sysdate - s.logon_time ) * 86400 ) log_per_sec,
i.block_gets + i.consistent_gets logical,
physical_reads /
( ( sysdate - s.logon_time ) * 86400 ) phy_per_sec,
i.physical_reads,
-- s.action,
email_address
from applsys.fnd_logins l,
applsys.fnd_user u,
gv$session s,
gv$sess_io i,
gv$process p
where l.user_id = u.user_id
and s.sid = i.sid
and s.inst_id = i.inst_id
and p.pid = l.pid
-- and s.process = l.spid
and p.spid = l.process_spid(+)
and l.end_time is null
and s.paddr = p.addr(+)
and s.inst_id = p.inst_id(+)
and ( s.module in ( 'FNDATTCH', 'FNDSCSGN' )
or substr( s.action, 1, 5 ) = 'FRM::' )
and s.last_call_et >= 300
and s.status in ( 'ACTIVE', 'KILLED' )
order by last_call_min desc;


select s.sid, p.spid "Thread ID", b.name "Background Process", s.username
"User Name",
s.osuser "OS User", s.status "STATUS", s.sid "Session ID",
s.serial# "Serial No.",
s.program "OS Program",s.machine,s.module
from v$process p, v$bgprocess b, v$session s
where s.paddr = p.addr and b.paddr(+) = p.addr
order by 1,s.sid,s.status; 