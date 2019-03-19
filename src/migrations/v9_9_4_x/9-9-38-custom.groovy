package v9_9_x

databaseChangeLog{
	clid = "9-9-38-Custom"

	changeSet(author: "Alexey", id: "${clid}.1") {
		renameColumn(tableName: "Custom1", oldColumnName: "User01", newColumnName: "num1",columnDataType: "NUMERIC(21,6)")
		renameColumn(tableName: "Custom1", oldColumnName: "User02", newColumnName: "num2",columnDataType: "NUMERIC(21,6)")
		renameColumn(tableName: "Custom1", oldColumnName: "User03", newColumnName: "num3",columnDataType: "NUMERIC(21,6)")
		renameColumn(tableName: "Custom1", oldColumnName: "User04", newColumnName: "num4",columnDataType: "NUMERIC(21,6)")
		renameColumn(tableName: "Custom1", oldColumnName: "User05", newColumnName: "num5",columnDataType: "BIGINT")
		renameColumn(tableName: "Custom1", oldColumnName: "User06", newColumnName: "num6",columnDataType: "BIGINT")

		renameColumn(tableName: "Custom1", oldColumnName: "User09", newColumnName: "date1",columnDataType: "DATETIME")
		renameColumn(tableName: "Custom1", oldColumnName: "User10", newColumnName: "date2",columnDataType: "DATETIME")
		renameColumn(tableName: "Custom1", oldColumnName: "User11", newColumnName: "date3",columnDataType: "DATETIME")
		renameColumn(tableName: "Custom1", oldColumnName: "User12", newColumnName: "date4",columnDataType: "DATETIME")

		renameColumn(tableName: "Custom1", oldColumnName: "User13", newColumnName: "text1",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom1", oldColumnName: "User14", newColumnName: "text2",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom1", oldColumnName: "User15", newColumnName: "text3",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom1", oldColumnName: "User16", newColumnName: "text4",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom1", oldColumnName: "User17", newColumnName: "text5",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom1", oldColumnName: "User18", newColumnName: "text6",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom1", oldColumnName: "User19", newColumnName: "text7",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom1", oldColumnName: "User20", newColumnName: "text8",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom1", oldColumnName: "User07", newColumnName: "text9",columnDataType: "BIGINT")
		renameColumn(tableName: "Custom1", oldColumnName: "User08", newColumnName: "text10",columnDataType: "BIGINT")


		renameColumn(tableName: "Custom2", oldColumnName: "User01", newColumnName: "num1",columnDataType: "NUMERIC(21,6)")
		renameColumn(tableName: "Custom2", oldColumnName: "User02", newColumnName: "num2",columnDataType: "NUMERIC(21,6)")
		renameColumn(tableName: "Custom2", oldColumnName: "User03", newColumnName: "num3",columnDataType: "NUMERIC(21,6)")
		renameColumn(tableName: "Custom2", oldColumnName: "User04", newColumnName: "num4",columnDataType: "NUMERIC(21,6)")
		renameColumn(tableName: "Custom2", oldColumnName: "User05", newColumnName: "num5",columnDataType: "BIGINT")
		renameColumn(tableName: "Custom2", oldColumnName: "User06", newColumnName: "num6",columnDataType: "BIGINT")

		renameColumn(tableName: "Custom2", oldColumnName: "User09", newColumnName: "date1",columnDataType: "DATETIME")
		renameColumn(tableName: "Custom2", oldColumnName: "User10", newColumnName: "date2",columnDataType: "DATETIME")
		renameColumn(tableName: "Custom2", oldColumnName: "User11", newColumnName: "date3",columnDataType: "DATETIME")
		renameColumn(tableName: "Custom2", oldColumnName: "User12", newColumnName: "date4",columnDataType: "DATETIME")

		renameColumn(tableName: "Custom2", oldColumnName: "User13", newColumnName: "text1",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom2", oldColumnName: "User14", newColumnName: "text2",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom2", oldColumnName: "User15", newColumnName: "text3",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom2", oldColumnName: "User16", newColumnName: "text4",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom2", oldColumnName: "User17", newColumnName: "text5",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom2", oldColumnName: "User18", newColumnName: "text6",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom2", oldColumnName: "User19", newColumnName: "text7",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom2", oldColumnName: "User20", newColumnName: "text8",columnDataType: "VARCHAR(255)")
		renameColumn(tableName: "Custom2", oldColumnName: "User07", newColumnName: "text9",columnDataType: "BIGINT")
		renameColumn(tableName: "Custom2", oldColumnName: "User08", newColumnName: "text10",columnDataType: "BIGINT")
	}

changeSet(author: "Alexey", id: "${clid}.2") {
		dropNotNullConstraint(tableName:"Custom1",columnName:"Name",columnDataType:"varchar(50)")
		dropNotNullConstraint(tableName:"Custom2",columnName:"Name",columnDataType:"varchar(50)")
	}

	changeSet(author: "Alexey", id: "${clid}.3") {

		modifyDataType(tableName: 'Custom1', columnName: 'num5', newDataType: 'NUMERIC(21,6)')
		modifyDataType(tableName: 'Custom1', columnName: 'num6', newDataType: 'NUMERIC(21,6)')

		modifyDataType(tableName: 'Custom1', columnName: 'text9', newDataType: 'VARCHAR(255)')
		modifyDataType(tableName: 'Custom1', columnName: 'text10', newDataType: 'VARCHAR(255)')

		modifyDataType(tableName: 'Custom2', columnName: 'num5', newDataType: 'NUMERIC(21,6)')
		modifyDataType(tableName: 'Custom2', columnName: 'num6', newDataType: 'NUMERIC(21,6)')

		modifyDataType(tableName: 'Custom2', columnName: 'text9', newDataType: 'VARCHAR(255)')
		modifyDataType(tableName: 'Custom2', columnName: 'text10', newDataType: 'VARCHAR(255)')
	}
}
