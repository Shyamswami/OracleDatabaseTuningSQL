UNDEFINE MONITORED_SID

DROP TABLE BEFOREOTHERSESSION;

CREATE TABLE BEFOREOTHERSESSION AS
SELECT SID,EVENT TIMESOURCE,(TIME_WAITED/100) SECONDS FROM V$SESSION_EVENT 
WHERE SID in (select sid from v$px_session where QCSID=&&MONITORED_SID);

INSERT INTO BEFOREOTHERSESSION SELECT SID,'CPU' TIMESOURCE,(VALUE/100) SECONDS FROM V$SESSTAT 
WHERE SID in (select sid from v$px_session where QCSID=&&MONITORED_SID)
AND STATISTIC#=(SELECT STATISTIC# FROM V$STATNAME WHERE NAME='CPU used by this session');

COMMIT;

INSERT INTO BEFOREOTHERSESSION
SELECT SID,
'REALELAPSED' TIMESOURCE,
(SYSDATE-TO_DATE('01/01/1900','MM/DD/YYYY'))*24*60*60 SECONDS
FROM V$SESSION WHERE SID in (select sid from v$px_session where QCSID=&&MONITORED_SID);

COMMIT;
