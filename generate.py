import os
import sys
from sets import Set

def main(argv):
	ora_objects = [ ("FUNCTION"	, "CUBE_TABLE" ), 
("FUNCTION"	, "DM_CL_APPLY" ),
("FUNCTION"	, "DM_CL_BUILD" ),
("FUNCTION"	, "DM_GLM_BUILD" ),
("FUNCTION"	, "DM_MOD_BUILD" ),
("FUNCTION"	, "DM_NMF_BUILD" ),
("FUNCTION"	, "DM_SVM_APPLY" ),
("FUNCTION"	, "DM_SVM_BUILD" ),
("FUNCTION"	, "GETXMLSCHEMADEPENDENCYLIST" ),
("FUNCTION"	, "GET_TABLE_NAME" ),
("FUNCTION", "HS$_DDTF_SQLCOLUMNS" ),
("FUNCTION", "HS$_DDTF_SQLFOREIGNKEYS" ),
("FUNCTION", "HS$_DDTF_SQLPRIMARYKEYS" ),
("FUNCTION", "HS$_DDTF_SQLPROCEDURES" ),
("FUNCTION", "HS$_DDTF_SQLSTATISTICS" ),
("FUNCTION", "HS$_DDTF_SQLTABLES" ),
("FUNCTION", "HS$_DDTF_SQLTABPRIKEYS" ),
("FUNCTION", "HS$_DDTF_SQLTABSTATS" ),
("FUNCTION"	, "ISXMLTYPETABLE" ),
("FUNCTION"	, "IS_VPD_ENABLED" ),
("FUNCTION" , "LOGMNR$ALWSUPLOG_TABF_PUBLIC" ),
("FUNCTION"	, "LOGMNR_GET_GT_PROTOCOL" ),
("FUNCTION"	, "OLAPRC_TABLE" ),
("FUNCTION"	, "OLAP_BOOL_SRF" ),
("FUNCTION"	, "OLAP_CONDITION" ),
("FUNCTION"	, "OLAP_DATE_SRF" ),
("FUNCTION"	, "OLAP_TABLE" ),
("FUNCTION"	, "ORA_FI_DECISION_TREE_HORIZ" ),
("FUNCTION"	, "ORA_FI_SUPERVISED_BINNING" ),
("FUNCTION"	, "USER_XML_PARTITIONED_TABLE_OK" ),
("PACKAGE BODY"	, "AS_REPLAY" ),
("PACKAGE BODY"	, "DBMSHSXP" ),
("PACKAGE BODY"	, "DBMSOBJG" ),
("PACKAGE BODY"	, "DBMSOBJG2" ),
("PACKAGE BODY"	, "DBMSOBJGWRAPPER" ),
("PACKAGE BODY"	, "DBMSOBJG_DP" ),
("PACKAGE BODY"	, "DBMSZEXP_SYSPKGGRNT" ),
("PACKAGE BODY"	, "DBMS_ADDM" ),
("PACKAGE BODY"	, "DBMS_ADR" ),
("PACKAGE BODY"	, "DBMS_ADVANCED_REWRITE" ),
("PACKAGE BODY"	, "DBMS_ADVISOR" ),
("PACKAGE BODY"	, "DBMS_ALERT" ),
("PACKAGE BODY"	, "DBMS_APBACKEND" ),
("PACKAGE BODY"	, "DBMS_APPCTX" ),
("PACKAGE BODY"	, "DBMS_APPLICATION_INFO" ),
("PACKAGE BODY"	, "DBMS_APPLY_ADM" ),
("PACKAGE BODY"	, "DBMS_APPLY_ADM_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_APPLY_ERROR" ),
("PACKAGE BODY"	, "DBMS_APPLY_HANDLER_ADM" ),
("PACKAGE BODY"	, "DBMS_APPLY_HANDLER_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_APPLY_POSITION" ),
("PACKAGE BODY"	, "DBMS_APPLY_PROCESS" ),
("PACKAGE BODY"	, "DBMS_APP_CONT_PRVT" ),
("PACKAGE BODY"	, "DBMS_AQ" ),
("PACKAGE BODY"	, "DBMS_AQADM" ),
("PACKAGE BODY"	, "DBMS_AQADM_INV" ),
("PACKAGE BODY"	, "DBMS_AQADM_SYS" ),
("PACKAGE BODY"	, "DBMS_AQADM_SYSCALLS" ),
("PACKAGE BODY"	, "DBMS_AQELM" ),
("PACKAGE BODY"	, "DBMS_AQIN" ),
("PACKAGE BODY"	, "DBMS_AQJMS" ),
("PACKAGE BODY"	, "DBMS_AQJMS_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_AQ_BQVIEW" ),
("PACKAGE BODY"	, "DBMS_AQ_EXP_CMT_TIME_TABLES" ),
("PACKAGE BODY"	, "DBMS_AQ_EXP_DEQUEUELOG_TABLES" ),
("PACKAGE BODY"	, "DBMS_AQ_EXP_HISTORY_TABLES" ),
("PACKAGE BODY"	, "DBMS_AQ_EXP_INDEX_TABLES" ),
("PACKAGE BODY"	, "DBMS_AQ_EXP_QUEUES" ),
("PACKAGE BODY"	, "DBMS_AQ_EXP_SIGNATURE_TABLES" ),
("PACKAGE BODY"	, "DBMS_AQ_EXP_SUBSCRIBER_TABLES" ),
("PACKAGE BODY"	, "DBMS_AQ_EXP_TIMEMGR_TABLES" ),
("PACKAGE BODY"	, "DBMS_AQ_EXP_ZECURITY" ),
("PACKAGE BODY"	, "DBMS_AQ_IMPORT_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_AQ_IMP_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_AQ_IMP_ZECURITY" ),
("PACKAGE BODY"	, "DBMS_AQ_INV" ),
("PACKAGE BODY"	, "DBMS_AQ_SYS_EXP_ACTIONS" ),
("PACKAGE BODY"	, "DBMS_AQ_SYS_EXP_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_AQ_SYS_IMP_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_ARCH_PROVIDER_INTL" ),
("PACKAGE BODY"	, "DBMS_ASH_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_ASYNCRPC_PUSH" ),
("PACKAGE BODY"	, "DBMS_AUDIT_MGMT" ),
("PACKAGE BODY"	, "DBMS_AUTOTASK_PRVT" ),
("PACKAGE BODY"	, "DBMS_AUTO_SQLTUNE" ),
("PACKAGE BODY"	, "DBMS_AUTO_TASK" ),
("PACKAGE BODY"	, "DBMS_AUTO_TASK_ADMIN" ),
("PACKAGE BODY"	, "DBMS_AUTO_TASK_IMMEDIATE" ),
("PACKAGE BODY"	, "DBMS_AWR_REPORT_LAYOUT" ),
("PACKAGE BODY"	, "DBMS_AW_EXP" ),
("PACKAGE BODY"	, "DBMS_AW_STATS" ),
("PACKAGE BODY"	, "DBMS_BACKUP_RESTORE" ),
("PACKAGE BODY"	, "DBMS_CACHEUTIL" ),
("PACKAGE BODY"	, "DBMS_CAPTURE_ADM" ),
("PACKAGE BODY"	, "DBMS_CAPTURE_PROCESS" ),
("PACKAGE BODY"	, "DBMS_CAPTURE_SWITCH_ADM" ),
("PACKAGE BODY"	, "DBMS_CAPTURE_SWITCH_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_CDC_DPUTIL" ),
("PACKAGE BODY"	, "DBMS_CDC_EXPDP" ),
("PACKAGE BODY"	, "DBMS_CDC_EXPVDP" ),
("PACKAGE BODY"	, "DBMS_CDC_IMPDP" ),
("PACKAGE BODY"	, "DBMS_CDC_IMPDPV" ),
("PACKAGE BODY"	, "DBMS_CDC_IPUBLISH" ),
("PACKAGE BODY"	, "DBMS_CDC_ISUBSCRIBE" ),
("PACKAGE BODY"	, "DBMS_CDC_PUBLISH" ),
("PACKAGE BODY"	, "DBMS_CDC_SUBSCRIBE" ),
("PACKAGE BODY"	, "DBMS_CDC_SYS_IPUBLISH" ),
("PACKAGE BODY"	, "DBMS_CDC_UTILITY" ),
("PACKAGE BODY"	, "DBMS_CHANGE_NOTIFICATION" ),
("PACKAGE BODY"	, "DBMS_CLIENT_RESULT_CACHE" ),
("PACKAGE BODY"	, "DBMS_CMP_INT" ),
("PACKAGE BODY"	, "DBMS_COMPARISON" ),
("PACKAGE BODY"	, "DBMS_COMPRESSION" ),
("PACKAGE BODY"	, "DBMS_CRYPTO" ),
("PACKAGE BODY"	, "DBMS_CRYPTO_FFI" ),
("PACKAGE BODY"	, "DBMS_CUBE_LOG" ),
("PACKAGE BODY"	, "DBMS_DATAPUMP" ),
("PACKAGE BODY"	, "DBMS_DATAPUMP_UTL" ),
("PACKAGE BODY"	, "DBMS_DATA_MINING" ),
("PACKAGE BODY"	, "DBMS_DATA_MINING_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_DATA_MINING_TRANSFORM" ),
("PACKAGE BODY"	, "DBMS_DBFS_CONTENT" ),
("PACKAGE BODY"	, "DBMS_DBFS_CONTENT_ADMIN" ),
("PACKAGE BODY"	, "DBMS_DBFS_SFS" ),
("PACKAGE BODY"	, "DBMS_DBFS_SFS_ADMIN" ),
("PACKAGE BODY"	, "DBMS_DBLINK" ),
("PACKAGE BODY"	, "DBMS_DBVERIFY" ),
("PACKAGE BODY"	, "DBMS_DDL" ),
("PACKAGE BODY"	, "DBMS_DDL_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_DEBUG" ),
("PACKAGE BODY"	, "DBMS_DEBUG_JDWP" ),
("PACKAGE BODY"	, "DBMS_DEFER" ),
("PACKAGE BODY"	, "DBMS_DEFERGEN" ),
("PACKAGE BODY"	, "DBMS_DEFERGEN_AUDIT" ),
("PACKAGE BODY"	, "DBMS_DEFERGEN_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_DEFERGEN_LOB" ),
("PACKAGE BODY"	, "DBMS_DEFERGEN_PRIORITY" ),
("PACKAGE BODY"	, "DBMS_DEFERGEN_RESOLUTION" ),
("PACKAGE BODY"	, "DBMS_DEFERGEN_WRAP" ),
("PACKAGE BODY"	, "DBMS_DEFER_ENQ_UTL" ),
("PACKAGE BODY"	, "DBMS_DEFER_IMPORT_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_DEFER_INTERNAL_QUERY" ),
("PACKAGE BODY"	, "DBMS_DEFER_INTERNAL_SYS" ),
("PACKAGE BODY"	, "DBMS_DEFER_QUERY" ),
("PACKAGE BODY"	, "DBMS_DEFER_QUERY_UTL" ),
("PACKAGE BODY"	, "DBMS_DEFER_REPCAT" ),
("PACKAGE BODY"	, "DBMS_DEFER_SYS" ),
("PACKAGE BODY"	, "DBMS_DEFER_SYS_PART1" ),
("PACKAGE BODY"	, "DBMS_DG" ),
("PACKAGE BODY"	, "DBMS_DIMENSION" ),
("PACKAGE BODY"	, "DBMS_DISTRIBUTED_TRUST_ADMIN" ),
("PACKAGE BODY"	, "DBMS_DM_EXP_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_DM_IMP_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_DM_MODEL_EXP" ),
("PACKAGE BODY"	, "DBMS_DM_MODEL_IMP" ),
("PACKAGE BODY"	, "DBMS_DM_UTIL" ),
("PACKAGE BODY"	, "DBMS_DM_UTIL_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_DRS" ),
("PACKAGE BODY"	, "DBMS_DST" ),
("PACKAGE BODY"	, "DBMS_EDITIONS_UTILITIES" ),
("PACKAGE BODY"	, "DBMS_EPG" ),
("PACKAGE BODY"	, "DBMS_ERRLOG" ),
("PACKAGE BODY"	, "DBMS_EXPORT_EXTENSION" ),
("PACKAGE BODY"	, "DBMS_EXTENDED_TTS_CHECKS" ),
("PACKAGE BODY"	, "DBMS_FBT" ),
("PACKAGE BODY"	, "DBMS_FEATURE_USAGE" ),
("PACKAGE BODY"	, "DBMS_FEATURE_USAGE_REPORT" ),
("PACKAGE BODY"	, "DBMS_FGA" ),
("PACKAGE BODY"	, "DBMS_FILE_GROUP" ),
("PACKAGE BODY"	, "DBMS_FILE_GROUP_EXP" ),
("PACKAGE BODY"	, "DBMS_FILE_GROUP_IMP" ),
("PACKAGE BODY"	, "DBMS_FILE_GROUP_IMP_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_FILE_GROUP_INTERNAL_INVOK" ),
("PACKAGE BODY"	, "DBMS_FILE_GROUP_UTL" ),
("PACKAGE BODY"	, "DBMS_FILE_GROUP_UTL_INVOK" ),
("PACKAGE BODY"	, "DBMS_FILE_TRANSFER" ),
("PACKAGE BODY"	, "DBMS_FLASHBACK" ),
("PACKAGE BODY"	, "DBMS_FLASHBACK_ARCHIVE" ),
("PACKAGE BODY"	, "DBMS_FREQUENT_ITEMSET" ),
("PACKAGE BODY"	, "DBMS_FUSE" ),
("PACKAGE BODY"	, "DBMS_GOLDENGATE_AUTH" ),
("PACKAGE BODY"	, "DBMS_HA_ALERTS" ),
("PACKAGE BODY"	, "DBMS_HA_ALERTS_PRVT" ),
("PACKAGE BODY"	, "DBMS_HM" ),
("PACKAGE BODY"	, "DBMS_HPROF" ),
("PACKAGE BODY"	, "DBMS_HS" ),
("PACKAGE BODY"	, "DBMS_HS_ALT" ),
("PACKAGE BODY"	, "DBMS_HS_CHK" ),
("PACKAGE BODY"	, "DBMS_HS_PARALLEL" ),
("PACKAGE BODY"	, "DBMS_HS_UTL" ),
("PACKAGE BODY"	, "DBMS_IJOB" ),
("PACKAGE BODY"	, "DBMS_INDEX_UTL" ),
("PACKAGE BODY"	, "DBMS_INTERNAL_LOGSTDBY" ),
("PACKAGE BODY"	, "DBMS_INTERNAL_REPCAT" ),
("PACKAGE BODY"	, "DBMS_INTERNAL_SAFE_SCN" ),
("PACKAGE BODY"	, "DBMS_INTERNAL_TRIGGER" ),
("PACKAGE BODY"	, "DBMS_IREFRESH" ),
("PACKAGE BODY"	, "DBMS_ISCHED" ),
("PACKAGE BODY"	, "DBMS_ISCHED_CHAIN_CONDITION" ),
("PACKAGE BODY"	, "DBMS_ISCHED_REMDB_JOB" ),
("PACKAGE BODY"	, "DBMS_ISNAPSHOT" ),
("PACKAGE BODY"	, "DBMS_ITRIGGER_UTL" ),
("PACKAGE BODY"	, "DBMS_I_INDEX_UTL" ),
("PACKAGE BODY"	, "DBMS_JAVA_DUMP" ),
("PACKAGE BODY"	, "DBMS_JAVA_TEST" ),
("PACKAGE BODY"	, "DBMS_JDM_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_JMS_PLSQL" ),
("PACKAGE BODY"	, "DBMS_JOB" ),
("PACKAGE BODY"	, "DBMS_LDAP" ),
("PACKAGE BODY"	, "DBMS_LDAP_API_FFI" ),
("PACKAGE BODY"	, "DBMS_LDAP_UTL" ),
("PACKAGE BODY"	, "DBMS_LOB" ),
("PACKAGE BODY"	, "DBMS_LOBUTIL" ),
("PACKAGE BODY"	, "DBMS_LOB_AM_PRIVATE" ),
("PACKAGE BODY"	, "DBMS_LOCK" ),
("PACKAGE BODY"	, "DBMS_LOG" ),
("PACKAGE BODY"	, "DBMS_LOGMNR" ),
("PACKAGE BODY"	, "DBMS_LOGMNR_D" ),
("PACKAGE BODY"	, "DBMS_LOGMNR_LOGREP_DICT" ),
("PACKAGE BODY"	, "DBMS_LOGMNR_SESSION" ),
("PACKAGE BODY"	, "DBMS_LOGREP_DEF_PROC_UTL" ),
("PACKAGE BODY"	, "DBMS_LOGREP_EXP" ),
("PACKAGE BODY"	, "DBMS_LOGREP_IMP" ),
("PACKAGE BODY"	, "DBMS_LOGREP_IMP_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_LOGREP_UTIL" ),
("PACKAGE BODY"	, "DBMS_LOGREP_UTIL_INVOK" ),
("PACKAGE BODY"	, "DBMS_LOGSTDBY" ),
("PACKAGE BODY"	, "DBMS_MAINT_GEN" ),
("PACKAGE BODY"	, "DBMS_MANAGEMENT_PACKS" ),
("PACKAGE BODY"	, "DBMS_METADATA" ),
("PACKAGE BODY"	, "DBMS_METADATA_BUILD" ),
("PACKAGE BODY"	, "DBMS_METADATA_DIFF" ),
("PACKAGE BODY"	, "DBMS_METADATA_DPBUILD" ),
("PACKAGE BODY"	, "DBMS_METADATA_INT" ),
("PACKAGE BODY"	, "DBMS_METADATA_UTIL" ),
("PACKAGE BODY"	, "DBMS_MONITOR" ),
("PACKAGE BODY"	, "DBMS_NETWORK_ACL_ADMIN" ),
("PACKAGE BODY"	, "DBMS_NETWORK_ACL_UTILITY" ),
("PACKAGE BODY"	, "DBMS_OBFUSCATION_TOOLKIT" ),
("PACKAGE BODY"	, "DBMS_OBFUSCATION_TOOLKIT_FFI" ),
("PACKAGE BODY"	, "DBMS_OFFLINE_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_OFFLINE_OG" ),
("PACKAGE BODY"	, "DBMS_OFFLINE_RGT" ),
("PACKAGE BODY"	, "DBMS_OFFLINE_SNAPSHOT" ),
("PACKAGE BODY"	, "DBMS_OFFLINE_UTL" ),
("PACKAGE BODY"	, "DBMS_OUTPUT" ),
("PACKAGE BODY"	, "DBMS_PARALLEL_EXECUTE" ),
("PACKAGE BODY"	, "DBMS_PARALLEL_EXECUTE_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_PCLXUTIL" ),
("PACKAGE BODY"	, "DBMS_PICKLER" ),
("PACKAGE BODY"	, "DBMS_PIPE" ),
("PACKAGE BODY"	, "DBMS_PITR" ),
("PACKAGE BODY"	, "DBMS_PLUGTS" ),
("PACKAGE BODY"	, "DBMS_PREDICTIVE_ANALYTICS" ),
("PACKAGE BODY"	, "DBMS_PREPROCESSOR" ),
("PACKAGE BODY"	, "DBMS_PROFILER" ),
("PACKAGE BODY"	, "DBMS_PROPAGATION_ADM" ),
("PACKAGE BODY"	, "DBMS_PROPAGATION_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_PRVTAQIM" ),
("PACKAGE BODY"	, "DBMS_PRVTAQIS" ),
("PACKAGE BODY"	, "DBMS_PRVTRMIE" ),
("PACKAGE BODY"	, "DBMS_PSWMG_IMPORT" ),
("PACKAGE BODY"	, "DBMS_RAT_MASK" ),
("PACKAGE BODY"	, "DBMS_RCVMAN" ),
("PACKAGE BODY"	, "DBMS_RECOVERABLE_SCRIPT" ),
("PACKAGE BODY"	, "DBMS_RECO_SCRIPT_INT" ),
("PACKAGE BODY"	, "DBMS_RECTIFIER_DIFF" ),
("PACKAGE BODY"	, "DBMS_RECTIFIER_FRIENDS" ),
("PACKAGE BODY"	, "DBMS_REDACT" ),
("PACKAGE BODY"	, "DBMS_REDACT_INT" ),
("PACKAGE BODY"	, "DBMS_REDEFINITION" ),
("PACKAGE BODY"	, "DBMS_REDEFINITION_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_REFRESH" ),
("PACKAGE BODY"	, "DBMS_REFRESH_EXP_LWM" ),
("PACKAGE BODY"	, "DBMS_REFRESH_EXP_SITES" ),
("PACKAGE BODY"	, "DBMS_REGISTRY" ),
("PACKAGE BODY"	, "DBMS_REGISTRY_SERVER" ),
("PACKAGE BODY"	, "DBMS_REGISTRY_SYS" ),
("PACKAGE BODY"	, "DBMS_REGXDB" ),
("PACKAGE BODY"	, "DBMS_REPAIR" ),
("PACKAGE BODY"	, "DBMS_REPCAT" ),
("PACKAGE BODY"	, "DBMS_REPCAT_ADD_MASTER" ),
("PACKAGE BODY"	, "DBMS_REPCAT_ADMIN" ),
("PACKAGE BODY"	, "DBMS_REPCAT_AUTH" ),
("PACKAGE BODY"	, "DBMS_REPCAT_CACHE" ),
("PACKAGE BODY"	, "DBMS_REPCAT_COMMON_UTL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_CONF" ),
("PACKAGE BODY"	, "DBMS_REPCAT_DECL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_EXP" ),
("PACKAGE BODY"	, "DBMS_REPCAT_FLA" ),
("PACKAGE BODY"	, "DBMS_REPCAT_FLA_MAS" ),
("PACKAGE BODY"	, "DBMS_REPCAT_FLA_UTL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_INSTANTIATE" ),
("PACKAGE BODY"	, "DBMS_REPCAT_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_INTERNAL_PACKAGE" ),
("PACKAGE BODY"	, "DBMS_REPCAT_MAS" ),
("PACKAGE BODY"	, "DBMS_REPCAT_MIG" ),
("PACKAGE BODY"	, "DBMS_REPCAT_MIGRATION" ),
("PACKAGE BODY"	, "DBMS_REPCAT_MIG_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_OBJ_UTL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_OUTPUT" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RGT" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RGT_ALT" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RGT_CHK" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RGT_CUST" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RGT_CUST2" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RGT_EXP" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RGT_UTL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RPC" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RPC_UTL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_RQ" ),
("PACKAGE BODY"	, "DBMS_REPCAT_SNA" ),
("PACKAGE BODY"	, "DBMS_REPCAT_SNA_UTL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_SQL_UTL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_UNTRUSTED" ),
("PACKAGE BODY"	, "DBMS_REPCAT_UTL" ),
("PACKAGE BODY"	, "DBMS_REPCAT_UTL2" ),
("PACKAGE BODY"	, "DBMS_REPCAT_UTL3" ),
("PACKAGE BODY"	, "DBMS_REPCAT_UTL4" ),
("PACKAGE BODY"	, "DBMS_REPCAT_VALIDATE" ),
("PACKAGE BODY"	, "DBMS_REPORT" ),
("PACKAGE BODY"	, "DBMS_REPUTIL" ),
("PACKAGE BODY"	, "DBMS_REPUTIL2" ),
("PACKAGE BODY"	, "DBMS_RESOURCE_MANAGER" ),
("PACKAGE BODY"	, "DBMS_RESOURCE_MANAGER_PRIVS" ),
("PACKAGE BODY"	, "DBMS_RESULT_CACHE" ),
("PACKAGE BODY"	, "DBMS_RLS" ),
("PACKAGE BODY"	, "DBMS_RMGR_GROUP_EXPORT" ),
("PACKAGE BODY"	, "DBMS_RMGR_PACT_EXPORT" ),
("PACKAGE BODY"	, "DBMS_RMGR_PLAN_EXPORT" ),
("PACKAGE BODY"	, "DBMS_RMIN" ),
("PACKAGE BODY"	, "DBMS_ROWID" ),
("PACKAGE BODY"	, "DBMS_RULE" ),
("PACKAGE BODY"	, "DBMS_RULEADM_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_RULE_ADM" ),
("PACKAGE BODY"	, "DBMS_RULE_COMPATIBLE_90" ),
("PACKAGE BODY"	, "DBMS_RULE_EXIMP" ),
("PACKAGE BODY"	, "DBMS_RULE_EXP_EC_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_RULE_EXP_EV_CTXS" ),
("PACKAGE BODY"	, "DBMS_RULE_EXP_RL_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_RULE_EXP_RS_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_RULE_EXP_RULES" ),
("PACKAGE BODY"	, "DBMS_RULE_EXP_RULE_SETS" ),
("PACKAGE BODY"	, "DBMS_RULE_EXP_UTL" ),
("PACKAGE BODY"	, "DBMS_RULE_EXP_UTLI" ),
("PACKAGE BODY"	, "DBMS_RULE_IMP_OBJ" ),
("PACKAGE BODY"	, "DBMS_RULE_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SCHEDULER" ),
("PACKAGE BODY"	, "DBMS_SCHED_ATTRIBUTE_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_CHAIN_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_CLASS_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_CREDENTIAL_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_EXPORT_CALLOUTS" ),
("PACKAGE BODY"	, "DBMS_SCHED_FILE_WATCHER_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_JOB_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_MAIN_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_PROGRAM_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_SCHEDULE_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_WINDOW_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCHED_WINGRP_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SCN" ),
("PACKAGE BODY"	, "DBMS_SERVER_ALERT" ),
("PACKAGE BODY"	, "DBMS_SERVER_ALERT_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SERVER_ALERT_PRVT" ),
("PACKAGE BODY"	, "DBMS_SERVER_TRACE" ),
("PACKAGE BODY"	, "DBMS_SERVICE" ),
("PACKAGE BODY"	, "DBMS_SESSION" ),
("PACKAGE BODY"	, "DBMS_SESSION_STATE" ),
("PACKAGE BODY"	, "DBMS_SHARED_POOL" ),
("PACKAGE BODY"	, "DBMS_SMB" ),
("PACKAGE BODY"	, "DBMS_SMB_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SNAPSHOT" ),
("PACKAGE BODY"	, "DBMS_SNAPSHOT_UTL" ),
("PACKAGE BODY"	, "DBMS_SNAP_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SNAP_REPAPI" ),
("PACKAGE BODY"	, "DBMS_SPACE" ),
("PACKAGE BODY"	, "DBMS_SPACE_ADMIN" ),
("PACKAGE BODY"	, "DBMS_SPM" ),
("PACKAGE BODY"	, "DBMS_SPM_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SQL" ),
("PACKAGE BODY"	, "DBMS_SQL2" ),
("PACKAGE BODY"	, "DBMS_SQLDIAG" ),
("PACKAGE BODY"	, "DBMS_SQLDIAG_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SQLHASH" ),
("PACKAGE BODY"	, "DBMS_SQLJTYPE" ),
("PACKAGE BODY"	, "DBMS_SQLPA" ),
("PACKAGE BODY"	, "DBMS_SQLPLUS_SCRIPT" ),
("PACKAGE BODY"	, "DBMS_SQLTCB_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SQLTUNE" ),
("PACKAGE BODY"	, "DBMS_SQLTUNE_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SQLTUNE_UTIL0" ),
("PACKAGE BODY"	, "DBMS_SQLTUNE_UTIL1" ),
("PACKAGE BODY"	, "DBMS_SQLTUNE_UTIL2" ),
("PACKAGE BODY"	, "DBMS_STATS" ),
("PACKAGE BODY"	, "DBMS_STATS_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_STAT_FUNCS_AUX" ),
("PACKAGE BODY"	, "DBMS_STORAGE_MAP" ),
("PACKAGE BODY"	, "DBMS_STREAMS" ),
("PACKAGE BODY"	, "DBMS_STREAMS_ADM" ),
("PACKAGE BODY"	, "DBMS_STREAMS_ADM_UTL" ),
("PACKAGE BODY"	, "DBMS_STREAMS_ADM_UTL_INVOK" ),
("PACKAGE BODY"	, "DBMS_STREAMS_ADVISOR_ADM" ),
("PACKAGE BODY"	, "DBMS_STREAMS_ADV_ADM_UTL" ),
("PACKAGE BODY"	, "DBMS_STREAMS_ADV_ADM_UTL_INVOK" ),
("PACKAGE BODY"	, "DBMS_STREAMS_AUTH" ),
("PACKAGE BODY"	, "DBMS_STREAMS_AUTO_INT" ),
("PACKAGE BODY"	, "DBMS_STREAMS_CONTROL_ADM" ),
("PACKAGE BODY"	, "DBMS_STREAMS_DATAPUMP_UTIL" ),
("PACKAGE BODY"	, "DBMS_STREAMS_HANDLER_ADM" ),
("PACKAGE BODY"	, "DBMS_STREAMS_LCR_INT" ),
("PACKAGE BODY"	, "DBMS_STREAMS_MC" ),
("PACKAGE BODY"	, "DBMS_STREAMS_MC_INV" ),
("PACKAGE BODY"	, "DBMS_STREAMS_MESSAGING" ),
("PACKAGE BODY"	, "DBMS_STREAMS_MT" ),
("PACKAGE BODY"	, "DBMS_STREAMS_PUB_RPC" ),
("PACKAGE BODY"	, "DBMS_STREAMS_RPC" ),
("PACKAGE BODY"	, "DBMS_STREAMS_RPC_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_STREAMS_SM" ),
("PACKAGE BODY"	, "DBMS_STREAMS_TABLESPACE_ADM" ),
("PACKAGE BODY"	, "DBMS_STREAMS_TBS_INT" ),
("PACKAGE BODY"	, "DBMS_STREAMS_TBS_INT_INVOK" ),
("PACKAGE BODY"	, "DBMS_SUMMARY" ),
("PACKAGE BODY"	, "DBMS_SUMREF_UTIL" ),
("PACKAGE BODY"	, "DBMS_SUMVDM" ),
("PACKAGE BODY"	, "DBMS_SUM_RWEQ_EXPORT" ),
("PACKAGE BODY"	, "DBMS_SUM_RWEQ_EXPORT_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SWRF_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SWRF_REPORT_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_SYSTEM" ),
("PACKAGE BODY"	, "DBMS_SYS_ERROR" ),
("PACKAGE BODY"	, "DBMS_SYS_SQL" ),
("PACKAGE BODY"	, "DBMS_TDB" ),
("PACKAGE BODY"	, "DBMS_TDE_TOOLKIT" ),
("PACKAGE BODY"	, "DBMS_TDE_TOOLKIT_FFI" ),
("PACKAGE BODY"	, "DBMS_TRACE" ),
("PACKAGE BODY"	, "DBMS_TRANSACTION" ),
("PACKAGE BODY"	, "DBMS_TRANSACTION_INTERNAL_SYS" ),
("PACKAGE BODY"	, "DBMS_TRANSFORM" ),
("PACKAGE BODY"	, "DBMS_TRANSFORM_EXIMP" ),
("PACKAGE BODY"	, "DBMS_TRANSFORM_EXIMP_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_TRANSFORM_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_TTS" ),
("PACKAGE BODY"	, "DBMS_TYPE_UTILITY" ),
("PACKAGE BODY"	, "DBMS_UNDO_ADV" ),
("PACKAGE BODY"	, "DBMS_UTILITY" ),
("PACKAGE BODY"	, "DBMS_WARNING" ),
("PACKAGE BODY"	, "DBMS_WARNING_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_WLM" ),
("PACKAGE BODY"	, "DBMS_WORKLOAD_CAPTURE" ),
("PACKAGE BODY"	, "DBMS_WORKLOAD_REPLAY" ),
("PACKAGE BODY"	, "DBMS_WORKLOAD_REPOSITORY" ),
("PACKAGE BODY"	, "DBMS_WRR_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_XA" ),
("PACKAGE BODY"	, "DBMS_XDS" ),
("PACKAGE BODY"	, "DBMS_XDSUTL" ),
("PACKAGE BODY"	, "DBMS_XMLGEN" ),
("PACKAGE BODY"	, "DBMS_XMLSTORE" ),
("PACKAGE BODY"	, "DBMS_XPLAN" ),
("PACKAGE BODY"	, "DBMS_XRWMV" ),
("PACKAGE BODY"	, "DBMS_XSTREAM_ADM" ),
("PACKAGE BODY"	, "DBMS_XSTREAM_ADM_INTERNAL" ),
("PACKAGE BODY"	, "DBMS_XSTREAM_ADM_UTL" ),
("PACKAGE BODY"	, "DBMS_XSTREAM_AUTH" ),
("PACKAGE BODY"	, "DBMS_XSTREAM_GG" ),
("PACKAGE BODY"	, "DBMS_XSTREAM_GG_ADM" ),
("PACKAGE BODY"	, "DBMS_XSTREAM_UTL_IVK" ),
("PACKAGE BODY"	, "DBMS_XS_DATA_SECURITY_EVENTS" ),
("PACKAGE BODY"	, "DBMS_XS_MTCACHE" ),
("PACKAGE BODY"	, "DBMS_XS_MTCACHE_FFI" ),
("PACKAGE BODY"	, "DBMS_XS_PRINCIPALS" ),
("PACKAGE BODY"	, "DBMS_XS_PRINCIPALS_INT" ),
("PACKAGE BODY"	, "DBMS_XS_PRINCIPAL_EVENTS_INT" ),
("PACKAGE BODY"	, "DBMS_XS_ROLESET_EVENTS_INT" ),
("PACKAGE BODY"	, "DBMS_XS_SECCLASS_EVENTS" ),
("PACKAGE BODY"	, "DBMS_XS_SECCLASS_INT" ),
("PACKAGE BODY"	, "DBMS_XS_SECCLASS_INT_FFI" ),
("PACKAGE BODY"	, "DBMS_XS_SESSIONS" ),
("PACKAGE BODY"	, "DBMS_XS_SESSIONS_FFI" ),
("PACKAGE BODY"	, "DBMS_ZHELP" ),
("PACKAGE BODY"	, "DBMS_ZHELP_IR" ),
("PACKAGE BODY"	, "DMP_SEC" ),
("PACKAGE BODY"	, "DMP_SYS" ),
("PACKAGE BODY"	, "DM_QGEN" ),
("PACKAGE BODY"	, "DM_XFORM" ),
("PACKAGE BODY"	, "EXF$DBMS_EXPFIL_SYSPACK" ),
("PACKAGE BODY"	, "HM_SQLTK_INTERNAL" ),
("PACKAGE BODY"	, "HTMLDB_SYSTEM" ),
("PACKAGE BODY", "KUPC$QUEUE" ),
("PACKAGE BODY", "KUPC$QUEUE_INT" ),
("PACKAGE BODY", "KUPC$QUE_INT" ),
("PACKAGE BODY", "KUPD$DATA" ),
("PACKAGE BODY", "KUPD$DATA_INT" ),
("PACKAGE BODY", "KUPF$FILE" ),
("PACKAGE BODY", "KUPF$FILE_INT" ),
("PACKAGE BODY", "KUPM$MCP" ),
("PACKAGE BODY", "KUPP$PROC" ),
("PACKAGE BODY", "KUPU$UTILITIES" ),
("PACKAGE BODY", "KUPU$UTILITIES_INT" ),
("PACKAGE BODY", "KUPV$FT" ),
("PACKAGE BODY", "KUPV$FT_INT" ),
("PACKAGE BODY", "KUPW$WORKER" ),
("PACKAGE BODY"	, "LOGMNR_DICT_CACHE" ),
("PACKAGE BODY"	, "LOGMNR_EM_SUPPORT" ),
("PACKAGE BODY"	, "LOGSTDBY_INTERNAL" ),
("PACKAGE BODY"	, "ODM_ABN_MODEL" ),
("PACKAGE BODY"	, "ODM_ASSOCIATION_RULE_MODEL" ),
("PACKAGE BODY"	, "ODM_CLUSTERING_UTIL" ),
("PACKAGE BODY"	, "ODM_MODEL_UTIL" ),
("PACKAGE BODY"	, "ODM_OC_CLUSTERING_MODEL" ),
("PACKAGE BODY"	, "ODM_UTIL" ),
("PACKAGE BODY"	, "OUTLN_EDIT_PKG" ),
("PACKAGE BODY"	, "OUTLN_PKG" ),
("PACKAGE BODY"	, "PBREAK" ),
("PACKAGE BODY"	, "PBRPH" ),
("PACKAGE BODY"	, "PBSDE" ),
("PACKAGE BODY"	, "PRIVATE_JDBC" ),
("PACKAGE BODY"	, "PRVT_ACCESS_ADVISOR" ),
("PACKAGE BODY"	, "PRVT_ADVISOR" ),
("PACKAGE BODY"	, "PRVT_AWR_DATA" ),
("PACKAGE BODY"	, "PRVT_AWR_DATA_CP" ),
("PACKAGE BODY"	, "PRVT_COMPRESSION" ),
("PACKAGE BODY"	, "PRVT_CPADDM" ),
("PACKAGE BODY"	, "PRVT_DIMENSION_SYS_UTIL" ),
("PACKAGE BODY"	, "PRVT_HDM" ),
("PACKAGE BODY"	, "PRVT_PARTREC_NOPRIV" ),
("PACKAGE BODY"	, "PRVT_REPORT_REGISTRY" ),
("PACKAGE BODY"	, "PRVT_SMGUTIL" ),
("PACKAGE BODY"	, "PRVT_SQLADV_INFRA" ),
("PACKAGE BODY"	, "PRVT_SQLPA" ),
("PACKAGE BODY"	, "PRVT_SQLPROF_INFRA" ),
("PACKAGE BODY"	, "PRVT_SQLSET_INFRA" ),
("PACKAGE BODY"	, "PRVT_SYS_TUNE_MVIEW" ),
("PACKAGE BODY"	, "PRVT_TUNE_MVIEW" ),
("PACKAGE BODY"	, "PRVT_UADV" ),
("PACKAGE BODY"	, "PRVT_WORKLOAD" ),
("PACKAGE BODY"	, "URIFACTORY" ),
("PACKAGE BODY"	, "UTL_COMPRESS" ),
("PACKAGE BODY"	, "UTL_ENCODE" ),
("PACKAGE BODY"	, "UTL_FILE" ),
("PACKAGE BODY"	, "UTL_HTTP" ),
("PACKAGE BODY"	, "UTL_I18N" ),
("PACKAGE BODY"	, "UTL_INADDR" ),
("PACKAGE BODY"	, "UTL_LMS" ),
("PACKAGE BODY"	, "UTL_NLA" ),
("PACKAGE BODY"	, "UTL_RAW" ),
("PACKAGE BODY"	, "UTL_RECOMP" ),
("PACKAGE BODY"	, "UTL_REF" ),
("PACKAGE BODY"	, "UTL_SMTP" ),
("PACKAGE BODY"	, "UTL_SYS_COMPRESS" ),
("PACKAGE BODY"	, "UTL_TCP" ),
("PACKAGE BODY"	, "UTL_URL" ),
("PACKAGE BODY"	, "UTL_XML" ),
("PROCEDURE"	, "AW_DROP_PROC" ),
("PROCEDURE"	, "AW_REN_PROC" ),
("PROCEDURE"	, "AW_TRUNC_PROC" ),
("PROCEDURE"	, "DBMS_LOGMNR_FFVTOLOGMNRT" ),
("PROCEDURE"    , "LOGMNR$ALWAYSSUPLOG_PROC" ),
("PROCEDURE"	, "LOGMNR_DDL_TRIGGER_PROC" ),
("PROCEDURE"	, "LOGMNR_GTLO3" ),
("PROCEDURE"	, "LOGMNR_KRVRDA_TEST_APPLY" ),
("PROCEDURE"	, "LOGMNR_KRVRDLUID3" ),
("PROCEDURE"	, "LOGMNR_KRVRDREPDICT3" ),
("PROCEDURE"	, "SCHEDULER$_JOB_EVENT_HANDLER" ),
("PROCEDURE"	, "SETMODFLG" ) ]


	for ora_type, ora_name in ora_objects:
		if ( ora_type == "PROCEDURE" ):
			ext = ".prc"
		elif ( ora_type == "FUNCTION" ):
			ext = ".fnc"
		elif ( ora_type == "PACKAGE BODY" ):
			ext = ".pkb"

		print ("spool " + ora_name + ext)			
		print ("pagesize 0")
		print ("select * from test_unwrapped_full where object_name = '" + ora_name + "' and object_type = '" + ora_type + "' order by line;" )
		print ("spool off")

if __name__ == "__main__":
    main(sys.argv)
