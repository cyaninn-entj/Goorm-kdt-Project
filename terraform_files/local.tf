locals {
  default_password = var.jenkins_admin_password == "" ? "" : bcrypt(var.jenkins_admin_password)
}