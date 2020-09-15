variable "location" {
  description = "Region to install vm-series and dependencies."
}

variable "name_prefix" {
  description = "Prefix to add to all the object names here"
}
variable "management_ips" {
  type = map(any)
}
variable "olb-ip" {
  description = "Private IP for outgoing lb"
}