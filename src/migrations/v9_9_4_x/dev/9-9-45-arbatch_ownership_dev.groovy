package v9_9_x.dev

databaseChangeLog = {
	clid = "9-9-45-arbatch_ownership_dev"

	changeSet(id: "${clid}.1", author: "ken", context:'dev',
		description: "Make all payments owned by Marsha except 1201, which is owned by Karen.") {
		sql "truncate table PaymentOwner;"
		sql """insert into PaymentOwner(PaymentId,OwnerId,Version,CreatedBy,CreatedDate,EditedBy,EditedDate)
			select id, 109,0,1,CreatedDate,1,EditedDate from Payment where id <> 1201;
		"""
		sql """insert into PaymentOwner(PaymentId,OwnerId,Version,CreatedBy,CreatedDate,EditedBy,EditedDate)
			select id, 107,0,1,CreatedDate,1,EditedDate from Payment where id = 1201;
		"""
	}


}