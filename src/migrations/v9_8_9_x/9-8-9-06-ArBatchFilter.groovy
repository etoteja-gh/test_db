package v9_8_9_x

databaseChangeLog{
    clid = '9-8-9-06-ArBatchFilter'

	changeSet(id: "${clid}.1", author: "Alexey") {
		sql("insert into AcSetup (id, Variable, value, description) values (62, 'defaultUserToOwnerOnArBatchFilter', 'false','on arbatch filter under Owner automatically add default owner or not')")
	}

}
