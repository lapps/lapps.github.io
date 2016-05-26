CREATE OR REPLACE FUNCTION "AccessStat.increment"(
  ugid character varying, uid character varying
  , sngid character varying, sid character varying, nid character varying
  , ad timestamp without time zone
  , td timestamp without time zone, pd integer
  , tm timestamp without time zone, pm integer
  , ty timestamp without time zone, py integer
  , reqsz integer, ressz integer, resms integer)
  RETURNS integer AS
$BODY$declare
  affected int4;
begin
lock table accessstat in exclusive mode;
update AccessStat
  set accesscount = accesscount + 1
    , requestbytes = requestbytes + reqsz
    , responsebytes = responsebytes + ressz
    , responsemillis = responsemillis + resms
    , lastAccessDateTime = ad
  where userGridId=ugid and userId=uid
    and serviceAndNodeGridId=sngid
    and serviceId=sid and nodeId=nid
    and (
      (period=pd and baseDateTime=td)
      or
      (period=pm and baseDateTime=tm)
      or
      (period=py and baseDateTime=ty)
    )
  ;
GET DIAGNOSTICS affected = ROW_COUNT;
if affected >= 3 then
  return 3;
end if;
insert into AccessStat
  (userGridId, userId, serviceAndNodeGridId, serviceId, nodeId, baseDateTime, period
    , accessCount, requestBytes, responseBytes, responseMillis, lastAccessDateTime)
  values
  (ugid, uid, sngid, sid, nid, td, pd, 1, reqsz, ressz, resms, ad)
  ;
if affected >= 2 then
  return 2;
end if;
insert into AccessStat
  (userGridId, userId, serviceAndNodeGridId, serviceId, nodeId, baseDateTime, period
    , accessCount, requestBytes, responseBytes, responseMillis, lastAccessDateTime)
  values
  (ugid, uid, sngid, sid, nid, tm, pm, 1, reqsz, ressz, resms, ad)
  ;
if affected >= 1 then
  return 1;
end if;
insert into AccessStat
  (userGridId, userId, serviceAndNodeGridId, serviceId, nodeId, baseDateTime, period
    , accessCount, requestBytes, responseBytes, responseMillis, lastAccessDateTime)
  values
  (ugid, uid, sngid, sid, nid, ty, py, 1, reqsz, ressz, resms, ad)
  ;
return 0;
end
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
