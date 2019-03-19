package v9_9_x

databaseChangeLog{
	clid = '9-9-06'

	changeSet(id: "${clid}.1", author: "kroberts") {
		dropDefaultValue(tableName:"ActivityAttachment",columnName:"ActivityId" )
		dropDefaultValue(tableName:"ActivityAttachment",columnName:"AttachmentId" )
		dropDefaultValue(tableName:"ActivityContact",columnName:"ActivityId" )
		dropDefaultValue(tableName:"ActivityContact",columnName:"PersonId" )
		dropDefaultValue(tableName:"ActivityLink",columnName:"ActivityId" )
		dropDefaultValue(tableName:"ActivityLink",columnName:"LinkedId" )
		dropDefaultValue(tableName:"CustTag",columnName:"custId" )
		dropDefaultValue(tableName:"CustTag",columnName:"tagId" )
		dropDefaultValue(tableName:"Payment",columnName:"ReasonId" )
	}

	changeSet(id: "${clid}.2.ms", author: "kroberts", dbms:"mssql") {
		// dropDefaultValue(tableName:"AcCorCode", columnName:"ReasonId" ) // XXX failing on microsoft
		// dropDefaultValue(tableName:"LegacyArAdjust", columnName:"AdjustedCustId" )
	}

	changeSet(id: "${clid}.2.my", author: "kroberts", dbms:"mysql") {
		dropDefaultValue(tableName:"AcCorCode", columnName:"ReasonId" )
	}

	changeSet(id: "${clid}.2.or", author: "kroberts", dbms:"oracle") {
		dropDefaultValue(tableName:"AcCorCode", columnName:"ReasonId" )
	}

	changeSet(id: "${clid}.3", author: "kroberts") {
		dropDefaultValue(tableName:"AcReasonTolerance", columnName:"ReasonId" )
	}
}