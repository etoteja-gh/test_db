package v9_9_x

databaseChangeLog{
	clid = '9-9-28-ArApi'

	changeSet(id: "${clid}.1", author: "snimavat") {

		sql("insert into AppParam (id, Variable, value) values (1398, 'apiArTranAddMissingCustAccount', 'false')")
		sql("insert into AppParam (id, Variable, value) values (1399, 'apiUnknownCustAccountNum', '')")
		sql("update AppParam set value = 'Main' where variable = 'apiDefaultCompanyNum' ")

		createTable(tableName:"ArApi") {
			column(name: "id", type: "BIGINT") {
				constraints(nullable: "false", primaryKey: "true", primaryKeyName: "PK_ArApi")
			}

			//artran columns
			column(name: "amount", type: "NUMERIC(21,6)")
			column(name: "docType", type: "VARCHAR(5)")
			column(name: "companyId", type: "BIGINT")
			column(name: "companyNum", type: "VARCHAR(50)")
			column(name: "companySourceId", type: "VARCHAR(50)")
			column(name: "refnum", type: "VARCHAR(50)")
			column(name: "refnum2", type: "VARCHAR(50)")
			column(name: "ponum", type: "VARCHAR(50)")
			column(name: "comments", type: "VARCHAR(50)")

			column(name: "origAmount", type: "NUMERIC(21,6)")
			column(name: "discAmount", type: "NUMERIC(21,6)")

			column(name: "closedDate", type: "DATETIME")
			column(name: "tranDate", type: "DATETIME")
			column(name: "glPostDate", type: "DATETIME")
			column(name: "discDate", type: "DATETIME")
			column(name: "dueDate", type: "DATETIME")
			column(name: "glAcct", type: "VARCHAR(50)")
			column(name: "glDetailAcct", type: "VARCHAR(50)")
			column(name: "glPostPeriod", type: "VARCHAR(10)")

			column(name: "tranType.id", type: "BIGINT")

			//linesum
			column(name: "lineSum.shipping", type: "NUMERIC(21,6)")
			column(name: "lineSum.serviceCharge", type: "NUMERIC(21,6)")
			column(name: "lineSum.taxPct", type: "NUMERIC(21,6)")
			column(name: "lineSum.taxTotal", type: "NUMERIC(21,6)")
			column(name: "lineSum.discPct", type: "NUMERIC(21,6)")
			column(name: "lineSum.discTotal", type: "NUMERIC(21,6)")

			//customer/custaccount
			column(name: "customer.id", type: "BIGINT")
			column(name: "customer.num", type: "VARCHAR(50)")
			column(name: "customer.name", type: "VARCHAR(255)")
			column(name: "customer.org.source.sourceId", type: "VARCHAR(255)")
			column(name: "custAccount.id", type: "BIGINT")
			column(name: "custAccount.num", type: "VARCHAR(50)")
			column(name: "custAccount.name", type: "VARCHAR(255)")
			column(name: "custAccount.org.source.sourceId", type: "VARCHAR(255)")
			//ext columns
			column(name: "ext.statusRemarkId", type: "BIGINT")
			column(name: "ext.reasonSubId", type: "BIGINT")
			column(name: "ext.bolNum", type: "VARCHAR(50)")
			column(name: "ext.crossRefnum", type: "VARCHAR(50)")
			column(name: "ext.orderNum", type: "VARCHAR(50)")
			column(name: "ext.poAmount", type: "NUMERIC(21,6)")
			column(name: "ext.poDate", type: "DATETIME")
			column(name: "ext.rmaNum", type: "VARCHAR(50)")
			column(name: "ext.shipDate", type: "DATETIME")
			column(name: "ext.shipToAttn", type: "VARCHAR(255)")
			column(name: "ext.shipToName", type: "VARCHAR(50)")
			column(name: "ext.statusChangeDate", type: "DATETIME")
			column(name: "ext.storeNum", type: "VARCHAR(50)")
			column(name: "ext.masterTranAmount", type: "NUMERIC(21,6)")
			column(name: "ext.masterTranDate", type: "DATETIME")
			column(name: "ext.masterTranNum", type: "VARCHAR(50)")
			column(name: "ext.masterTranType", type: "VARCHAR(50)")
			column(name: "ext.origCurrencyAmount", type: "NUMERIC(21,6)")

			//flex columns
			column(name: "flex.text1", type: "VARCHAR(255)")
			column(name: "flex.text2", type: "VARCHAR(255)")
			column(name: "flex.text3", type: "VARCHAR(255)")
			column(name: "flex.text4", type: "VARCHAR(255)")
			column(name: "flex.text5", type: "VARCHAR(255)")
			column(name: "flex.text6", type: "VARCHAR(255)")
			column(name: "flex.text7", type: "VARCHAR(255)")
			column(name: "flex.text8", type: "VARCHAR(255)")
			column(name: "flex.text9", type: "VARCHAR(255)")
			column(name: "flex.text10", type: "VARCHAR(255)")
			column(name: "flex.num1", type: "NUMERIC(21,6)")
			column(name: "flex.num2", type: "NUMERIC(21,6)")
			column(name: "flex.num3", type: "NUMERIC(21,6)")
			column(name: "flex.num4", type: "NUMERIC(21,6)")
			column(name: "flex.num5", type: "NUMERIC(21,6)")
			column(name: "flex.num6", type: "NUMERIC(21,6)")
			column(name: "flex.date1", type: "DATETIME")
			column(name: "flex.date2", type: "DATETIME")
			column(name: "flex.date3", type: "DATETIME")
			column(name: "flex.date4", type: "DATETIME")

			//source columns
			column(name: "tranSource.source", type: "VARCHAR(255)")
			column(name: "tranSource.sourceId", type: "VARCHAR(255)")
			column(name: "tranSource.sourceType", type: "VARCHAR(255)")

			//related
			column(name: "related.cashUser.id", type: "BIGINT")
			column(name: "related.collector.id", type: "BIGINT")
			column(name: "related.disputeResolver.id", type: "BIGINT")
			column(name: "related.salesPerson.id", type: "BIGINT")
			column(name: "related.shipToLocationId", type: "BIGINT")

			//dispute
			column(name: "dispute.disputeAmount", type: "NUMERIC(21,6)")
			column(name: "dispute.reason.id", type: "BIGINT")
			column(name: "dispute.reason.name", type: "VARCHAR(50)")
			column(name: "dispute.reason.sourceId", type: "VARCHAR(50)")

			//line columns
			column(name: "line.amount", type: "NUMERIC(21,6)")
			column(name: "line.discPercent", type: "NUMERIC(21,6)")
			column(name: "line.discAmount", type: "NUMERIC(21,6)")
			column(name: "line.taxable", type: "BIT")
			column(name: "line.units", type: "NUMERIC(21,6)")
			column(name: "line.unitPrice", type: "NUMERIC(21,6)")
			column(name: "line.itemId", type: "BIGINT")
			column(name: "line.description", type: "VARCHAR(255)")
			column(name: "line.glAcct", type: "VARCHAR(50)")
			column(name: "line.itemType", type: "VARCHAR(50)")
			column(name: "line.orderNum", type: "VARCHAR(50)")
			column(name: "line.uom", type: "VARCHAR(255)")
			column(name: "line.itemCode", type: "VARCHAR(255)")
			column(name: "line.source", type: "VARCHAR(50)")
			column(name: "line.sourceId", type: "VARCHAR(50)")

			//line flex
			column(name: "line.flex.text1", type: "VARCHAR(255)")
			column(name: "line.flex.text2", type: "VARCHAR(255)")
			column(name: "line.flex.text3", type: "VARCHAR(255)")
			column(name: "line.flex.text4", type: "VARCHAR(255)")
			column(name: "line.flex.text5", type: "VARCHAR(255)")
			column(name: "line.flex.text6", type: "VARCHAR(255)")
			column(name: "line.flex.text7", type: "VARCHAR(255)")
			column(name: "line.flex.text8", type: "VARCHAR(255)")
			column(name: "line.flex.text9", type: "VARCHAR(255)")
			column(name: "line.flex.text10", type: "VARCHAR(255)")
			column(name: "line.flex.num1", type: "NUMERIC(21,6)")
			column(name: "line.flex.num2", type: "NUMERIC(21,6)")
			column(name: "line.flex.num3", type: "NUMERIC(21,6)")
			column(name: "line.flex.num4", type: "NUMERIC(21,6)")
			column(name: "line.flex.num5", type: "NUMERIC(21,6)")
			column(name: "line.flex.num6", type: "NUMERIC(21,6)")
			column(name: "line.flex.date1", type: "DATETIME")
			column(name: "line.flex.date2", type: "DATETIME")
			column(name: "line.flex.date3", type: "DATETIME")
			column(name: "line.flex.date4", type: "DATETIME")


			//billship
			column(name: "billShip.billName", type: "VARCHAR(255)")
			column(name: "billShip.billCity", type: "VARCHAR(255)")
			column(name: "billShip.billStreet1", type: "VARCHAR(255)")
			column(name: "billShip.billStreet2", type: "VARCHAR(255)")
			column(name: "billShip.billState", type: "VARCHAR(255)")
			column(name: "billShip.billZipCode", type: "VARCHAR(255)")
			column(name: "billShip.billCountry", type: "VARCHAR(255)")
			column(name: "billShip.billCounty", type: "VARCHAR(255)")
			column(name: "billShip.billIns1", type: "VARCHAR(255)")
			column(name: "billShip.billIns2", type: "VARCHAR(255)")
			column(name: "billShip.billIns3", type: "VARCHAR(255)")
			column(name: "billShip.billIns4", type: "VARCHAR(255)")

			column(name: "billShip.shipName", type: "VARCHAR(255)")
			column(name: "billShip.shipStreet1", type: "VARCHAR(255)")
			column(name: "billShip.shipStreet2", type: "VARCHAR(255)")
			column(name: "billShip.shipCity", type: "VARCHAR(255)")
			column(name: "billShip.shipState", type: "VARCHAR(255)")
			column(name: "billShip.shipZipCode", type: "VARCHAR(255)")
			column(name: "billShip.shipCountry", type: "VARCHAR(255)")
			column(name: "billShip.shipCounty", type: "VARCHAR(255)")
			column(name: "billShip.shipPhone", type: "VARCHAR(255)")

			column(name: "billShip.shipIns1", type: "VARCHAR(255)")
			column(name: "billShip.shipIns2", type: "VARCHAR(255)")
			column(name: "billShip.shipIns3", type: "VARCHAR(255)")
			column(name: "billShip.shipIns4", type: "VARCHAR(255)")
			column(name: "billShip.shipVia", type: "VARCHAR(255)")
		}

	}

	changeSet(id: "${clid}.2", author: "snimavat") {
		addColumn(tableName: "ArApi") {
			column(name: "custAccount.org.member.branch.id", type: "bigint")
		}
	}

	changeSet(id: "${clid}.3", author: "snimavat") {
		addColumn(tableName: "ArApi") {
			column(name: "inBatch.id", type: "bigint")
		}
	}

}