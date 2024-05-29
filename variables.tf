variable "win_password" {
  type        = string
  description = "password for windows"
   default = "ChangeAA5!_bib"
}
variable "win_user" {
  type        = string
  description = "user for windows"
   default = "user101"
}
variable "dns_name" {
  type        = string
  description = "dns"
   default = "comp301"
}
variable "sas_token" {
  type    = string
  description = "SAS Token for Azure Storage Account"
}