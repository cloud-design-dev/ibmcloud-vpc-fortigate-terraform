# ibmcloud-vpc-fortigate-terraform
Lab deployment for using the Fortigate VNF in an IBM Cloud VPC

![Version 1 of deployment](https://dsc.cloud/quickshare/fortigate-single-zone-v1.png)

## Currently Done
 - [x] VPC
 - [x] 2 subnets for Fortigate VNF
 - [x] 2 subnets for testing VMs
 - [x] Fortigate VNF 
 - [x] 2 Ubuntu 20 test VMs
 - [x] COS buckets for Fortigate Port 1 and Port 2 interfaces
 - [x] COS buckets for VM 1 and VM 2 subnets
 - [x] Subnets added to Fortigate routing table
 - [x] Routing table updated for VM 1 and VM 2 subnets to point to Fortigate Port 1 IP
 - [ ] Verbose output of all resources 
 - [x] Ability to use existing VPC as deployment target
 - [ ] Ability to deploy COS if no `cos_instance` variable is set 

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | Name that will be prepended to all deployed resources and used as a project tag. | `string` | n/a | yes |
| project\_prefix | Name that will be prepended to all deployed resources and used as a project tag. | `string` | n/a | yes |
| cos\_instance | Name of an existing COS instance to use for Flowlog buckets | `string` | n/a | yes |
| existing\_resource\_group\_name | Name of an existing Resource Group to associate with the deployed instances. If none provided, a new one will be created. | `string` | n/a | no |
| existing\_vpc\_name | Name of an existing VPC. If none provided, a new one will be created. | `string` | n/a | no |
| existing\_ssh\_key\_name | Name of an existing SSH Key to associate with the deployed instances. If none provided, a new one will be created. | `string` | n/a | no |
| tags | Tags to add to all deployed resources | `string` | `deployed_from:terraform` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc\_id | ID of the deployed VPC |
| Fortigate\_Public\_IP | Public Floating IP for the Fortigate VNF instance. |
| vm1\_private\_ip\_address| Private IP for VM 1 |
| vm2\_private\_ip\_address | Private IP for VM 2 | 
| List\_Routing\_Tables\_For\_VPC | Command to list all the routing tables for the deployed VPC | 
| fortigate\_port1\_collector\_bucket | Bucket name for Fortigate VNF Port 1 interface flowlog collector |
| fortigate\_port2\_collector\_bucket | Bucket name for Fortigate VNF Port 2 interface flowlog collector |
| vm1\_subnet\_collector\_bucket | Bucket name for VM 1 Subnet flowlog collector |
| vm2\_subnet\_collector\_bucket | Bucket name for VM 2 Subnet flowlog collector |