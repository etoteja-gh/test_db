package v9_9_x

databaseChangeLog {
	clid = "9-9-45-parameters-to-app-params"

	changeSet(id: "${clid}.1", author: "snimavat") {
		sql("insert into AppParam (id, Variable, value) SELECT 4015, 'generateRefNumFromArTranTypeRanges', VALUE from Parameters where Variable = 'Generate RefNum from ArTranType ranges'")
		sql("insert into AppParam (id, Variable, value) SELECT 4016, 'canCloseDocTypes', VALUE from Parameters where Variable = 'Can Close Doc Types'")
		sql("insert into AppParam (id, Variable, value) SELECT 4017, 'arTranSourceIdGenerator', VALUE from Parameters where Variable = 'arTranSourceIdGenerator'")
	}
}