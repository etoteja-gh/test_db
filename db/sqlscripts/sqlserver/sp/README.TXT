DCS/sql/mssql/sp

This directory contains all the creation scripts for stored procedures.

Here are the rules:
	- The name of the file is the name of the procedure, plus a .sql suffix.
	- The destination database is already directly connected.
	- No database names will be referenced inside the script unless that script inherently connects to a
		different database.
	- The script will be easy to read and maintain.
