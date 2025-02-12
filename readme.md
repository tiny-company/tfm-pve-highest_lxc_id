# tfm-pve-highest_lxc_id

## Description

A simple terraform module that get the highest LXC container ID in a proxmox node.

## Usage 

- Import the module by referencing it in your main terraform file (`main.tf`) using :
```hcl
module "pve_highest_lxc_id" {
  source     = "git::https://github.com/tiny-company/tfm-pve-highest_lxc_id.git"
  proxmox_api_host = var.proxmox_api_host
  proxmox_api_nodename = var.terraform_proxmox_node_name
  proxmox_api_username = var.proxmox_api_username
  proxmox_api_tokenname = var.proxmox_api_tokenname
  proxmox_api_tokenvalue = var.proxmox_api_tokenvalue
}
```

- don't forget to define the vars below in your variables.tf :
```hcl
variable "python_version" {
  type      = string
  default   = "3.11.2"
}

variable "proxmox_api_host" {
  type      = string
  sensitive = true
}

variable "proxmox_api_nodename" {
  type      = string
  sensitive = true
}

variable "proxmox_api_username" {
  type      = string
  sensitive = true
}

variable "proxmox_api_tokenname" {
  type      = string
  sensitive = true
}

variable "proxmox_api_tokenvalue" {
  type      = string
  sensitive = true
}
```