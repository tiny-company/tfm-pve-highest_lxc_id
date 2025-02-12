import requests
import os

from dotenv import load_dotenv
from proxmoxer import ProxmoxAPI


def instanciate_proxmox(PROXMOX_API_HOST: str, PROXMOX_API_USERNAME: str, PROXMOX_API_TOKENNAME: str, PROXMOX_API_TOKENVALUE: str) -> ProxmoxAPI:
    """
    instanciate proxmox using given parameters loaded from env var

    Parameters:
    - PROXMOX_API_HOST : proxmox host address
    - PROXMOX_API_USERNAME : proxmox username used to connect to pve
    - PROXMOX_API_TOKENNAME : proxmox token name used to connect to pve
    - PROXMOX_API_TOKENVALUE : proxmox token value used to connect to pve

    Returns:
    proxmox: instance of ProxmoxAPI 

    Raises:
    ValueError: If ProxmoxAPI instanciation failed
    """
    try:
      proxmox = ProxmoxAPI(
        PROXMOX_API_HOST, user=PROXMOX_API_USERNAME, token_name=PROXMOX_API_TOKENNAME, token_value=PROXMOX_API_TOKENVALUE, verify_ssl=False
      )
      return proxmox
    except ValueError as e:
      print(f"Error: {e}")
    
def get_highest_lxc_id(proxmox) -> int:
    """
    get the highest lxc id on a proxmox for all nodes

    Parameters:
    - proxmox : instance of ProxmoxAPI

    Returns:
    highest_id: highest lxc id as integer 

    Raises:
    ValueError: If request to proxmox failed
    """
    try:
      containers = proxmox.nodes("proxmox").lxc.get()
      highest_id = int(max(container['vmid'] for container in containers))
      return highest_id
    except ValueError as e:
      print(f"Error: {e}")

if __name__ == "__main__":

  ## load parameters from env var
  load_dotenv()
  PROXMOX_API_HOST = os.getenv('PROXMOX_API_HOST')
  PROXMOX_API_USERNAME = os.getenv('PROXMOX_API_USERNAME')
  PROXMOX_API_TOKENNAME = os.getenv('PROXMOX_API_TOKENNAME')
  PROXMOX_API_TOKENVALUE = os.getenv('PROXMOX_API_TOKENVALUE')

  ## instanciate proxmox conn
  proxmox = instanciate_proxmox(PROXMOX_API_HOST, PROXMOX_API_USERNAME, PROXMOX_API_TOKENNAME, PROXMOX_API_TOKENVALUE)
  
  ## get the highest lxc container id
  highest_id = get_highest_lxc_id(proxmox)
  print(highest_id)
