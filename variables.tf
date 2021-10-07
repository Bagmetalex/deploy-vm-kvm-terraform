variable "count_vms" {
  description = "number of virtual-machine of same type that will be created"
  default     = 2
}
variable "hostname" {
  type = list
  default = ["example_1", "example_2"]
}
variable "ip" {
  type = list
  default = ["192.168.122.240", "192.168.122.241"]
}
variable "mac" {
  type = list
  default = ["52:54:00:12:22:40", "52:54:00:12:22:41"]
}
variable "vcpu" {
  type = list
  default = ["1", "1"]
}
variable "ram" {
  type = list
  default = ["1024", "1024"]
}