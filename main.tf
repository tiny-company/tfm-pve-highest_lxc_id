
# ------------------------------------------------------------------
# - Filename: main.tf
# - Author : draed
# - Dependency : none
# - Description : terraform module that get the highest lxc container id on a proxmox instance
# - Creation date : 2025-02-10
# - terraform version : OpenTofu v1.9.0
# ------------------------------------------------------------------

resource "null_resource" "import_script_dependencies" {
  provisioner "local-exec" {
    command = "virtualenv -p ${var. python_version} ${path.module}/venv && . ${path.module}/venv/bin/activate && pip install -r ${path.module}/scripts/requirements.txt"
  }
}

resource "null_resource" "get_highest_lxc_id" {
  provisioner "local-exec" {
    command = "${path.module}/venv/bin/python ${path.module}/scripts/get_highest_lxc_id.py > ${path.module}/highest_lxc_id.txt"
    environment = {
      PROXMOX_API_HOST = "${var.proxmox_api_host}"
      PROXMOX_API_USERNAME = "${var.proxmox_api_username}"
      PROXMOX_API_TOKENNAME = "${var.proxmox_api_tokenname}"
      PROXMOX_API_TOKENVALUE = "${var.proxmox_api_tokenvalue}"
    }
  }
  depends_on = [null_resource.import_script_dependencies]
}

locals {
  file_exists = fileexists("${path.module}/highest_lxc_id.txt")
}

data "local_file" "highest_lxc_id" {
  count  = local.file_exists ? 1 : 0
  filename = "${path.module}/highest_lxc_id.txt"
  depends_on = [null_resource.get_highest_lxc_id]
}

## delete venv folder (keep env clean)
resource "null_resource" "delete_file" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "rm -rf ${path.module}/venv"
  }
  depends_on = [null_resource.import_script_dependencies, null_resource.get_highest_lxc_id]
}

