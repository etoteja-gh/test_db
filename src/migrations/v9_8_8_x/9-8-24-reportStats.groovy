package v9_8_8_x

databaseChangeLog{
    clid = '9-8-24-reportStats'

    changeSet(id: "${clid}.1", author: "Igor",  dbms:'mysql') {
        addColumn(tableName: 'ReportResult') {
            column(name:'params', type:'varchar(max)')
        }
        addColumn(tableName: 'ReportResult') {
            column(name:'memoryStartMb', type:'BIGINT')
        }
        addColumn(tableName: 'ReportResult') {
            column(name:'memoryEndMb', type:'BIGINT')
        }
        addColumn(tableName: 'ReportResult') {
            column(name:'generatedStart', type:'TIMESTAMP')
        }
    }

    changeSet(id: "${clid}.2", author: "Igor",  dbms:'mssql') {
        addColumn(tableName: 'ReportResult') {
            column(name:'params', type:'NVARCHAR(MAX)')
        }
        addColumn(tableName: 'ReportResult') {
            column(name:'memoryStartMb', type:'BIGINT')
        }
        addColumn(tableName: 'ReportResult') {
            column(name:'memoryEndMb', type:'BIGINT')
        }
        addColumn(tableName: 'ReportResult') {
            column(name:'generatedStart', type:'TIMESTAMP')
        }
    }

    changeSet(id: "${clid}.3", author: "Igor",  dbms:'oracle') {
        addColumn(tableName: 'ReportResult') {
            column(name:'params', type:'NVARCHAR(MAX)')
        }
        addColumn(tableName: 'ReportResult') {
            column(name:'memoryStartMb', type:'BIGINT')
        }
        addColumn(tableName: 'ReportResult') {
            column(name:'memoryEndMb', type:'BIGINT')
        }
        addColumn(tableName: 'ReportResult') {
            column(name:'generatedStart', type:'TIMESTAMP')
        }
    }

}
