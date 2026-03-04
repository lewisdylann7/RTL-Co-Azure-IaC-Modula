variable "location" {
  default = "East Us"
}
variable "prefix" {
  default = "rtlc"
}

variable "admin_password" {
  type = string
  sensitive = true
  description = "Password for the VM"
}