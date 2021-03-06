//iso vars
variable "iso_checksum" {
  type = string
  default = "sha256:28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
}
variable "iso_url" {
  type = string
  default = "http://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso"
}

//vm specs
variable "name" {
  type = string
  default = "UbuntuServer-20.04"
}
variable "cpus" {
  type = number
  default = 1
}
variable "memory" {
  type = number
  default = 1024
}
variable "disk_size" {
  type = number
  default = 10000
}

//other vars
variable "http_directory" {
  type = string
  default = "./http"
}
variable "cd_files" {
  type = list(string)
  default = ["./http/*"]
}
variable "ssh_password" {
  type = string
  default = "ubuntu"
}
variable "ssh_wait" {
  type = string
  default = "3m"
}
variable "keep_registered" {
  type = bool
  default = false
}
variable "output_directory" {
  type = string
  default = "./"
}

source "virtualbox-iso" "autogenerated_1" {
  //virtualbox config
  guest_os_type = "Ubuntu_64"
  keep_registered = "${var.keep_registered}"
  skip_export = "${var.keep_registered}"
  output_directory = "${var.output_directory}/${var.name}"

  //vm configuration
  vm_name = "${var.name}"
  #firmware = "efi"
  cpus = "${var.cpus}"
  memory = "${var.memory}"
  gfx_vram_size = 20
  gfx_controller = "vmsvga"
  iso_interface = "sata"
  hard_drive_interface = "scsi"
  disk_size = "${var.disk_size}"
  cd_files = "${var.cd_files}"
  cd_label = "cidata"
  shutdown_command = "echo '${var.ssh_password}' | sudo -E -S shutdown -P now"

  //ssh configuration
  #ssh password is set in the user-data yaml file which is used for the OS install
  #a different password can be generated and replaced in the yaml file, however
  #it will be easier to just change the password for the ubuntu user once the VM
  #is officially provisioned
  ssh_password = "${var.ssh_password}"
  ssh_timeout = "30m"
  ssh_username = "ubuntu"

  http_directory = "${var.http_directory}"

  //iso configuration
  iso_checksum = "${var.iso_checksum}"
  iso_url = "${var.iso_url}"

  //boot configuration
  boot_command = [
    "<esc><enter><f6><esc>",
    "<wait3s>",
    "<left><left><left><left>",
    "autoinstall ds=nocloud ",
    "<enter>",

    #the ssh_wait var was added to account for an issue i ran into where
    #ssh would be available during the OS installation and packer would
    #spam the connection and fail due to authentication issues
    #there weren't any other places i could add a wait time before
    #establishing the ssh connection so i placed it
    #into the boot commands for now :/
    "<wait${var.ssh_wait}>"
  ]
  boot_wait           = "7s"
}

build {
  sources = ["source.virtualbox-iso.autogenerated_1"]

  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y upgrade"
    ]
  }

  provisioner "shell" {
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script = "${path.root}/scripts/cleanup.sh"
  }
}