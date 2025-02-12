output "lxc_highest_id_value" {
  description = "highest lxc id existing on proxmox node"
  value = tonumber(trimspace(data.local_file.highest_lxc_id.content))
}