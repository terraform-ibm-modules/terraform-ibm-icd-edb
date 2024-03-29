# Complete example with BYOK encryption, CBR rules and VPE creation

An end-to-end example that does the following:

- Create a new resource group if one is not passed in.
- Create Key Protect instance with root key.
- Create a new ICD Enterprise database instance with BYOK encryption.
- Set 250 max connection for ICD Enterprise database instance.
- Create service credentials for the database instance.
- Create a Virtual Private Cloud (VPC).
- Create Context Based Restriction (CBR) to only allow Enterprise DB to be accessible from the VPC.
- Create a security group and a VPE for the Enterprise DB instance.
