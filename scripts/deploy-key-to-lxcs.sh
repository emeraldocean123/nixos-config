#!/bin/bash
# Deploy unified SSH key to all LXC containers

PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBdb5WWyH4atlYewmthJGTVAkJysN3UHp5ZhUDtfbp2 joseph@unified-key"

# LXC IPs and names
declare -A LXCS=(
    ["192.168.1.50"]="pve-wireguard-lxc"
    ["192.168.1.51"]="pve-tailscale-lxc"
    ["192.168.1.52"]="pve-omada-lxc"
    ["192.168.1.53"]="pve-netbox-lxc"
    ["192.168.1.54"]="pve-iventoy-lxc"
    ["192.168.1.55"]="pve-docker-lxc"
    ["192.168.1.56"]="pve-syncthing-lxc"
)

echo "Deploying unified SSH key to LXC containers..."
echo "============================================="

for IP in "${!LXCS[@]}"; do
    NAME="${LXCS[$IP]}"
    echo -n "Deploying to $NAME ($IP)... "
    
    # Try to deploy the key
    echo "$PUBLIC_KEY" | ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 root@$IP \
        "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && echo 'Success'" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✓"
    else
        echo "Failed (may need password)"
    fi
done

echo ""
echo "Deployment complete!"