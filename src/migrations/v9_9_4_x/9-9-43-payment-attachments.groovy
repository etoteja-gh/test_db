package v9_9_x

databaseChangeLog{
	clid = "9-9-43-payment-attachments"

	changeSet(id: "${clid}.1", author: "snimavat") {
		addColumn(tableName: "Payment") {
			column(name: "attachmentIds", type: "varchar(255)") {
				constraints(nullable: "true")
			}
		}
	}
}