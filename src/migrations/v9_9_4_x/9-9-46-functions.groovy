package v9_9_x

final String MSPATH = 'db/sqlscripts/sqlserver/fn'
final String MSPATH_SP = 'db/sqlscripts/sqlserver/sp'

final String MYPATH = 'db/sqlscripts/mysql/production/'
final Map args = [encoding:'utf8', relativeToChangelogFile:'false', splitStatements:'false', stripComments:'false']

databaseChangeLog {
	clid = '9-9-46-functions'

	changeSet(id: "${clid}.1.mssql", author: "ken", dbms: "mssql") {
		sqlFile([path:"${MSPATH}/FN9_CHAR.sql"] << args)
	}

	changeSet(id: "${clid}.1.mysql", author: "ken", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/FN9_CHAR.sql"] << args)
	}

	changeSet(id: "${clid}.2.mssql", author: "ken", dbms: "mssql") {
		sqlFile([path:"${MSPATH}/FN9_CONCAT.sql"] << args)
	}

	changeSet(id: "${clid}.2.mysql", author: "ken", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/FN9_CONCAT.sql"] << args)
	}

	changeSet(id: "${clid}.3.mssql", author: "ken", dbms: "mssql") {
		sqlFile([path:"${MSPATH}/FN9_CONCAT20.sql"] << args)
	}

	changeSet(id: "${clid}.3.mysql", author: "ken", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/FN9_CONCAT20.sql"] << args)
	}

	changeSet(id: "${clid}.4.mssql", author: "ken", dbms: "mssql") {
		sqlFile([path:"${MSPATH}/FN9_DATEADDDAY.sql"] << args)
	}

	changeSet(id: "${clid}.4.mysql", author: "ken", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/FN9_DATEADDDAY.sql"] << args)
	}

	changeSet(id: "${clid}.5.mssql", author: "ken", dbms: "mssql") {
		sqlFile([path:"${MSPATH}/FN9_DATEADDDAYSTR.sql"] << args)
	}

	changeSet(id: "${clid}.5.mysql", author: "ken", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/FN9_DATEADDDAYSTR.sql"] << args)
	}

	changeSet(id: "${clid}.6.mssql", author: "ken", dbms: "mssql") {
		sqlFile([path:"${MSPATH}/FN9_DATECAST.sql"] << args)
	}

	changeSet(id: "${clid}.6.mysql", author: "ken", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/FN9_DATECAST.sql"] << args)
	}

	// For some reason FN9_DATEDIFFDAY is already in the db at this point for MySQL.
	// changeSet(id: "${clid}.7.mssql", author: "ken", dbms: "mssql") {
	// 	sqlFile([path:"${MSPATH}/FN9_DATEDIFFDAY.sql"] << args)
	// }

	// changeSet(id: "${clid}.7.mysql", author: "ken", dbms: "mysql") {
	// 	sqlFile([path:"${MYPATH}/FN9_DATEDIFFDAY.sql"] << args)
	// }

	changeSet(id: "${clid}.8.mssql", author: "ken", dbms: "mssql") {
		sqlFile([path:"${MSPATH}/FN9_DATEDIFFDAYSTR.sql"] << args)
	}

	changeSet(id: "${clid}.8.mysql", author: "ken", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/FN9_DATEDIFFDAYSTR.sql"] << args)
	}

	changeSet(id: "${clid}.9.mssql", author: "ken", dbms: "mssql") {
		sqlFile([path:"${MSPATH}/FN9_PHONEFORMAT.sql"] << args)
	}

	changeSet(id: "${clid}.9.mysql", author: "ken", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/FN9_PHONEFORMAT.sql"] << args)
	}

	changeSet(id: "${clid}.10.mssql", author: "ken", dbms: "mssql") {
		sqlFile([path:"${MSPATH}/FN9_TRIM.sql"] << args)
	}

	changeSet(id: "${clid}.10.mysql", author: "ken", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/FN9_TRIM.sql"] << args)
	}

	//stored procedures
	changeSet(id: "${clid}.11.mssql", author: "snimavat", dbms: "mssql") {
		sqlFile([path:"${MSPATH_SP}/test_CorrectionPostProcess.sql"] << args)
	}

	changeSet(id: "${clid}.12.mysql", author: "snimavat", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/test_CorrectionPostProcess.sql"] << args)
	}

	changeSet(id: "${clid}.13.mssql", author: "snimavat", dbms: "mssql") {
		sqlFile([path:"${MSPATH_SP}/test_CorrectionPreProcess.sql"] << args)
	}

	changeSet(id: "${clid}.14.mysql", author: "snimavat", dbms: "mysql") {
		sqlFile([path:"${MYPATH}/test_CorrectionPreProcess.sql"] << args)
	}

}
