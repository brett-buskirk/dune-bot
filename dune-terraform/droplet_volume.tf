resource "digitalocean_volume" "dune_volume" {
  region                  = "nyc1"
  name                    = "dune-volume"
  size                    = 10
  initial_filesystem_type = "ext4"
  description             = "dune volume"
}

resource "digitalocean_droplet" "dune_server" {
  image  = "debian-11-x64"
  name   = "dune-server"
  region = "nyc1"
  size   = "s-1vcpu-1gb-intel"
  ssh_keys = [
    var.ssh_key_fingerprint
  ]
}

resource "digitalocean_volume_attachment" "dune_volume" {
  droplet_id = digitalocean_droplet.dune_server.id
  volume_id  = digitalocean_volume.dune_volume.id
}

resource "digitalocean_firewall" "dune_firewall" {
  name        = "dune-firewall"
  droplet_ids = [digitalocean_droplet.dune_server.id]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "icmp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "public_ip_server" {
  value = digitalocean_droplet.dune_server.ipv4_address
}