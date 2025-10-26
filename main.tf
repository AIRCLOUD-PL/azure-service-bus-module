# Azure Service Bus Module
# Creates enterprise-grade Service Bus namespace with advanced security, monitoring, and compliance features

# Data sources
data "azurerm_client_config" "current" {}

# Local values
locals {
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short
  environment         = var.environment
  custom_name         = var.custom_name

  # Naming convention
  name_prefix = "sb-${local.custom_name}-${local.location_short}-${local.environment}"

  # Service Bus namespace name (must be globally unique)
  servicebus_name = var.servicebus_name != "" ? var.servicebus_name : local.name_prefix

  # Resource tags
  tags = merge(
    {
      Environment = local.environment
      Location    = local.location
      Service     = "Service Bus"
      Module      = "messaging/service-bus"
      CreatedBy   = "Terraform"
      CreatedOn   = timestamp()
    },
    var.tags
  )

  # Identity configuration
  identity_type = var.enable_managed_identity ? "SystemAssigned" : null

  # Network configuration
  network_rules = var.enable_network_rules ? {
    default_action                = var.network_default_action
    public_network_access_enabled = var.public_network_access_enabled
    trusted_services_allowed      = var.trusted_services_allowed
    ip_rules                      = var.ip_rules
    virtual_network_rules         = var.virtual_network_rules
  } : null

  # Queues configuration
  queues = {
    for queue in var.queues : queue.name => {
      name                                    = queue.name
      lock_duration                           = lookup(queue, "lock_duration", "PT5M")
      max_size_in_megabytes                   = lookup(queue, "max_size_in_megabytes", 1024)
      requires_duplicate_detection            = lookup(queue, "requires_duplicate_detection", false)
      duplicate_detection_history_time_window = lookup(queue, "duplicate_detection_history_time_window", "PT10M")
      requires_session                        = lookup(queue, "requires_session", false)
      default_message_ttl                     = lookup(queue, "default_message_ttl", "P14D")
      dead_lettering_on_message_expiration    = lookup(queue, "dead_lettering_on_message_expiration", false)
      enable_batched_operations               = lookup(queue, "enable_batched_operations", true)
      enable_express                          = lookup(queue, "enable_express", false)
      enable_partitioning                     = lookup(queue, "enable_partitioning", false)
      max_delivery_count                      = lookup(queue, "max_delivery_count", 10)
      status                                  = lookup(queue, "status", "Active")
      forward_to                              = lookup(queue, "forward_to", null)
      forward_dead_lettered_messages_to       = lookup(queue, "forward_dead_lettered_messages_to", null)
      enable_archive                          = lookup(queue, "enable_archive", false)
    }
  }

  # Topics configuration
  topics = {
    for topic in var.topics : topic.name => {
      name                                    = topic.name
      status                                  = lookup(topic, "status", "Active")
      auto_delete_on_idle                     = lookup(topic, "auto_delete_on_idle", "P10675199DT2H48M5.477S")
      default_message_ttl                     = lookup(topic, "default_message_ttl", "P14D")
      duplicate_detection_history_time_window = lookup(topic, "duplicate_detection_history_time_window", "PT10M")
      enable_batched_operations               = lookup(topic, "enable_batched_operations", true)
      enable_express                          = lookup(topic, "enable_express", false)
      enable_partitioning                     = lookup(topic, "enable_partitioning", false)
      max_size_in_megabytes                   = lookup(topic, "max_size_in_megabytes", 1024)
      requires_duplicate_detection            = lookup(topic, "requires_duplicate_detection", false)
      support_ordering                        = lookup(topic, "support_ordering", false)
      enable_archive                          = lookup(topic, "enable_archive", false)
    }
  }

  # Subscriptions configuration
  subscriptions = flatten([
    for topic in var.topics : [
      for subscription in lookup(topic, "subscriptions", []) : {
        topic_name                                = topic.name
        name                                      = subscription.name
        max_delivery_count                        = lookup(subscription, "max_delivery_count", 10)
        lock_duration                             = lookup(subscription, "lock_duration", "PT5M")
        forward_to                                = lookup(subscription, "forward_to", null)
        dead_lettering_on_message_expiration      = lookup(subscription, "dead_lettering_on_message_expiration", false)
        dead_lettering_on_filter_evaluation_error = lookup(subscription, "dead_lettering_on_filter_evaluation_error", true)
        default_message_ttl                       = lookup(subscription, "default_message_ttl", "P14D")
        enable_batched_operations                 = lookup(subscription, "enable_batched_operations", true)
        requires_session                          = lookup(subscription, "requires_session", false)
        forward_dead_lettered_messages_to         = lookup(subscription, "forward_dead_lettered_messages_to", null)
        status                                    = lookup(subscription, "status", "Active")
        client_scoped_subscription_enabled        = lookup(subscription, "client_scoped_subscription_enabled", false)
        client_scoped_subscription                = lookup(subscription, "client_scoped_subscription", null)
      }
    ]
  ])

  # Authorization rules
  namespace_auth_rules = {
    for rule in var.namespace_authorization_rules : rule.name => {
      name   = rule.name
      listen = lookup(rule, "listen", true)
      send   = lookup(rule, "send", true)
      manage = lookup(rule, "manage", false)
    }
  }

  queue_auth_rules = flatten([
    for queue in var.queues : [
      for rule in lookup(queue, "authorization_rules", []) : {
        queue_name = queue.name
        name       = rule.name
        listen     = lookup(rule, "listen", true)
        send       = lookup(rule, "send", true)
        manage     = lookup(rule, "manage", false)
      }
    ]
  ])

  topic_auth_rules = flatten([
    for topic in var.topics : [
      for rule in lookup(topic, "authorization_rules", []) : {
        topic_name = topic.name
        name       = rule.name
        listen     = lookup(rule, "listen", true)
        send       = lookup(rule, "send", true)
        manage     = lookup(rule, "manage", false)
      }
    ]
  ])
}

# Resource Group (if not provided externally)
resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

# Service Bus Namespace
resource "azurerm_servicebus_namespace" "this" {
  name                          = local.servicebus_name
  location                      = local.location
  resource_group_name           = local.resource_group_name
  sku                           = var.sku
  capacity                      = var.capacity
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  local_auth_enabled            = var.local_auth_enabled
  premium_messaging_partitions  = var.premium_messaging_partitions

  dynamic "identity" {
    for_each = local.identity_type != null ? [1] : []
    content {
      type = local.identity_type
    }
  }

  dynamic "network_rule_set" {
    for_each = local.network_rules != null ? [local.network_rules] : []
    content {
      default_action                = network_rule_set.value.default_action
      public_network_access_enabled = network_rule_set.value.public_network_access_enabled
      trusted_services_allowed      = network_rule_set.value.trusted_services_allowed

      dynamic "ip_rules" {
        for_each = network_rule_set.value.ip_rules
        content {
          ip_mask = ip_rules.value
        }
      }

      dynamic "virtual_network_rules" {
        for_each = network_rule_set.value.virtual_network_rules
        content {
          subnet_id                            = virtual_network_rules.value.subnet_id
          ignore_missing_vnet_service_endpoint = virtual_network_rules.value.ignore_missing_vnet_service_endpoint
        }
      }
    }
  }

  tags = local.tags

  depends_on = [
    azurerm_resource_group.this
  ]
}

# Service Bus Namespace Authorization Rules
resource "azurerm_servicebus_namespace_authorization_rule" "this" {
  for_each = local.namespace_auth_rules

  name         = each.value.name
  namespace_id = azurerm_servicebus_namespace.this.id

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

# Service Bus Queues
resource "azurerm_servicebus_queue" "this" {
  for_each = local.queues

  name                                    = each.value.name
  namespace_id                            = azurerm_servicebus_namespace.this.id
  lock_duration                           = each.value.lock_duration
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  requires_session                        = each.value.requires_session
  default_message_ttl                     = each.value.default_message_ttl
  dead_lettering_on_message_expiration    = each.value.dead_lettering_on_message_expiration
  max_delivery_count                      = each.value.max_delivery_count
  status                                  = each.value.status
  forward_to                              = each.value.forward_to
  forward_dead_lettered_messages_to       = each.value.forward_dead_lettered_messages_to
}

# Service Bus Queue Authorization Rules
resource "azurerm_servicebus_queue_authorization_rule" "this" {
  for_each = {
    for rule in local.queue_auth_rules : "${rule.queue_name}.${rule.name}" => rule
  }

  name     = each.value.name
  queue_id = azurerm_servicebus_queue.this[each.value.queue_name].id

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

# Service Bus Topics
resource "azurerm_servicebus_topic" "this" {
  for_each = local.topics

  name                                    = each.value.name
  namespace_id                            = azurerm_servicebus_namespace.this.id
  status                                  = each.value.status
  auto_delete_on_idle                     = each.value.auto_delete_on_idle
  default_message_ttl                     = each.value.default_message_ttl
  duplicate_detection_history_time_window = each.value.duplicate_detection_history_time_window
  max_size_in_megabytes                   = each.value.max_size_in_megabytes
  requires_duplicate_detection            = each.value.requires_duplicate_detection
  support_ordering                        = each.value.support_ordering
}

# Service Bus Topic Authorization Rules
resource "azurerm_servicebus_topic_authorization_rule" "this" {
  for_each = {
    for rule in local.topic_auth_rules : "${rule.topic_name}.${rule.name}" => rule
  }

  name     = each.value.name
  topic_id = azurerm_servicebus_topic.this[each.value.topic_name].id

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

# Service Bus Subscriptions
resource "azurerm_servicebus_subscription" "this" {
  for_each = {
    for sub in local.subscriptions : "${sub.topic_name}.${sub.name}" => sub
  }

  name                                      = each.value.name
  topic_id                                  = azurerm_servicebus_topic.this[each.value.topic_name].id
  max_delivery_count                        = each.value.max_delivery_count
  lock_duration                             = each.value.lock_duration
  forward_to                                = each.value.forward_to
  dead_lettering_on_message_expiration      = each.value.dead_lettering_on_message_expiration
  dead_lettering_on_filter_evaluation_error = each.value.dead_lettering_on_filter_evaluation_error
  default_message_ttl                       = each.value.default_message_ttl
  requires_session                          = each.value.requires_session
  forward_dead_lettered_messages_to         = each.value.forward_dead_lettered_messages_to
  status                                    = each.value.status

  dynamic "client_scoped_subscription" {
    for_each = each.value.client_scoped_subscription_enabled ? [each.value.client_scoped_subscription] : []
    content {
      client_id                               = client_scoped_subscription.value.client_id
      is_client_scoped_subscription_shareable = client_scoped_subscription.value.is_client_scoped_subscription_shareable
      is_client_scoped_subscription_durable   = client_scoped_subscription.value.is_client_scoped_subscription_durable
    }
  }
}

# Service Bus Subscription Rules (SQL Filters)
resource "azurerm_servicebus_subscription_rule" "this" {
  for_each = flatten([
    for topic in var.topics : [
      for subscription in lookup(topic, "subscriptions", []) : [
        for rule in lookup(subscription, "rules", []) : {
          topic_name         = topic.name
          subscription_name  = subscription.name
          rule_name          = rule.name
          filter_type        = lookup(rule, "filter_type", "SqlFilter")
          sql_filter         = lookup(rule, "sql_filter", null)
          correlation_filter = lookup(rule, "correlation_filter", null)
          action             = lookup(rule, "action", null)
        }
      ]
    ]
  ])

  name            = each.value.rule_name
  subscription_id = azurerm_servicebus_subscription.this["${each.value.topic_name}.${each.value.subscription_name}"].id
  filter_type     = each.value.filter_type

  dynamic "sql_filter" {
    for_each = each.value.sql_filter != null ? [each.value.sql_filter] : []
    content {
      sql_expression = sql_filter.value
    }
  }

  dynamic "correlation_filter" {
    for_each = each.value.correlation_filter != null ? [each.value.correlation_filter] : []
    content {
      content_type        = correlation_filter.value.content_type
      correlation_id      = correlation_filter.value.correlation_id
      label               = correlation_filter.value.label
      message_id          = correlation_filter.value.message_id
      reply_to            = correlation_filter.value.reply_to
      reply_to_session_id = correlation_filter.value.reply_to_session_id
      session_id          = correlation_filter.value.session_id
      to                  = correlation_filter.value.to
    }
  }

  dynamic "action" {
    for_each = each.value.action != null ? [each.value.action] : []
    content {
      sql_expression = action.value
    }
  }
}

# Private Endpoints
resource "azurerm_private_endpoint" "this" {
  for_each = var.enable_private_endpoint ? toset(["namespace"]) : []

  name                = "${local.servicebus_name}-pe"
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${local.servicebus_name}-pe-conn"
    private_connection_resource_id = azurerm_servicebus_namespace.this.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }

  tags = local.tags

  depends_on = [
    azurerm_servicebus_namespace.this
  ]
}

# Private DNS Zone (if private endpoint is enabled)
resource "azurerm_private_dns_zone" "this" {
  count = var.enable_private_endpoint && var.create_private_dns_zone ? 1 : 0

  name                = "privatelink.servicebus.windows.net"
  resource_group_name = local.resource_group_name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count = var.enable_private_endpoint && var.create_private_dns_zone ? 1 : 0

  name                  = "${local.servicebus_name}-dns-link"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[0].name
  virtual_network_id    = var.private_dns_zone_virtual_network_id
  registration_enabled  = false
  tags                  = local.tags
}

resource "azurerm_private_dns_a_record" "this" {
  count = var.enable_private_endpoint && var.create_private_dns_zone ? 1 : 0

  name                = local.servicebus_name
  zone_name           = azurerm_private_dns_zone.this[0].name
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.this["namespace"].private_service_connection[0].private_ip_address]

  depends_on = [
    azurerm_private_endpoint.this
  ]
}

# Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.enable_diagnostic_settings ? 1 : 0

  name                       = "${local.servicebus_name}-diagnostics"
  target_resource_id         = azurerm_servicebus_namespace.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = var.diagnostic_settings.logs
    content {
      category = enabled_log.value.category
    }
  }

  dynamic "metric" {
    for_each = var.diagnostic_settings.metrics
    content {
      category = metric.value.category
      enabled  = metric.value.enabled
    }
  }
}

# Resource Lock
resource "azurerm_management_lock" "this" {
  count = var.enable_resource_lock ? 1 : 0

  name       = "${local.servicebus_name}-lock"
  scope      = azurerm_servicebus_namespace.this.id
  lock_level = var.lock_level
  notes      = "Resource lock for Service Bus namespace"
}