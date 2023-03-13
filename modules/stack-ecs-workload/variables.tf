variable "is_enabled" {
  type        = bool
  description = <<EOF
  Whether this module will be created or not. It is useful, for stack-composite
modules that conditionally includes resources provided by this module..
EOF
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy the resources"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources."
  default     = {}
}

/*
-------------------------------------
Custom input variables
-------------------------------------
*/
variable "stack" {
  type        = string
  description = <<EOF
Name of the stack.
EOF
}

variable "stack_prefix" {
  type        = string
  description = "Prefix for the stack"
  default     = "stack"
}

variable "vpc_name" {
  type        = string
  description = <<EOF
Name of the VPC. This variable is used to fetch the VPC, Ids, subnets, etc.
EOF
}

variable "cluster" {
  type        = string
  description = <<EOF
The name of the cluster that hosts the service.
EOF
}

variable "port_config" {
  type = object({
    listening_port = number
    container_port = number
  })
  description = <<EOF
A list of objects that contains the listening port and the container port.
  - listening_port: The listening port that's configured on the load balancer.
  - container_port: The container port that's configured on the container.
EOF
}

variable "alb_name" {
  type        = string
  description = <<EOF
The name of the ALB. It's used to also fetch a couple of other attributes, like the
security group and the subnets.
EOF
}

variable "http_config" {
  type = object({
    enable_http  = optional(bool, true)
    enable_https = optional(bool, false)
  })
  description = <<EOF
  Configuration for HTTP and HTTPS. Current allowed attributes are:
  - enable_http: Whether to enable HTTP or not. Default is true.
  - enable_https: Whether to enable HTTPS or not. Default is false.
  EOF
}

variable "workload_name" {
  type        = string
  description = <<EOF
This variable defines the ecs service name, and the name of the task definition. Logically,
it should also represent the service/app that's being deployed.
EOF
}

variable "container_config" {
  type = object({
    image                 = string
    memory                = number
    cpu                   = number
    essential             = optional(bool, true)
    environment_variables = optional(list(map(string)), [])
    permissions = optional(list(object({
      type        = optional(string, "Allow")
      policy_name = string
      actions     = list(string)
      resources   = optional(list(string), ["*"])
    })), null)
  })
  description = <<EOF
  Configuration for the container. Current allowed attributes are:
  - image: The image to use for the container.
  - memory: The amount of memory (in MiB) to allow the container to use.
  - cpu: The number of cpu units to reserve for the container.
  - essential: Whether the container is essential or not. Default is true.
  - environment_variables: A list of maps that contains the environment variables.
    - name: The name of the environment variable.
    - value: The value of the environment variable.
  - permissions: A list of objects that contains the permissions for the container.
    - policy_name: The name of the policy.
    - type: The type of permission. Default is Allow.
    - actions: A list of actions that the container can perform.
    - resources: A list of resources that the container can access.
EOF
}

variable "manage_ecs_service_out_of_terraform" {
  type        = bool
  description = <<EOF
  Whether to manage the ECS service out of terraform or not. If set to true, the
  module will not create the ECS service, but it'll create and managet the ecs service
ignoring changes related to 'desired_count' and 'task_definitions' related changes.
EOF
  default     = false
}

variable "scaling_up_max_capacity" {
  type        = number
  description = <<EOF
  The maximum number of tasks, specified as a percentage of the Amazon ECS service's
desiredCount value, that can run in a service during a scaling activity.
EOF
}

variable "scaling_base_capacity" {
  type        = number
  description = <<EOF
  The minimum number of tasks, specified as a percentage of the Amazon ECS service's
desiredCount value, that must remain running and healthy in a service during a scaling
activity.
EOF
  default     = 1
}
