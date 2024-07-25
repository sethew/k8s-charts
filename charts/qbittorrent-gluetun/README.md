# QBittorrent + Gluetun Chart

A Helm chart for deploying a QBittorrent client that uses a VPN tunnel provided by Gluetun.

### Installation via Helm

TODO

### Define a secret for VPN credentials

```
kubectl create secret generic vpn-credentials \
  --from-literal=OPENVPN_USER='your_username' \
  --from-literal=OPENVPN_PASSWORD='your_password' \
  --namespace=default
```

### QBittorrent login

The login is `admin`. The password is visible in the logs of the qbittorent app:

```
kubectl logs qbittorrent-gluetun-RELEASE-UNIQ qbittorrent
```

Replace RELEASE-UNIQ by the name of your pod.