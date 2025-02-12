
# ------------------------------------------------------------------
# - Filename: main.tf
# - Author : draed
# - Dependency : none
# - Description : terraform module that get the highest lxc container id on a proxmox instance
# - Creation date : 2025-02-10
# - terraform version : OpenTofu v1.9.0
# ------------------------------------------------------------------

resource "null_resource" "import_script_dependencies" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "virtualenv -p ${var. python_version} ${path.module}/venv && . ${path.module}/venv/bin/activate && pip install -r ${path.module}/scripts/requirements.txt"
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "null_resource" "get_highest_lxc_id" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "${path.module}/venv/bin/python ${path.module}/scripts/get_highest_lxc_id.py > ${path.module}/highest_lxc_id.txt"
    environment = {
      PROXMOX_API_HOST = "${var.proxmox_api_host}"
      PROXMOX_API_NODENAME = "${var.proxmox_api_nodename}"
      PROXMOX_API_USERNAME = "${var.proxmox_api_username}"
      PROXMOX_API_TOKENNAME = "${var.proxmox_api_tokenname}"
      PROXMOX_API_TOKENVALUE = "${var.proxmox_api_tokenvalue}"
    }
  }
  lifecycle {
    ignore_changes = all
  }
  depends_on = [null_resource.import_script_dependencies]
}

data "local_file" "highest_lxc_id" {
  filename = "${path.module}/highest_lxc_id.txt"
  depends_on = [null_resource.get_highest_lxc_id]
}

## delete venv folder (keep clean)
resource "null_resource" "delete_file" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "rm -rf ${path.module}/venv"
  }
  depends_on = [null_resource.import_script_dependencies,null_resource.get_highest_lxc_id]
}

