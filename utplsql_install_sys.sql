conn / as sysdba
alter session set container = PLSQLDB;
drop user UT3 cascade;
@/tmp/utPLSQL/source/install_headless.sql UT3 ut3 users
exit
