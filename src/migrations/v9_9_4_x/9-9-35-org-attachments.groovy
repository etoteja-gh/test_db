package v9_9_x

databaseChangeLog{
	clid = "9-9-35-org-attachments"

	changeSet(id: "${clid}.1", author: "snimavat") {
		createTable(tableName: "OrgAttachment") {
			column(name: "orgId", type: "bigint") {
				constraints(nullable: false)
			}
			column(name: "attachmentId", type: "bigint") {
				constraints(nullable: false)
			}
		}
	}
}