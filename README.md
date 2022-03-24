# ibmcloud-vpc-fortigate-terraform
Lab deployment for using the Fortigate VNF in an IBM Cloud VPC

![Version 1 of deployment](https://dsc.cloud/quickshare/fortigate-single-zone-v1.png)

## Wish List

#### If creating a new VPC for the deployment

- [x] Create VPC across 3 zones
- [x] Create 2 subnets for Fortigate VNF (port 1 and port 2)
- [x] Create 2 subnets for testing VMs
- [x] Create Fortigate VNF and associated routing tables 
- [x] Create 2 Ubuntu 20 test VMs
- [x] Create COS buckets for Fortigate Port 1 and Port 2 interfaces
- [x] Create COS buckets for VM 1 and VM 2 subnets
- [x] Attach Subnets to newly created Fortigate routing tables
- [x] Routing table updated for VM 1 and VM 2 subnets to point to Fortigate Port 1 Private IP
- [x] Create an Interface level VPC Flowlog collector for each Fortigate interface (port 1 and port 2)
- [x] Create a Subnet level VPC Flowlog collector for each VM subnet.
- [ ] Ability to deploy COS if no `cos_instance` variable is set 
- [ ] Ability to disable the deployment of the test VMs

#### If using an existing VPC for the deployment

- [x] Ability to use existing VPC as deployment target
- [x] Create 2 subnets for Fortigate VNF (port 1 and port 2)
- [x] Create 2 subnets for testing VMs
- [x] Create Fortigate VNF and associated routing tables 
- [x] Create 2 Ubuntu 20 test VMs
- [x] Create COS buckets for Fortigate Port 1 and Port 2 interfaces
- [x] Create COS buckets for VM 1 and VM 2 subnets
- [x] Attach Subnets to newly created Fortigate routing tables
- [x] Routing table updated for VM 1 and VM 2 subnets to point to Fortigate Port 1 Private IP
- [x] Create an Interface level VPC Flowlog collector for each Fortigate interface (port 1 and port 2)
- [x] Create a Subnet level VPC Flowlog collector for each VM subnet
- [ ] Ability to deploy COS if no `cos_instance` variable is set
- [ ] Ability to use existing Subnets for Fortigate VNF
- [ ] Ability to use existing Subnets for test VMs
- [ ] Ability to disable the deployment of the test VMs

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

---

## Deploy Fortigate VNF lab environment

1. Copy `terraform.tfvars.example` to `terraform.tfvars`:

   ```sh
   cp terraform.tfvars.example terraform.tfvars
   ```

1. Edit `terraform.tfvars` to match your environment. See [variables](#variables) listed above for available options.
1. Plan deployment:

   ```sh
   terraform init
   terraform plan -out default.tfplan
   ```

1. Apply deployment:

   ```sh
   terraform apply default.tfplan
   ```