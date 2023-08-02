variable "region" {
  description = "AWS region"
  default     = "us-east-2"
}

variable "account_id" {
  description = "AWS region"
  default     = ""
}

variable "profile" {
  description = "AWS profile used"
  default     = "default"
}


### Jenkins Server

variable "jenkins_instance_type" {
  default = "t3a.large"
}

variable "bastion_name_tag" {
  default = "si-jenkins"
}

variable "security_group" {
  default = "si-jenkins-sg"
}

variable "key_pair" {
  description = "Key Pair name to ssh to EC2"
  default     = "si-jenkins"
}

variable "environment_tag" {
  description = "Tag variable for environment"
  default     = "dev"
}


variable "project_name_tag" {
  description = "Tag variable for name of project"
  default     = "cicd"
}
