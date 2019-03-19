-- Groupings are as follows:
--  An old sp_procedure name is grouped with its new dcs_procedure name, so that eventually the old one can be removed.
--  Procedures which are already matching their file name are grouped together.
if exists(select * from sysobjects where name = 'sp_docs_matching') drop procedure sp_docs_matching;
if exists(select * from sysobjects where name = 'autocash_docs_matching') drop procedure autocash_docs_matching;

if exists(select * from sysobjects where name = 'dcs_api_ARAdjust') drop procedure dcs_api_ARAdjust;
if exists(select * from sysobjects where name = 'dcs_api_ARDocDetail') drop procedure dcs_api_ARDocDetail;
if exists(select * from sysobjects where name = 'dcs_api_ARDocs_Update') drop procedure dcs_api_ARDocs_Update;
if exists(select * from sysobjects where name = 'dcs_api_ARDocs') drop procedure dcs_api_ARDocs;

if exists(select * from sysobjects where name = 'sp_API_ARDocsAging') drop procedure sp_API_ARDocsAging;
if exists(select * from sysobjects where name = 'dcs_api_ARDocsAging') drop procedure dcs_api_ARDocsAging;

if exists(select * from sysobjects where name = 'sp_api_ARSumAging') drop procedure sp_api_ARSumAging;
if exists(select * from sysobjects where name = 'dcs_api_ARSumAging') drop procedure dcs_api_ARSumAging;

if exists(select * from sysobjects where name = 'sp_api_ARSummary') drop procedure sp_api_ARSummary;
if exists(select * from sysobjects where name = 'dcs_api_ARSummary') drop procedure dcs_api_ARSummary;

if exists(select * from sysobjects where name = 'sp_api_Notes') drop procedure sp_api_Notes;
if exists(select * from sysobjects where name = 'dcs_api_Notes') drop procedure dcs_api_Notes;

if exists(select * from sysobjects where name = 'dcs_api_Orgs_Update') drop procedure dcs_api_Orgs_Update;
if exists(select * from sysobjects where name = 'dcs_api_Orgs') drop procedure dcs_api_Orgs;

if exists(select * from sysobjects where name = 'sp_api_Persons') drop procedure sp_api_Persons;
if exists(select * from sysobjects where name = 'dcs_api_Persons') drop procedure dcs_api_Persons;

if exists(select * from sysobjects where name = 'dcs_ArScoreCard') drop procedure dcs_ArScoreCard;

if exists(select * from sysobjects where name = 'dcs_ArScoreCard_Users') drop procedure dcs_ArScoreCard_Users;
if exists(select * from sysobjects where name = 'dcs_ArScoreCardUsers') drop procedure dcs_ArScoreCardUsers;

if exists(select * from sysobjects where name = 'sp_AUDIT_Changes') drop procedure sp_AUDIT_Changes;
if exists(select * from sysobjects where name = 'dcs_audit_Changes') drop procedure dcs_audit_Changes;

if exists(select * from sysobjects where name = 'sp_AUTO_Activities') drop procedure sp_AUTO_Activities;
if exists(select * from sysobjects where name = 'dcs_auto_Activities') drop procedure dcs_auto_Activities;

if exists(select * from sysobjects where name = 'dcs_demo_updateDates') drop procedure dcs_demo_updateDates;

if exists(select * from sysobjects where name = 'dcs_out_api_ArAdjust') drop procedure dcs_out_api_ArAdjust;
if exists(select * from sysobjects where name = 'dcs_out_api_ArDocs') drop procedure dcs_out_api_ArDocs;

if exists(select * from sysobjects where name = 'sp_post_import') drop procedure sp_post_import;
if exists(select * from sysobjects where name = 'dcs_post_import') drop procedure dcs_post_import;

if exists(select * from sysobjects where name = 'sp_api_OrgsAging') drop procedure sp_api_OrgsAging;
if exists(select * from sysobjects where name = 'dcs_update_OrgsAging') drop procedure dcs_update_OrgsAging;

if exists(select * from sysobjects where name = 'dev_Archive') drop procedure dev_Archive;
if exists(select * from sysobjects where name = 'dev_CopyTableData') drop procedure dev_CopyTableData;
if exists(select * from sysobjects where name = 'dev_generate_NewObjectID') drop procedure dev_generate_NewObjectID;
if exists(select * from sysobjects where name = 'dev_GetTableSpaceInfo') drop procedure dev_GetTableSpaceInfo;
if exists(select * from sysobjects where name = 'dev_PullAPISample') drop procedure dev_PullAPISample;
if exists(select * from sysobjects where name = 'dev_PullDbSample') drop procedure dev_PullDbSample;
if exists(select * from sysobjects where name = 'dev_PullTableData') drop procedure dev_PullTableData;
if exists(select * from sysobjects where name = 'test_dcs_api_ARDocDetail') drop procedure test_dcs_api_ARDocDetail;
if exists(select * from sysobjects where name = 'test_dcs_api_ARDocs') drop procedure test_dcs_api_ARDocs;
if exists(select * from sysobjects where name = 'test_dcs_api_Orgs') drop procedure test_dcs_api_Orgs;
if exists(select * from sysobjects where name = 'test_get_top100') drop procedure test_get_top100;
if exists(select * from sysobjects where name = 'upgrade_AclAndParameters') drop procedure upgrade_AclAndParameters;

if exists(select * from sysobjects where name = 'sp_TPMS_APIDealActivity') drop procedure sp_TPMS_APIDealActivity;
if exists(select * from sysobjects where name = 'tpms_APIDealActivity') drop procedure tpms_APIDealActivity;

if exists(select * from sysobjects where name = 'sp_TPMS_APIDealExport') drop procedure sp_TPMS_APIDealExport;
if exists(select * from sysobjects where name = 'tpms_APIDealExport') drop procedure tpms_APIDealExport;

if exists(select * from sysobjects where name = 'sp_TPMS_BatchStart') drop procedure sp_TPMS_BatchStart;
if exists(select * from sysobjects where name = 'tpms_BatchStart') drop procedure tpms_BatchStart;

if exists(select * from sysobjects where name = 'sp_TPMS_CustStruct_Load') drop procedure sp_TPMS_CustStruct_Load;
if exists(select * from sysobjects where name = 'tpms_CustStruct_Load') drop procedure tpms_CustStruct_Load;

if exists(select * from sysobjects where name = 'sp_TPMS_DDtoDealActivity') drop procedure sp_TPMS_DDtoDealActivity;
if exists(select * from sysobjects where name = 'tpms_DDtoDealActivity') drop procedure tpms_DDtoDealActivity;

if exists(select * from sysobjects where name = 'sp_TPMS_DealActivityFacts') drop procedure sp_TPMS_DealActivityFacts;
if exists(select * from sysobjects where name = 'tpms_DealActivityFacts') drop procedure tpms_DealActivityFacts;

if exists(select * from sysobjects where name = 'sp_TPMS_FundReports') drop procedure sp_TPMS_FundReports;
if exists(select * from sysobjects where name = 'tpms_FundReports') drop procedure tpms_FundReports;

if exists(select * from sysobjects where name = 'sp_TPMS_Liability') drop procedure sp_TPMS_Liability;
if exists(select * from sysobjects where name = 'tpms_Liability') drop procedure tpms_Liability;

if exists(select * from sysobjects where name = 'sp_TPMS_LoadCustomersFromAPI') drop procedure sp_TPMS_LoadCustomersFromAPI;
if exists(select * from sysobjects where name = 'tpms_LoadCustomersFromAPI') drop procedure tpms_LoadCustomersFromAPI;

if exists(select * from sysobjects where name = 'sp_TPMS_LoadFactStructures') drop procedure sp_TPMS_LoadFactStructures;
if exists(select * from sysobjects where name = 'tpms_LoadFactStructures') drop procedure tpms_LoadFactStructures;

if exists(select * from sysobjects where name = 'sp_TPMS_LoadProductsFromAPI') drop procedure sp_TPMS_LoadProductsFromAPI;
if exists(select * from sysobjects where name = 'tpms_LoadProductsFromAPI') drop procedure tpms_LoadProductsFromAPI;

if exists(select * from sysobjects where name = 'sp_TPMS_PostDealActivity') drop procedure sp_TPMS_PostDealActivity;
if exists(select * from sysobjects where name = 'tpms_PostDealActivity') drop procedure tpms_PostDealActivity;

if exists(select * from sysobjects where name = 'sp_TPMS_ProdStruct_Load') drop procedure sp_TPMS_ProdStruct_Load;
if exists(select * from sysobjects where name = 'tpms_ProdStruct_Load') drop procedure tpms_ProdStruct_Load;

if exists(select * from sysobjects where name = 'sp_TPMS_UpdateDeals') drop procedure sp_TPMS_UpdateDeals;
if exists(select * from sysobjects where name = 'tpms_UpdateDeals') drop procedure tpms_UpdateDeals;

