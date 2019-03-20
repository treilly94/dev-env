# Dev Environment

## AWS
Before running terraform you'll need an aws account and will have to set up default credentials on your local machine as outlined [here](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html)

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

## Gitlab
The Gitlab Web UI should be accessable via the vms [private IP](http://10.0.32.20) while on the vpn.

## Jenkins
The Jenkins Web UI should be accessable via the vms [private IP](http://10.0.32.21) while on the vpn.  
The admin password will need to be pulled out of the container running on the vm during initial setup.  
The jenkins agents will need to be manually connected to the jenkins master

## Sonarqube
The Sonarqube Web UI should be accessable via the vms [private IP](http://10.0.32.22) while on the vpn.