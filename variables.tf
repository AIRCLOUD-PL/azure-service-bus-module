# Service Bus Module Variables

# Resource Configuration
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "location_short" {
  description = "Short name for the location (e.g., 'eus' for East US)"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., 'dev', 'test', 'prod')"
  type        = string
}

variable "custom_name" {
  description = "Custom name for the Service Bus namespace"
  type        = string
}

variable "servicebus_name" {
  description = "Name of the Service Bus namespace (must be globally unique). If empty, will be generated from naming convention"
  type        = string
  default     = ""
}

variable "create_resource_group" {
  description = "Whether to create the resource group"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}

# Service Bus Configuration
variable "sku" {
  description = "SKU for the Service Bus namespace (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium"
  }
}

variable "capacity" {
  description = "Capacity for Premium SKU (1-16)"
  type        = number
  default     = 1
  validation {
    condition     = var.capacity >= 1 && var.capacity <= 16
    error_message = "Capacity must be between 1 and 16"
  }
}

variable "zone_redundant" {
  description = "Whether to enable zone redundancy for Premium SKU"
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "Minimum TLS version (1.0, 1.1, 1.2)"
  type        = string
  default     = "1.2"
  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "Minimum TLS version must be 1.0, 1.1, or 1.2"
  }
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled"
  type        = bool
  default     = true
}

variable "local_auth_enabled" {
  description = "Whether local authentication is enabled"
  type        = bool
  default     = true
}

variable "premium_messaging_partitions" {
  description = "Number of messaging partitions for Premium SKU"
  type        = number
  default     = 1
}

# Identity Configuration
variable "enable_managed_identity" {
  description = "Enable managed identity for the Service Bus namespace"
  type        = bool
  default     = true
}

# Network Configuration
variable "enable_network_rules" {
  description = "Enable network rules for the Service Bus namespace"
  type        = bool
  default     = false
}

variable "network_default_action" {
  description = "Default action for network rules (Allow, Deny)"
  type        = string
  default     = "Deny"
  validation {
    condition     = contains(["Allow", "Deny"], var.network_default_action)
    error_message = "Network default action must be Allow or Deny"
  }
}

variable "trusted_services_allowed" {
  description = "Whether trusted services are allowed to bypass network rules"
  type        = bool
  default     = false
}

variable "ip_rules" {
  description = "List of IP rules for network access"
  type        = list(string)
  default     = []
}

variable "virtual_network_rules" {
  description = "List of virtual network rules for network access"
  type = list(object({
    subnet_id                            = string
    ignore_missing_vnet_service_endpoint = optional(bool, false)
  }))
  default = []
}

# Queues Configuration
variable "queues" {
  description = "List of Service Bus queues to create"
  type = list(object({
    name = string
    authorization_rules = optional(list(object({
      name   = string
      listen = optional(bool, true)
      send   = optional(bool, true)
      manage = optional(bool, false)
    })), [])
    lock_duration                           = optional(string, "PT5M")
    max_size_in_megabytes                   = optional(number, 1024)
    requires_duplicate_detection            = optional(bool, false)
    duplicate_detection_history_time_window = optional(string, "PT10M")
    requires_session                        = optional(bool, false)
    default_message_ttl                     = optional(string, "P14D")
    dead_lettering_on_message_expiration    = optional(bool, false)
    enable_batched_operations               = optional(bool, true)
    enable_express                          = optional(bool, false)
    enable_partitioning                     = optional(bool, false)
    max_delivery_count                      = optional(number, 10)
    status                                  = optional(string, "Active")
    forward_to                              = optional(string, null)
    forward_dead_lettered_messages_to       = optional(string, null)
    enable_archive                          = optional(bool, false)
  }))
  default = []
}

# Topics Configuration
variable "topics" {
  description = "List of Service Bus topics to create"
  type = list(object({
    name = string
    authorization_rules = optional(list(object({
      name   = string
      listen = optional(bool, true)
      send   = optional(bool, true)
      manage = optional(bool, false)
    })), [])
    status                                  = optional(string, "Active")
    auto_delete_on_idle                     = optional(string, "P10675199DT2H48M5.477S")
    default_message_ttl                     = optional(string, "P14D")
    duplicate_detection_history_time_window = optional(string, "PT10M")
    enable_batched_operations               = optional(bool, true)
    enable_express                          = optional(bool, false)
    enable_partitioning                     = optional(bool, false)
    max_size_in_megabytes                   = optional(number, 1024)
    requires_duplicate_detection            = optional(bool, false)
    support_ordering                        = optional(bool, false)
    enable_archive                          = optional(bool, false)
    subscriptions = optional(list(object({
      name = string
      rules = optional(list(object({
        name        = string
        filter_type = optional(string, "SqlFilter")
        sql_filter = optional(object({
          sql_expression = string
        }), null)
        correlation_filter = optional(object({
          content_type        = optional(string)
          correlation_id      = optional(string)
          label               = optional(string)
          message_id          = optional(string)
          reply_to            = optional(string)
          reply_to_session_id = optional(string)
          session_id          = optional(string)
          to                  = optional(string)
          user_properties     = optional(map(string))
        }), null)
        action = optional(object({
          sql_expression = string
        }), null)
      })), [])
      max_delivery_count                        = optional(number, 10)
      lock_duration                             = optional(string, "PT5M")
      forward_to                                = optional(string, null)
      dead_lettering_on_message_expiration      = optional(bool, false)
      dead_lettering_on_filter_evaluation_error = optional(bool, true)
      default_message_ttl                       = optional(string, "P14D")
      enable_batched_operations                 = optional(bool, true)
      requires_session                          = optional(bool, false)
      forward_dead_lettered_messages_to         = optional(string, null)
      status                                    = optional(string, "Active")
      client_scoped_subscription_enabled        = optional(bool, false)
      client_scoped_subscription = optional(object({
        client_id                               = string
        is_client_scoped_subscription_shareable = optional(bool, false)
        is_client_scoped_subscription_durable   = optional(bool, false)
      }), null)
    })), [])
  }))
  default = []
}

# Authorization Rules
variable "namespace_authorization_rules" {
  description = "List of authorization rules for the Service Bus namespace"
  type = list(object({
    name   = string
    listen = optional(bool, true)
    send   = optional(bool, true)
    manage = optional(bool, false)
  }))
  default = []
}

# Private Endpoint Configuration
variable "enable_private_endpoint" {
  description = "Enable private endpoint for Service Bus namespace"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
}

variable "create_private_dns_zone" {
  description = "Create private DNS zone for private endpoint"
  type        = bool
  default     = false
}

variable "private_dns_zone_virtual_network_id" {
  description = "Virtual network ID for private DNS zone link"
  type        = string
  default     = null
}

# Monitoring Configuration
variable "enable_diagnostic_settings" {
  description = "Enable diagnostic settings for Service Bus namespace"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for diagnostic settings"
  type        = string
  default     = null
}

variable "diagnostic_settings" {
  description = "Configuration for diagnostic settings"
  type = object({
    logs = list(object({
      category = string
    }))
    metrics = list(object({
      category = string
      enabled  = bool
    }))
  })
  default = {
    logs = [
      {
        category = "OperationalLogs"
      },
      {
        category = "VNetAndIPFilteringLogs"
      }
    ]
    metrics = [
      {
        category = "AllMetrics"
        enabled  = true
      }
    ]
  }
}

# Resource Lock Configuration
variable "enable_resource_lock" {
  description = "Enable resource lock for Service Bus namespace"
  type        = bool
  default     = false
}

variable "lock_level" {
  description = "Level of resource lock (CanNotDelete or ReadOnly)"
  type        = string
  default     = "CanNotDelete"
  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock_level)
    error_message = "Lock level must be CanNotDelete or ReadOnly"
  }
}

# Azure Policy Configuration
variable "enable_policy_assignments" {
  description = "Enable Azure Policy assignments for Service Bus"
  type        = bool
  default     = false
}

variable "enable_custom_policies" {
  description = "Enable custom policy assignments for Service Bus"
  type        = bool
  default     = false
}

variable "enable_policy_initiative" {
  description = "Enable policy initiative assignment for Service Bus"
  type        = bool
  default     = false
}

variable "policy_initiative_id" {
  description = "ID of the policy initiative to assign"
  type        = string
  default     = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
}