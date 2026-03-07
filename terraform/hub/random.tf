resource "random_string" "sql_username" {
  length  = 10
  special = false
  upper   = false
}

resource "random_password" "sql_password" {
  length  = 20
  special = true
}
