# Dev Environment

## Terraform

### To Configure
Edit the *dev.tfvars* file

### To Build
```bash
terraform apply -var-file="dev.tfvars"
```

### To Kill
```bash
terraform destroy
```

## Openvpn
A openvpn server will be started on the access vm and a client certificate will be copied into your project root.  
The client cert should work with any openvpn client

> If you're using windows and the vpn connects with errors resetting the TAP-Windows Addapter in `Control Panel\Network and Internet\Network Connections` usually helps

## Jenkins
The Jenkins Web UI should be accessable via the vms private IP while on the vpn.  
The admin password will need to be pulled out of the container running on the vm during initial setup.  
The jenkins agents will need to be manually connected to the jenkins master