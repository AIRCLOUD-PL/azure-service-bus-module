<p align="center">
  <a href="https://aircloud.com.pl"><img src=".github/assets/banner.png" alt="AIRCLOUD: DevOps, cloud and AI engineering" width="100%"></a>
</p>

# azure-service-bus-module

**Azure Service Bus Terraform module — parameterised, azurerm 4.x, CI-validated.**

[![CI](https://github.com/AIRCLOUD-PL/azure-service-bus-module/actions/workflows/ci.yml/badge.svg)](https://github.com/AIRCLOUD-PL/azure-service-bus-module/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/AIRCLOUD-PL/azure-service-bus-module?sort=semver)](https://github.com/AIRCLOUD-PL/azure-service-bus-module/releases)

Azure Terraform module for service-bus-module.

## 🚀 Usage

Pin the module to a release tag:

```hcl
module "service_bus" {
  source = "git::https://github.com/AIRCLOUD-PL/azure-service-bus-module.git?ref=v1.0.0"

  # required inputs
  custom_name         = "..."
  environment         = "..."
  location            = "..."
  location_short      = "..."
  resource_group_name = "..."
}
```

All inputs and outputs are listed in the generated reference below ([Inputs](#inputs), [Outputs](#outputs)). Worked examples live in [`examples/`](examples/).

```hcl
module "service-bus-module" {
  source = "git::https://github.com/AIRCLOUD-PL/azure-service-bus-module.git?ref=v1.0.0"
  
  # Add your variables here
}
```

## 📖 Documentation

See the [examples](./examples/) directory for usage examples.

## 🧪 Testing

Run tests with:
```bash
cd test
go mod download
go test -v -timeout 30m
```

## 🔒 Security

This module includes:
- Security policies validation
- Compliance checks
- Best practices enforcement

See [SECURITY.md](./SECURITY.md) for details.

## 🤝 Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines.

## 📄 License

This project is licensed under the MIT License.

## Reference

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.81.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group_policy_assignment.servicebus_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.servicebus_initiative](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_assignment.servicebus_security](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_remediation.servicebus_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_remediation) | resource |
| [azurerm_resource_group_policy_remediation.servicebus_initiative](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_remediation) | resource |
| [azurerm_resource_group_policy_remediation.servicebus_security](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_remediation) | resource |
| [azurerm_servicebus_namespace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) | resource |
| [azurerm_servicebus_namespace_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_authorization_rule) | resource |
| [azurerm_servicebus_queue.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) | resource |
| [azurerm_servicebus_queue_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue_authorization_rule) | resource |
| [azurerm_servicebus_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_subscription) | resource |
| [azurerm_servicebus_subscription_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_subscription_rule) | resource |
| [azurerm_servicebus_topic.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_topic) | resource |
| [azurerm_servicebus_topic_authorization_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_topic_authorization_rule) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.existing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity"></a> [capacity](#input\_capacity) | Capacity for Premium SKU (1-16) | `number` | `1` | no |
| <a name="input_create_private_dns_zone"></a> [create\_private\_dns\_zone](#input\_create\_private\_dns\_zone) | Create private DNS zone for private endpoint | `bool` | `false` | no |
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Whether to create the resource group | `bool` | `false` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | Custom name for the Service Bus namespace | `string` | n/a | yes |
| <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings) | Configuration for diagnostic settings | <pre>object({<br/>    logs = list(object({<br/>      category = string<br/>    }))<br/>    metrics = list(object({<br/>      category = string<br/>      enabled  = bool<br/>    }))<br/>  })</pre> | <pre>{<br/>  "logs": [<br/>    {<br/>      "category": "OperationalLogs"<br/>    },<br/>    {<br/>      "category": "VNetAndIPFilteringLogs"<br/>    }<br/>  ],<br/>  "metrics": [<br/>    {<br/>      "category": "AllMetrics",<br/>      "enabled": true<br/>    }<br/>  ]<br/>}</pre> | no |
| <a name="input_enable_custom_policies"></a> [enable\_custom\_policies](#input\_enable\_custom\_policies) | Enable custom policy assignments for Service Bus | `bool` | `false` | no |
| <a name="input_enable_diagnostic_settings"></a> [enable\_diagnostic\_settings](#input\_enable\_diagnostic\_settings) | Enable diagnostic settings for Service Bus namespace | `bool` | `false` | no |
| <a name="input_enable_managed_identity"></a> [enable\_managed\_identity](#input\_enable\_managed\_identity) | Enable managed identity for the Service Bus namespace | `bool` | `true` | no |
| <a name="input_enable_network_rules"></a> [enable\_network\_rules](#input\_enable\_network\_rules) | Enable network rules for the Service Bus namespace | `bool` | `false` | no |
| <a name="input_enable_policy_assignments"></a> [enable\_policy\_assignments](#input\_enable\_policy\_assignments) | Enable Azure Policy assignments for Service Bus | `bool` | `false` | no |
| <a name="input_enable_policy_initiative"></a> [enable\_policy\_initiative](#input\_enable\_policy\_initiative) | Enable policy initiative assignment for Service Bus | `bool` | `false` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Enable private endpoint for Service Bus namespace | `bool` | `false` | no |
| <a name="input_enable_resource_lock"></a> [enable\_resource\_lock](#input\_enable\_resource\_lock) | Enable resource lock for Service Bus namespace | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., 'dev', 'test', 'prod') | `string` | n/a | yes |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | List of IP rules for network access | `list(string)` | `[]` | no |
| <a name="input_local_auth_enabled"></a> [local\_auth\_enabled](#input\_local\_auth\_enabled) | Whether local authentication is enabled | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for resources | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Short name for the location (e.g., 'eus' for East US) | `string` | n/a | yes |
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | Level of resource lock (CanNotDelete or ReadOnly) | `string` | `"CanNotDelete"` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics workspace ID for diagnostic settings | `string` | `null` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | Minimum TLS version (1.0, 1.1, 1.2) | `string` | `"1.2"` | no |
| <a name="input_namespace_authorization_rules"></a> [namespace\_authorization\_rules](#input\_namespace\_authorization\_rules) | List of authorization rules for the Service Bus namespace | <pre>list(object({<br/>    name   = string<br/>    listen = optional(bool, true)<br/>    send   = optional(bool, true)<br/>    manage = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_network_default_action"></a> [network\_default\_action](#input\_network\_default\_action) | Default action for network rules (Allow, Deny) | `string` | `"Deny"` | no |
| <a name="input_policy_initiative_id"></a> [policy\_initiative\_id](#input\_policy\_initiative\_id) | ID of the policy initiative to assign | `string` | `"/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"` | no |
| <a name="input_premium_messaging_partitions"></a> [premium\_messaging\_partitions](#input\_premium\_messaging\_partitions) | Number of messaging partitions for Premium SKU | `number` | `1` | no |
| <a name="input_private_dns_zone_virtual_network_id"></a> [private\_dns\_zone\_virtual\_network\_id](#input\_private\_dns\_zone\_virtual\_network\_id) | Virtual network ID for private DNS zone link | `string` | `null` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | Subnet ID for private endpoint | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is enabled | `bool` | `true` | no |
| <a name="input_queues"></a> [queues](#input\_queues) | List of Service Bus queues to create | <pre>list(object({<br/>    name = string<br/>    authorization_rules = optional(list(object({<br/>      name   = string<br/>      listen = optional(bool, true)<br/>      send   = optional(bool, true)<br/>      manage = optional(bool, false)<br/>    })), [])<br/>    lock_duration                           = optional(string, "PT5M")<br/>    max_size_in_megabytes                   = optional(number, 1024)<br/>    requires_duplicate_detection            = optional(bool, false)<br/>    duplicate_detection_history_time_window = optional(string, "PT10M")<br/>    requires_session                        = optional(bool, false)<br/>    default_message_ttl                     = optional(string, "P14D")<br/>    dead_lettering_on_message_expiration    = optional(bool, false)<br/>    enable_batched_operations               = optional(bool, true)<br/>    enable_express                          = optional(bool, false)<br/>    enable_partitioning                     = optional(bool, false)<br/>    max_delivery_count                      = optional(number, 10)<br/>    status                                  = optional(string, "Active")<br/>    forward_to                              = optional(string, null)<br/>    forward_dead_lettered_messages_to       = optional(string, null)<br/>    enable_archive                          = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_servicebus_name"></a> [servicebus\_name](#input\_servicebus\_name) | Name of the Service Bus namespace (must be globally unique). If empty, will be generated from naming convention | `string` | `""` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | SKU for the Service Bus namespace (Basic, Standard, Premium) | `string` | `"Standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for resources | `map(string)` | `{}` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | List of Service Bus topics to create | <pre>list(object({<br/>    name = string<br/>    authorization_rules = optional(list(object({<br/>      name   = string<br/>      listen = optional(bool, true)<br/>      send   = optional(bool, true)<br/>      manage = optional(bool, false)<br/>    })), [])<br/>    status                                  = optional(string, "Active")<br/>    auto_delete_on_idle                     = optional(string, "P10675199DT2H48M5.477S")<br/>    default_message_ttl                     = optional(string, "P14D")<br/>    duplicate_detection_history_time_window = optional(string, "PT10M")<br/>    enable_batched_operations               = optional(bool, true)<br/>    enable_express                          = optional(bool, false)<br/>    enable_partitioning                     = optional(bool, false)<br/>    max_size_in_megabytes                   = optional(number, 1024)<br/>    requires_duplicate_detection            = optional(bool, false)<br/>    support_ordering                        = optional(bool, false)<br/>    enable_archive                          = optional(bool, false)<br/>    subscriptions = optional(list(object({<br/>      name = string<br/>      rules = optional(list(object({<br/>        name        = string<br/>        filter_type = optional(string, "SqlFilter")<br/>        sql_filter = optional(object({<br/>          sql_expression = string<br/>        }), null)<br/>        correlation_filter = optional(object({<br/>          content_type        = optional(string)<br/>          correlation_id      = optional(string)<br/>          label               = optional(string)<br/>          message_id          = optional(string)<br/>          reply_to            = optional(string)<br/>          reply_to_session_id = optional(string)<br/>          session_id          = optional(string)<br/>          to                  = optional(string)<br/>          user_properties     = optional(map(string))<br/>        }), null)<br/>        action = optional(object({<br/>          sql_expression = string<br/>        }), null)<br/>      })), [])<br/>      max_delivery_count                        = optional(number, 10)<br/>      lock_duration                             = optional(string, "PT5M")<br/>      forward_to                                = optional(string, null)<br/>      dead_lettering_on_message_expiration      = optional(bool, false)<br/>      dead_lettering_on_filter_evaluation_error = optional(bool, true)<br/>      default_message_ttl                       = optional(string, "P14D")<br/>      enable_batched_operations                 = optional(bool, true)<br/>      requires_session                          = optional(bool, false)<br/>      forward_dead_lettered_messages_to         = optional(string, null)<br/>      status                                    = optional(string, "Active")<br/>      client_scoped_subscription_enabled        = optional(bool, false)<br/>      client_scoped_subscription = optional(object({<br/>        client_id                               = string<br/>        is_client_scoped_subscription_shareable = optional(bool, false)<br/>        is_client_scoped_subscription_durable   = optional(bool, false)<br/>      }), null)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_trusted_services_allowed"></a> [trusted\_services\_allowed](#input\_trusted\_services\_allowed) | Whether trusted services are allowed to bypass network rules | `bool` | `false` | no |
| <a name="input_virtual_network_rules"></a> [virtual\_network\_rules](#input\_virtual\_network\_rules) | List of virtual network rules for network access | <pre>list(object({<br/>    subnet_id                            = string<br/>    ignore_missing_vnet_service_endpoint = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Whether to enable zone redundancy for Premium SKU | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_servicebus_capacity"></a> [servicebus\_capacity](#output\_servicebus\_capacity) | Service Bus capacity |
| <a name="output_servicebus_diagnostic_settings_enabled"></a> [servicebus\_diagnostic\_settings\_enabled](#output\_servicebus\_diagnostic\_settings\_enabled) | Whether diagnostic settings are enabled |
| <a name="output_servicebus_identity"></a> [servicebus\_identity](#output\_servicebus\_identity) | Managed identity configuration |
| <a name="output_servicebus_location"></a> [servicebus\_location](#output\_servicebus\_location) | Azure region |
| <a name="output_servicebus_managed_identity_enabled"></a> [servicebus\_managed\_identity\_enabled](#output\_servicebus\_managed\_identity\_enabled) | Whether managed identity is enabled |
| <a name="output_servicebus_namespace_auth_rules"></a> [servicebus\_namespace\_auth\_rules](#output\_servicebus\_namespace\_auth\_rules) | Map of namespace authorization rules with their properties |
| <a name="output_servicebus_namespace_id"></a> [servicebus\_namespace\_id](#output\_servicebus\_namespace\_id) | ID of the Service Bus namespace |
| <a name="output_servicebus_namespace_name"></a> [servicebus\_namespace\_name](#output\_servicebus\_namespace\_name) | Name of the Service Bus namespace |
| <a name="output_servicebus_namespace_primary_connection_string"></a> [servicebus\_namespace\_primary\_connection\_string](#output\_servicebus\_namespace\_primary\_connection\_string) | Primary connection string for the Service Bus namespace |
| <a name="output_servicebus_namespace_primary_key"></a> [servicebus\_namespace\_primary\_key](#output\_servicebus\_namespace\_primary\_key) | Primary key for the Service Bus namespace |
| <a name="output_servicebus_namespace_secondary_connection_string"></a> [servicebus\_namespace\_secondary\_connection\_string](#output\_servicebus\_namespace\_secondary\_connection\_string) | Secondary connection string for the Service Bus namespace |
| <a name="output_servicebus_namespace_secondary_key"></a> [servicebus\_namespace\_secondary\_key](#output\_servicebus\_namespace\_secondary\_key) | Secondary key for the Service Bus namespace |
| <a name="output_servicebus_network_rules_enabled"></a> [servicebus\_network\_rules\_enabled](#output\_servicebus\_network\_rules\_enabled) | Whether network rules are enabled |
| <a name="output_servicebus_private_dns_zone"></a> [servicebus\_private\_dns\_zone](#output\_servicebus\_private\_dns\_zone) | Private DNS zone configuration |
| <a name="output_servicebus_private_endpoint"></a> [servicebus\_private\_endpoint](#output\_servicebus\_private\_endpoint) | Private endpoint configuration |
| <a name="output_servicebus_private_endpoint_enabled"></a> [servicebus\_private\_endpoint\_enabled](#output\_servicebus\_private\_endpoint\_enabled) | Whether private endpoint is enabled |
| <a name="output_servicebus_queue_auth_rules"></a> [servicebus\_queue\_auth\_rules](#output\_servicebus\_queue\_auth\_rules) | Map of queue authorization rules with their properties |
| <a name="output_servicebus_queues"></a> [servicebus\_queues](#output\_servicebus\_queues) | Map of Service Bus queues with their properties |
| <a name="output_servicebus_resource_group_name"></a> [servicebus\_resource\_group\_name](#output\_servicebus\_resource\_group\_name) | Resource group name |
| <a name="output_servicebus_resource_lock_enabled"></a> [servicebus\_resource\_lock\_enabled](#output\_servicebus\_resource\_lock\_enabled) | Whether resource lock is enabled |
| <a name="output_servicebus_sku"></a> [servicebus\_sku](#output\_servicebus\_sku) | Service Bus SKU |
| <a name="output_servicebus_subscriptions"></a> [servicebus\_subscriptions](#output\_servicebus\_subscriptions) | Map of Service Bus subscriptions with their properties |
| <a name="output_servicebus_tags"></a> [servicebus\_tags](#output\_servicebus\_tags) | Tags applied to resources |
| <a name="output_servicebus_topic_auth_rules"></a> [servicebus\_topic\_auth\_rules](#output\_servicebus\_topic\_auth\_rules) | Map of topic authorization rules with their properties |
| <a name="output_servicebus_topics"></a> [servicebus\_topics](#output\_servicebus\_topics) | Map of Service Bus topics with their properties |
<!-- END_TF_DOCS -->

---

## Part of the AIRCLOUD Azure module catalog

Browse all modules with usage snippets in the [module catalog](https://aircloud-pl.github.io/) or on [github.com/AIRCLOUD-PL](https://github.com/AIRCLOUD-PL). Built and maintained by [AIRCLOUD](https://aircloud.com.pl): DevOps, cloud and AI engineering. Need a hand with Azure landing zones or platform engineering? See [aircloud.com.pl/consulting](https://aircloud.com.pl/consulting).
