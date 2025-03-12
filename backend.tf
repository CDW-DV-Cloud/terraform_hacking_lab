terraform {
  cloud {

    organization = "dv_aws_cloud_org"

    workspaces {
      name = "hacking-lab"
    }
  }
}