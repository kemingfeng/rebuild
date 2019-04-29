-- !!!NOTE!!!
-- IF YOU USING MYSQL 5.7 OR ABOVE, YOU WILL REMOVED THESE SQL_MODES IN my.cnf/my.ini FIRST.
-- ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE

-- #1 database/user
-- UNCOMMENT IF YOU NEEDED DB AND USER
/* 
CREATE DATABASE rebuild10 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
CREATE USER 'rebuild'@'127.0.0.1' IDENTIFIED BY 'rebuild';
GRANT ALL PRIVILEGES ON rebuild10.* TO 'rebuild'@'127.0.0.1';
FLUSH PRIVILEGES;
USE rebuild10;
*/

-- #2 schemas
-- Generated by SchemaGen.java
-- ************ Entity [User] DDL ************
create table if not exists `user` (
  `AVATAR_URL`         varchar(300) comment '头像',
  `ROLE_ID`            char(20) comment '角色',
  `JOB_TITLE`          varchar(100) comment '职务',
  `DEPT_ID`            char(20) comment '部门',
  `FULL_NAME`          varchar(100) comment '姓名',
  `USER_ID`            char(20) not null,
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `PASSWORD`           varchar(100) not null comment '登录密码',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `LOGIN_NAME`         varchar(100) not null comment '登录名',
  `QUICK_CODE`         varchar(70),
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `IS_DISABLED`        char(1) default 'F' comment '是否停用',
  `EMAIL`              varchar(100) comment '邮箱',
  primary key  (`USER_ID`),
  unique index `UIX1_user` (`LOGIN_NAME`),
  unique index `UIX2_user` (`EMAIL`)
)Engine=InnoDB;

-- ************ Entity [Department] DDL ************
create table if not exists `department` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `DEPT_ID`            char(20) not null,
  `NAME`               varchar(100) not null comment '部门名称',
  `QUICK_CODE`         varchar(70),
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `IS_DISABLED`        char(1) default 'F' comment '是否停用',
  `PARENT_DEPT`        char(20) comment '父级部门',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`DEPT_ID`)
)Engine=InnoDB;

-- ************ Entity [Role] DDL ************
create table if not exists `role` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `ROLE_ID`            char(20) not null,
  `NAME`               varchar(100) not null comment '角色名称',
  `QUICK_CODE`         varchar(70),
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `IS_DISABLED`        char(1) default 'F' comment '是否停用',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`ROLE_ID`)
)Engine=InnoDB;

-- ************ Entity [RolePrivileges] DDL ************
create table if not exists `role_privileges` (
  `PRIVILEGES_ID`      char(20) not null,
  `ROLE_ID`            char(20) not null,
  `DEFINITION`         varchar(100) comment '权限定义',
  `ZERO_KEY`           varchar(50) comment '其他权限KEY',
  `ENTITY`             int(11) not null default '0' comment '哪个实体',
  primary key  (`PRIVILEGES_ID`),
  unique index `UIX1_role_privileges` (`ROLE_ID`, `ENTITY`, `ZERO_KEY`)
)Engine=InnoDB;

-- ************ Entity [RoleMember] DDL ************
create table if not exists `role_member` (
  `ROLE_ID`            char(20),
  `USER_ID`            char(20),
  `MEMBER_ID`          char(20) not null,
  primary key  (`MEMBER_ID`)
)Engine=InnoDB;

-- ************ Entity [MetaEntity] DDL ************
create table if not exists `meta_entity` (
  `ENTITY_LABEL`       varchar(100) not null comment 'for description',
  `COMMENTS`           varchar(200),
  `ICON`               varchar(60),
  `NAME_FIELD`         varchar(100),
  `ENTITY_ID`          char(20) not null,
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `MASTER_ENTITY`      varchar(100) comment '明细实体的所属主实体',
  `TYPE_CODE`          smallint(6) not null,
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `PHYSICAL_NAME`      varchar(100) not null,
  `CREATED_BY`         char(20) not null comment '创建人',
  `ENTITY_NAME`        varchar(100) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  primary key  (`ENTITY_ID`),
  unique index `UIX1_meta_entity` (`TYPE_CODE`),
  unique index `UIX2_meta_entity` (`ENTITY_NAME`),
  unique index `UIX3_meta_entity` (`PHYSICAL_NAME`)
)Engine=InnoDB;

-- ************ Entity [MetaField] DDL ************
create table if not exists `meta_field` (
  `FIELD_NAME`         varchar(100) not null,
  `COMMENTS`           varchar(300),
  `NULLABLE`           char(1) default 'T',
  `DEFAULT_VALUE`      varchar(300),
  `CASCADE`            varchar(20),
  `EXT_CONFIG`         varchar(700) comment '更多扩展配置, JSON格式KV',
  `BELONG_ENTITY`      varchar(100) not null,
  `CREATABLE`          char(1) default 'T',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `DISPLAY_TYPE`       varchar(100) comment '显示类型. 详见 DisplayType',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `PHYSICAL_NAME`      varchar(100) not null,
  `CREATED_BY`         char(20) not null comment '创建人',
  `FIELD_LABEL`        varchar(100) not null comment 'for description',
  `REF_ENTITY`         varchar(100),
  `UPDATABLE`          char(1) default 'T',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `MAX_LENGTH`         smallint(6) default '300',
  `FIELD_ID`           char(20) not null,
  primary key  (`FIELD_ID`),
  unique index `UIX1_meta_field` (`BELONG_ENTITY`, `FIELD_NAME`),
  unique index `UIX2_meta_field` (`BELONG_ENTITY`, `PHYSICAL_NAME`)
)Engine=InnoDB;

-- ************ Entity [PickList] DDL ************
create table if not exists `pick_list` (
  `ITEM_ID`            char(20) not null,
  `IS_DEFAULT`         char(1) default 'F',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `BELONG_FIELD`       varchar(100) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null,
  `TEXT`               varchar(100) not null,
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `SEQ`                int(11) default '0' comment '排序, 小到大',
  `IS_HIDE`            char(1) default 'F',
  primary key  (`ITEM_ID`)
)Engine=InnoDB;

-- ************ Entity [LayoutConfig] DDL ************
create table if not exists `layout_config` (
  `APPLY_TYPE`         varchar(20) not null comment 'FORM,DATALIST,NAVI',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `CONFIG_ID`          char(20) not null,
  `SHARE_TO`           varchar(420) default 'SELF' comment '共享给哪些人, 可选值: ALL/SELF/$MemberID(U/D/R)',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null,
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`CONFIG_ID`)
)Engine=InnoDB;

-- ************ Entity [FilterConfig] DDL ************
create table if not exists `filter_config` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `CONFIG_ID`          char(20) not null,
  `FILTER_NAME`        varchar(100) not null,
  `SHARE_TO`           varchar(420) default 'SELF' comment '共享给哪些人, 可选值: ALL/SELF/$MemberID(U/D/R)',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null,
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`CONFIG_ID`)
)Engine=InnoDB;

-- ************ Entity [ViewAddonsConfig] DDL ************
create table if not exists `view_addons_config` (
  `APPLY_TYPE`         varchar(20) not null comment 'TAB,ADD',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `CONFIG_ID`          char(20) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null,
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`CONFIG_ID`),
  unique index `UIX1_view_addons_config` (`BELONG_ENTITY`, `APPLY_TYPE`)
)Engine=InnoDB;

-- ************ Entity [DashboardConfig] DDL ************
create table if not exists `dashboard_config` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `CONFIG_ID`          char(20) not null,
  `SHARE_TO`           varchar(420) default 'SELF' comment '共享给哪些人, 可选值: ALL/SELF/$MemberID(U/D/R)',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `TITLE`              varchar(100) not null,
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`CONFIG_ID`)
)Engine=InnoDB;

-- ************ Entity [ChartConfig] DDL ************
create table if not exists `chart_config` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CHART_ID`           char(20) not null,
  `CREATED_BY`         char(20) not null comment '创建人',
  `CHART_TYPE`         varchar(100) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null,
  `TITLE`              varchar(100) not null,
  `CONFIG`             text(21845) not null comment 'JSON格式配置',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`CHART_ID`)
)Engine=InnoDB;

-- ************ Entity [Classification] DDL ************
create table if not exists `classification` (
  `OPEN_LEVEL`         smallint(6) default '0',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `DATA_ID`            char(20) not null,
  `CREATED_BY`         char(20) not null comment '创建人',
  `NAME`               varchar(100) not null,
  `DESCRIPTION`        varchar(600),
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `IS_DISABLED`        char(1) default 'F',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`DATA_ID`)
)Engine=InnoDB;

-- ************ Entity [ClassificationData] DDL ************
create table if not exists `classification_data` (
  `ITEM_ID`            char(20) not null,
  `PARENT`             char(20),
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CODE`               varchar(50),
  `DATA_ID`            char(20) not null,
  `CREATED_BY`         char(20) not null comment '创建人',
  `NAME`               varchar(100) not null,
  `FULL_NAME`          varchar(300) not null comment '包括父级名称, 用 . 分割',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`ITEM_ID`)
)Engine=InnoDB;
alter table `classification_data`
  add index `IX1_classification_data` (`DATA_ID`, `PARENT`, `NAME`),
  add index `IX2_classification_data` (`DATA_ID`, `FULL_NAME`);

-- ************ Entity [ShareAccess] DDL ************
create table if not exists `share_access` (
  `ACCESS_ID`          char(20) not null,
  `RECORD_ID`          char(20) not null comment '记录ID',
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `RIGHTS`             int(11) not null default '0' comment '共享权限 (R=2,U=4,D=8,0=Auto)',
  `SHARE_TO`           char(20) not null comment '共享给谁 (U/D/R)',
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `BELONG_ENTITY`      varchar(100) not null comment '哪个实体',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`ACCESS_ID`)
)Engine=InnoDB;
alter table `share_access`
  add index `IX1_share_access` (`BELONG_ENTITY`, `RECORD_ID`, `SHARE_TO`);

-- ************ Entity [SystemConfig] DDL ************
create table if not exists `system_config` (
  `ITEM`               varchar(100) not null,
  `CONFIG_ID`          char(20) not null,
  `VALUE`              varchar(600) not null,
  primary key  (`CONFIG_ID`),
  unique index `UIX1_system_config` (`ITEM`)
)Engine=InnoDB;

-- ************ Entity [Notification] DDL ************
create table if not exists `notification` (
  `TO_USER`            char(20) not null,
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `FROM_USER`          char(20) not null,
  `UNREAD`             char(1) default 'T',
  `CREATED_BY`         char(20) not null comment '创建人',
  `MESSAGE_ID`         char(20) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `MESSAGE`            varchar(1000),
  `RELATED_RECORD`     char(20) comment '相关业务记录',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  primary key  (`MESSAGE_ID`)
)Engine=InnoDB;
alter table `notification`
  add index `IX1_notification` (`TO_USER`, `UNREAD`, `CREATED_ON`);

-- ************ Entity [Attachment] DDL ************
create table if not exists `attachment` (
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `FILE_SIZE`          int(11) default '0' comment 'in KB',
  `CREATED_BY`         char(20) not null comment '创建人',
  `FILE_PATH`          varchar(200) not null,
  `BELONG_FIELD`       varchar(100),
  `IN_FOLDER`          char(20),
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `ATTACHMENT_ID`      char(20) not null,
  `BELONG_ENTITY`      smallint(6) default '0',
  `RELATED_RECORD`     char(20) comment '相关业务记录',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `FILE_TYPE`          varchar(20),
  primary key  (`ATTACHMENT_ID`)
)Engine=InnoDB;
alter table `attachment`
  add index `IX1_attachment` (`BELONG_ENTITY`, `BELONG_FIELD`, `FILE_PATH`),
  add index `IX2_attachment` (`RELATED_RECORD`),
  add index `IX3_attachment` (`IN_FOLDER`, `CREATED_ON`);

-- ************ Entity [AttachmentFolder] DDL ************
create table if not exists `attachment_folder` (
  `PARENT`             char(20),
  `MODIFIED_ON`        timestamp not null default '0000-00-00 00:00:00' comment '修改时间',
  `CREATED_BY`         char(20) not null comment '创建人',
  `NAME`               varchar(100) not null,
  `MODIFIED_BY`        char(20) not null comment '修改人',
  `CREATED_ON`         timestamp not null default '0000-00-00 00:00:00' comment '创建时间',
  `FOLDER_ID`          char(20) not null,
  primary key  (`FOLDER_ID`)
)Engine=InnoDB;

-- ************ Entity [LoginLog] DDL ************
create table if not exists `login_log` (
  `LOGOUT_TIME`        timestamp null default '0000-00-00 00:00:00' comment '退出时间',
  `LOGIN_TIME`         timestamp not null default '0000-00-00 00:00:00' comment '登陆时间',
  `LOG_ID`             char(20) not null,
  `USER_AGENT`         varchar(100) comment '客户端',
  `USER`               char(20) not null comment '登陆用户',
  `IP_ADDR`            varchar(100) comment 'IP地址',
  primary key  (`LOG_ID`)
)Engine=InnoDB;
alter table `login_log`
  add index `IX1_login_log` (`USER`, `LOGIN_TIME`);


-- #3 datas

-- User
INSERT INTO `user` (`USER_ID`, `LOGIN_NAME`, `PASSWORD`, `FULL_NAME`, `DEPT_ID`, `ROLE_ID`, `IS_DISABLED`, `CREATED_ON`, `CREATED_BY`, `MODIFIED_ON`, `MODIFIED_BY`, `QUICK_CODE`)
  VALUES
  ('001-0000000000000000', 'system', 'system', '系统用户', '002-0000000000000001', '003-0000000000000001', 'T', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'XTYH'),
  ('001-0000000000000001', 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', '超级管理员', '002-0000000000000001', '003-0000000000000001', 'F', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'CJGLY'),
  ('001-9000000000000001', 'rebuild', 'cf44886e54f424ce136dc38e4d9ef5b4b556d06060705262d6fcce02b4322539', 'RB示例用户', '002-9000000000000001', '003-9000000000000001', 'F', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'RBSLYH');
-- Department
INSERT INTO `department` (`DEPT_ID`, `NAME`, `CREATED_ON`, `CREATED_BY`, `MODIFIED_ON`, `MODIFIED_BY`, `QUICK_CODE`)
  VALUES
  ('002-0000000000000001', '总部', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'ZB'),
  ('002-9000000000000001', 'RB示例部门', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'RBSLBM');
-- Role
INSERT INTO `role` (`ROLE_ID`, `NAME`, `CREATED_ON`, `CREATED_BY`, `MODIFIED_ON`, `MODIFIED_BY`, `QUICK_CODE`)
  VALUES
  ('003-0000000000000001', '管理员', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'GLY'),
  ('003-9000000000000001', 'RB示例角色', CURRENT_TIMESTAMP, '001-0000000000000000', CURRENT_TIMESTAMP, '001-0000000000000000', 'RBSLJS');

-- Layouts
INSERT INTO `layout_config` (`CONFIG_ID`, `BELONG_ENTITY`, `CONFIG`, `APPLY_TYPE`, `SHARE_TO`, `CREATED_ON`, `CREATED_BY`, `MODIFIED_ON`, `MODIFIED_BY`)
  VALUES 
  (CONCAT('013-',SUBSTRING(MD5(RAND()),1,16)), 'Department', '[{"field":"name","isFull":false},{"field":"parentDept","isFull":false},{"field":"isDisabled","isFull":false}]', 'FORM', 'ALL', CURRENT_TIMESTAMP, '001-0000000000000001', CURRENT_TIMESTAMP, '001-0000000000000001'),
  (CONCAT('013-',SUBSTRING(MD5(RAND()),1,16)), 'User', '[{"field":"fullName","isFull":false},{"field":"email","isFull":false},{"field":"loginName","isFull":false},{"field":"password","isFull":false},{"field":"$DIVIDER$","isFull":true,"label":"分栏"},{"field":"deptId","isFull":false},{"field":"roleId","isFull":false},{"field":"isDisabled","isFull":false}]', 'FORM', 'ALL', CURRENT_TIMESTAMP, '001-0000000000000001', CURRENT_TIMESTAMP, '001-0000000000000001'),
  (CONCAT('013-',SUBSTRING(MD5(RAND()),1,16)), 'Role', '[{"field":"name","isFull":false},{"field":"isDisabled","isFull":false}]', 'FORM', 'ALL', CURRENT_TIMESTAMP, '001-0000000000000001', CURRENT_TIMESTAMP, '001-0000000000000001'),
  (CONCAT('013-',SUBSTRING(MD5(RAND()),1,16)), 'LoginLog', '[{"field":"user"},{"field":"loginTime"},{"field":"userAgent"},{"field":"ipAddr"},{"field":"logoutTime"}]', 'DATALIST', 'ALL', CURRENT_TIMESTAMP, '001-0000000000000001', CURRENT_TIMESTAMP, '001-0000000000000001');

-- Classifications (No data)
INSERT INTO `classification` (`DATA_ID`, `NAME`, `DESCRIPTION`, `OPEN_LEVEL`, `IS_DISABLED`, `CREATED_ON`, `CREATED_BY`, `MODIFIED_ON`, `MODIFIED_BY`) 
  VALUES
  ('018-0000000000000001', '地区', NULL, 2, 'F', CURRENT_TIMESTAMP, '001-0000000000000001', CURRENT_TIMESTAMP, '001-0000000000000001'),
  ('018-0000000000000002', '行业', NULL, 1, 'F', CURRENT_TIMESTAMP, '001-0000000000000001', CURRENT_TIMESTAMP, '001-0000000000000001');

-- DB Version
INSERT INTO `system_config` (`CONFIG_ID`, `ITEM`, `VALUE`) 
  VALUES (CONCAT('021-',SUBSTRING(MD5(RAND()),1,16)), 'DBVer', 3);
