variable "project_name" {
  type = string
  default = "expense"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
    Component = "backend"
  }
}

variable "db_sg_description" {
  default = "SG for DB MySql Instances"
}

variable "zone_name" {
  default = "daws78s.online"
}