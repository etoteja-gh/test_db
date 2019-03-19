package v9_9_x

databaseChangeLog{
	clid = "9-9-37-arTran-attachments"

	changeSet(id: "${clid}.1", author: "alexey") {
		addColumn(tableName: "ArTranStats") {
			column(name: "attachmentIds", type: "varchar(255)") {
				constraints(nullable: "true")
			}
		}
	}

	changeSet(id: "${clid}.2", author: "alexey") {
		addColumn(tableName: "ArTranStats") {
			column(defaultValueBoolean: false, name: "hasNotes", type: "BIT") {
				constraints(nullable: "false")
			}
			column(defaultValueBoolean: false, name: "hasActivity", type: "BIT") {
				constraints(nullable: "false")
			}
		}
	}

	/*
	// FIXME These changesets with grailsChange don't work on 9.9.x for some reason.
	changeSet(id: "${clid}.2.mysql", author: "alexey", dbms:'mysql') {
		grailsChange {
			change {
				sql.rows("""select LinkedId, id, AttachmentId  from ActivityLink actLink
								inner JOIN ActivityAttachment actAtt on actLink.ActivityId=actAtt.ActivityId
								LEFT Join ArTranStats tranS on tranS.arTranId = LinkedId
								where actLink.LinkedEntity = 'ArTran' and actLink.ActivityId in
								(select ActivityId from  ActivityAttachment actAttach inner JOIN Activity act on act.id=actAttach.ActivityId)""" ).groupBy {it.LinkedId}.collect{k,v->
					[ LinkedId: k, attIds: v*.AttachmentId.join(','), tranStatId: v[0].id]}.each { row ->
					println(row)
						if (row.tranStatId) {
							sql.execute """Update ArTranStats set attachmentIds='${	'[' + row.attIds + ']'}' where id = ${row.tranStatId} """
						} else {
							sql.execute """insert into ArTranStats(id, ArTranId, attachmentIds) VALUES(${row.LinkedId}, ${row.LinkedId}, '${'[' + row.attIds + ']'}')"""
						}
					}
				}
		}
	}
*/
	
/*
	changeSet(id: "${clid}.4.mssql", author: "alexey", dbms:'mssql') {
		grailsChange {
			change {
				sql.eachRow("""select LinkedId, ActivityId, kind, tranS.id as statId from ActivityLink actLink
										LEFT Join Activity act on act.id = ActivityId
										LEFT Join ArTranStats tranS on tranS.arTranId = LinkedId where LinkedEntity = 'ArTran'
										and kind = 'Note'
										""" ) { row ->
					if (row.kind == 'Note'){
						if (row.statId ) {
							sql.execute """Update ArTranStats set hasNotes='true' where id = ${row.statId} """
						} else {
							sql.execute """insert into ArTranStats(id, ArTranId, hasNotes) VALUES(${row.LinkedId}, ${row.LinkedId}, 'true')"""
						}
					}
				}
			}
		}
	}
	changeSet(id: "${clid}.4.mysql", author: "alexey", dbms:'mysql') {
		grailsChange {
			change {
				sql.eachRow("""select LinkedId, ActivityId, kind, tranS.id as statId from ActivityLink actLink
										LEFT Join Activity act on act.id = ActivityId
										LEFT Join ArTranStats tranS on tranS.arTranId = LinkedId where LinkedEntity = 'ArTran'
										and kind = 'Note'
										""" ) { row ->
					if (row.kind == 'Note'){
						if (row.statId ) {
							sql.execute """Update ArTranStats set hasNotes=true where id = ${row.statId} """
						} else {
							sql.execute """insert into ArTranStats(id, ArTranId, hasNotes) VALUES(${row.LinkedId}, ${row.LinkedId}, true)"""
						}
					}
				}
			}
		}
	}

	changeSet(id: "${clid}.5.mssql", author: "alexey", dbms:'mssql') {
		grailsChange {
			change {
				sql.eachRow("""select LinkedId, ActivityId, kind, tranS.id as statId from ActivityLink actLink
									LEFT Join Activity act on act.id = ActivityId
									LEFT Join Task task on task.id = act.TaskId
									LEFT Join ArTranStats tranS on tranS.arTranId = LinkedId where LinkedEntity = 'ArTran'
									and task.State = 0
										""" ) { row ->
						if (row.statId ) {
							sql.execute """Update ArTranStats set hasActivity='true' where id = ${row.statId} """
						} else {
							sql.execute """insert into ArTranStats(id, ArTranId, hasActivity) VALUES(${row.LinkedId}, ${row.LinkedId}, 'true')"""
						}
				}
			}
		}
	}
	changeSet(id: "${clid}.5.mysql", author: "alexey", dbms:'mysql') {
		grailsChange {
			change {
				sql.eachRow("""select LinkedId, ActivityId, kind, tranS.id as statId from ActivityLink actLink
									LEFT Join Activity act on act.id = ActivityId
									LEFT Join Task task on task.id = act.TaskId
									LEFT Join ArTranStats tranS on tranS.arTranId = LinkedId where LinkedEntity = 'ArTran'
									and task.State = 0
										""" ) { row ->
						if (row.statId ) {
							sql.execute """Update ArTranStats set hasActivity=true where id = ${row.statId} """
						} else {
							sql.execute """insert into ArTranStats(id, ArTranId, hasActivity) VALUES(${row.LinkedId}, ${row.LinkedId}, true)"""
						}
				}
			}
		}
	}
	*/

}
