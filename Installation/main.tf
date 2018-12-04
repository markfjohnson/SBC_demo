
module "dcos" {
  source = "dcos-terraform/dcos/aws"

  cluster_name        = "mjohnsonk8s_sbc2"
  num_masters        = "1"
  num_private_agents = "8"
  num_public_agents  = "1"


  dcos_instance_os    = "centos_7.4"
  dcos_version = "1.12.0"


  bootstrap_instance_type = "t2.medium"
  public_agents_instance_type = "m4.2xlarge"
  private_agents_instance_type = "m4.2xlarge"
  masters_instance_type = "m4.2xlarge"
  availability_zones = ["us-west-2a"]
  dcos_ip_detect_public_filename = "genconf/ip-detect-public"
  masters_associate_public_ip_address=true

  ssh_public_key_file = "~/.ssh/id_rsa.pub"
  admin_ips           = ["${data.http.whatismyip.body}/32"]


  dcos_variant              = "ee"
  dcos_license_key_contents = "${file("./license.txt")}"
  dcos_resolvers      = "\n   - 169.254.169.253"

  # Enable only if using the DC/OS open source version
  #  dcos_variant = "open"
  dcos_install_mode = "${var.dcos_install_mode}"
}
variable "dcos_install_mode" {
  description = "specifies which type of command to execute. Options: install or upgrade"
  default     = "install"
}

data "http" "whatismyip" {
  url = "http://whatismyip.akamai.com/"
}

output "masters-ips" {
  value = "${module.dcos.masters-ips}"
}

output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}

output "public-agents-loadbalancer" {
  value = "${module.dcos.public-agents-loadbalancer}"
}
provider "aws" {
  version = "1.43.2"
}




