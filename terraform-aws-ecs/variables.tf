### cluster 
# type('EC2')
# instance_type('m5.large')
# node_max_size(3)
# node_min_size(3)
# node_desired_size(3)
# node_vol_size(8)
# ssh_port(2080)
# ssh_key('')

variable "cluster" {
  description = "The definition of container cluster."
  default     = {}
}

variable "ecs_cluster_name" {
  default     = ""
}

variable "cluster_name" {
  default     = ""
}

variable "task_name" {
  default     = ""
}

variable "name" {
  default     = ""
}

variable "services" {
  description = "The launch configuration of container and definition of cluster type of ecs"
  default     = []
}

### Tags
variable "tags" {
  description = "The key-value map for ec2/asg tags"
  type        = list

  default = [
    {
      "key"                 = "billing"
      "value"               = "ops"
      "propagate_at_launch" = true
    },
  ]
}

variable "region" {
  description = "The aws region to deploy the service into"
  type        = string
}

variable "azs" {
  description = "A list of availability zones for the VPC"
  type        = list(string)
}

variable "vpc" {
  description = "The vpc id of this service is being deployed into"
  type        = string
}

variable "subnets" {
  description = "A list of the AWS IDs of the Subnets which the cluster will be deployed into"
  type        = list(string)
}

variable "stack_name" {
  description = "Text used to identify stack of infrastructure components. Need to be unique but short since it will be used in resource naming"
  default     = "default"
}

variable "app_name" {
  description = "The logical name of the module instance"
  default     = "default"
}

variable "app_short_name" {
  description = "The logical name of the module instance for short"
  default     = "dft"
}

variable "app_detail" {
  description = "The extra description of module instance"
  default     = ""
}

