terraform {
    required_providers {
        snowflake = {
            source = "snowflakedb/snowflake"
        }
    }
}

locals {
    organization_name = "knoqquv"
    account_name = "gt24677"
    private_key_path = "~/.ssh/snowflake_tf_snow_key.p8"
}

provider "snowflake" {
    organization_name = local.organization_name
    account_name = local.account_name
    user = "terraform_svc"
    role = "sysadmin"
    authenticator = "snowflake_jwt"
    private_key = file(local.private_key_path)
}

resource "snowflake_database" "tf_db" {
    name = "tf_demo_db"
    is_transient = false
}

resource "snowflake_warehouse" "tf_vwh" {
    name = "tf_demo_vwh"
    warehouse_type = "standard"
    warehouse_size = "xsmall"
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true
    max_cluster_count = 1
    min_cluster_count = 1
    enable_query_acceleration = false
}

resource "snowflake_schema" "tf_db_tf_schema" {
    name = "tf_demo_schema"
    database = snowflake_database.tf_db.name
    with_managed_access = false
    comment = "demo schema created by terraform during sfguide"
}
