import requests
import os

from dotenv import load_dotenv
from proxmoxer import ProxmoxAPI


def instanciate_proxmox():

    load_dotenv()
    PROXMOX_API_HOST = os.getenv('PROXMOX_API_HOST')
    PROXMOX_API_NODENAME = os.getenv('PROXMOX_API_NODENAME')
    PROXMOX_API_USERNAME = os.getenv('PROXMOX_API_USERNAME')
    PROXMOX_API_TOKENNAME = os.getenv('PROXMOX_API_TOKENNAME')
    PROXMOX_API_TOKENVALUE = os.getenv('PROXMOX_API_TOKENVALUE')
    proxmox = ProxmoxAPI(
        PROXMOX_API_HOST, user=PROXMOX_API_USERNAME, token_name=PROXMOX_API_TOKENNAME, token_value=PROXMOX_API_TOKENVALUE, verify_ssl=False
    )
    return proxmox

def get_highest_lxc_id(proxmox):

    containers = proxmox.nodes("proxmox").lxc.get()
    highest_id = max(container['vmid'] for container in containers)
    return highest_id

if __name__ == "__main__":
    proxmox = instanciate_proxmox()
    highest_id = get_highest_lxc_id(proxmox)
    print(highest_id)
