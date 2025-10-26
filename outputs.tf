# Service Bus Module Outputs

output "servicebus_namespace_id" {
  description = "ID of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.this.id
}

output "servicebus_namespace_name" {
  description = "Name of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.this.name
}

output "servicebus_namespace_primary_connection_string" {
  description = "Primary connection string for the Service Bus namespace"
  value       = azurerm_servicebus_namespace.this.default_primary_connection_string
  sensitive   = true
}

output "servicebus_namespace_secondary_connection_string" {
  description = "Secondary connection string for the Service Bus namespace"
  value       = azurerm_servicebus_namespace.this.default_secondary_connection_string
  sensitive   = true
}

output "servicebus_namespace_primary_key" {
  description = "Primary key for the Service Bus namespace"
  value       = azurerm_servicebus_namespace.this.default_primary_key
  sensitive   = true
}

output "servicebus_namespace_secondary_key" {
  description = "Secondary key for the Service Bus namespace"
  value       = azurerm_servicebus_namespace.this.default_secondary_key
  sensitive   = true
}

output "servicebus_queues" {
  description = "Map of Service Bus queues with their properties"
  value = {
    for queue in azurerm_servicebus_queue.this : queue.name => {
      id   = queue.id
      name = queue.name
    }
  }
}

output "servicebus_topics" {
  description = "Map of Service Bus topics with their properties"
  value = {
    for topic in azurerm_servicebus_topic.this : topic.name => {
      id   = topic.id
      name = topic.name
    }
  }
}

output "servicebus_subscriptions" {
  description = "Map of Service Bus subscriptions with their properties"
  value = {
    for subscription in azurerm_servicebus_subscription.this : subscription.name => {
      id    = subscription.id
      name  = subscription.name
      topic = split(".", subscription.topic_id)[length(split(".", subscription.topic_id)) - 1]
    }
  }
}

output "servicebus_namespace_auth_rules" {
  description = "Map of namespace authorization rules with their properties"
  value = {
    for rule in azurerm_servicebus_namespace_authorization_rule.this : rule.name => {
      id                          = rule.id
      name                        = rule.name
      primary_key                 = rule.primary_key
      secondary_key               = rule.secondary_key
      primary_connection_string   = rule.primary_connection_string
      secondary_connection_string = rule.secondary_connection_string
    }
  }
  sensitive = true
}

output "servicebus_queue_auth_rules" {
  description = "Map of queue authorization rules with their properties"
  value = {
    for rule in azurerm_servicebus_queue_authorization_rule.this : rule.name => {
      id                          = rule.id
      name                        = rule.name
      queue                       = split("/", rule.queue_id)[length(split("/", rule.queue_id)) - 1]
      primary_key                 = rule.primary_key
      secondary_key               = rule.secondary_key
      primary_connection_string   = rule.primary_connection_string
      secondary_connection_string = rule.secondary_connection_string
    }
  }
  sensitive = true
}

output "servicebus_topic_auth_rules" {
  description = "Map of topic authorization rules with their properties"
  value = {
    for rule in azurerm_servicebus_topic_authorization_rule.this : rule.name => {
      id                          = rule.id
      name                        = rule.name
      topic                       = split("/", rule.topic_id)[length(split("/", rule.topic_id)) - 1]
      primary_key                 = rule.primary_key
      secondary_key               = rule.secondary_key
      primary_connection_string   = rule.primary_connection_string
      secondary_connection_string = rule.secondary_connection_string
    }
  }
  sensitive = true
}

output "servicebus_private_endpoint" {
  description = "Private endpoint configuration"
  value = var.enable_private_endpoint ? {
    id                 = azurerm_private_endpoint.this["namespace"].id
    name               = azurerm_private_endpoint.this["namespace"].name
    private_ip_address = azurerm_private_endpoint.this["namespace"].private_service_connection[0].private_ip_address
  } : null
}

output "servicebus_private_dns_zone" {
  description = "Private DNS zone configuration"
  value = var.enable_private_endpoint && var.create_private_dns_zone ? {
    id   = azurerm_private_dns_zone.this[0].id
    name = azurerm_private_dns_zone.this[0].name
  } : null
}

output "servicebus_resource_group_name" {
  description = "Resource group name"
  value       = local.resource_group_name
}

output "servicebus_location" {
  description = "Azure region"
  value       = local.location
}

output "servicebus_sku" {
  description = "Service Bus SKU"
  value       = var.sku
}

output "servicebus_capacity" {
  description = "Service Bus capacity"
  value       = var.capacity
}

output "servicebus_managed_identity_enabled" {
  description = "Whether managed identity is enabled"
  value       = var.enable_managed_identity
}

output "servicebus_identity" {
  description = "Managed identity configuration"
  value       = var.enable_managed_identity ? azurerm_servicebus_namespace.this.identity : null
}

output "servicebus_network_rules_enabled" {
  description = "Whether network rules are enabled"
  value       = var.enable_network_rules
}

output "servicebus_private_endpoint_enabled" {
  description = "Whether private endpoint is enabled"
  value       = var.enable_private_endpoint
}

output "servicebus_diagnostic_settings_enabled" {
  description = "Whether diagnostic settings are enabled"
  value       = var.enable_diagnostic_settings
}

output "servicebus_resource_lock_enabled" {
  description = "Whether resource lock is enabled"
  value       = var.enable_resource_lock
}

output "servicebus_tags" {
  description = "Tags applied to resources"
  value       = local.tags
}