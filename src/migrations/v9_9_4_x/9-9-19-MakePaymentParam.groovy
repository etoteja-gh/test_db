package v9_9_x

databaseChangeLog{
    clid = '9-9-19-MakePaymentParam'
    changeSet(author: "Alexey", id: "${clid}.1") {
        sql("insert into AppParam (id, Variable, value) values (105, 'onlinePaymentEnable', 'true')")
    }

    changeSet(author: "snimavat", id: "${clid}.2") {
        sql("insert into AppParam (id, Variable, value) values (107, 'disputeReviewOrgTypeLevel', 'Company')")
    }

}
