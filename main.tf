terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

#provider "libvirt" {
#  alias = "server2"
#  uri   = "qemu+ssh://root@192.168.100.10/system"
#}

resource "libvirt_volume" "os_volume" {
  count = length(var.hostname) # нужно что бы знал количество элементов в массиве
  name = "${var.hostname[count.index]}.qcow2"
  pool = "default"
  #source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
  source = "/var/lib/libvirt/images/terra-centos7.qcow2"
  format = "qcow2"
}

#resource "libvirt_volume" "k3m1_data_volume" {
#  name = "k3m1_data_volume"
#  // 25 * 1024 * 1024 * 1024
#  size  = 26843545600 
#}

# Define KVM domain to create
resource "libvirt_domain" "vm_domain" {
  count = length(var.hostname) # нужно что бы знал количество элементов в массиве
  name   = "${var.hostname[count.index]}"
  memory = "${var.ram[count.index]}"
  vcpu   = "${var.vcpu[count.index]}"
  qemu_agent  = true

  network_interface {
    network_name = "default"
    hostname  = "${var.hostname[count.index]}"
    addresses = ["${var.ip[count.index]}"]
	mac = "${var.mac[count.index]}"
  }

  disk {
    #count = length(var.hostname)
    volume_id = libvirt_volume.os_volume[count.index].id
  }

#   disk {
#     volume_id = "${libvirt_volume.k3m1_data_volume.id}"
#   }
#
  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "vnc"
    listen_type = "address"
    autoport = true
  }
}
