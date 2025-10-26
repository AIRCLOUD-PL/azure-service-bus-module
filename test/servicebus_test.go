package test

import (
	"testing"
	"fmt"
	"strings"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestServiceBusEnterprise(t *testing.T) {
	t.Parallel()

	// Generate unique names
	uniqueId := random.UniqueId()
	location := "East US"
	resourceGroupName := fmt.Sprintf("rg-sb-test-%s", uniqueId)
	namespaceName := fmt.Sprintf("sb-test-%s", uniqueId)

	// Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: "../",

		Vars: map[string]interface{}{
			"resource_group_name": resourceGroupName,
			"location": location,
			"location_short": "eus",
			"environment": "test",
			"custom_name": strings.Replace(namespaceName, "sb-test-", "", 1),

			// Service Bus configuration
			"sku": "Standard",
			"capacity": 1,
			"minimum_tls_version": "1.2",
			"public_network_access_enabled": true,
			"local_auth_enabled": true,

			// Identity
			"enable_managed_identity": true,

			// Queues
			"queues": []map[string]interface{}{
				{
					"name": "test-queue",
					"authorization_rules": []map[string]interface{}{
						{
							"name": "test-queue-rule",
							"listen": true,
							"send": true,
							"manage": false,
						},
					},
					"lock_duration": "PT5M",
					"max_size_in_megabytes": 1024,
					"requires_duplicate_detection": false,
					"duplicate_detection_history_time_window": "PT10M",
					"requires_session": false,
					"default_message_ttl": "P14D",
					"dead_lettering_on_message_expiration": false,
					"max_delivery_count": 10,
					"status": "Active",
				},
			},

			// Topics
			"topics": []map[string]interface{}{
				{
					"name": "test-topic",
					"authorization_rules": []map[string]interface{}{
						{
							"name": "test-topic-rule",
							"listen": true,
							"send": true,
							"manage": false,
						},
					},
					"status": "Active",
					"auto_delete_on_idle": "P10675199DT2H48M5.477S",
					"default_message_ttl": "P14D",
					"duplicate_detection_history_time_window": "PT10M",
					"max_size_in_megabytes": 1024,
					"requires_duplicate_detection": false,
					"support_ordering": false,
					"subscriptions": []map[string]interface{}{
						{
							"name": "test-subscription",
							"rules": []map[string]interface{}{
								{
									"name": "test-rule",
									"filter_type": "SqlFilter",
									"sql_filter": map[string]interface{}{
										"sql_expression": "1=1",
									},
								},
							},
							"max_delivery_count": 10,
							"lock_duration": "PT5M",
							"dead_lettering_on_message_expiration": false,
							"dead_lettering_on_filter_evaluation_error": true,
							"default_message_ttl": "P14D",
							"requires_session": false,
							"status": "Active",
						},
					},
				},
			},

			// Namespace authorization rules
			"namespace_authorization_rules": []map[string]interface{}{
				{
					"name": "test-namespace-rule",
					"listen": true,
					"send": true,
					"manage": false,
				},
			},

			// Disable enterprise features for test
			"enable_network_rules": false,
			"enable_private_endpoint": false,
			"enable_diagnostic_settings": false,
			"enable_policy_assignments": false,
			"enable_custom_policies": false,
			"enable_policy_initiative": false,
			"enable_resource_lock": false,
		},

		NoColor: true,
	}

	// Clean up resources in the end
	defer terraform.Destroy(t, terraformOptions)
	defer azure.DeleteResourceGroupE(t, resourceGroupName)

	// Create resource group
	azure.CreateResourceGroupE(t, resourceGroupName, location)

	// Deploy Service Bus namespace
	terraform.InitAndApply(t, terraformOptions)

	// Test Service Bus namespace exists and is configured correctly
	namespace := azure.GetServiceBusNamespaceE(t, resourceGroupName, namespaceName)
	assert.NotNil(t, namespace, "Service Bus namespace should exist")
	assert.Equal(t, namespaceName, *namespace.Name, "Service Bus namespace name should match")
	assert.Equal(t, "Standard", *namespace.Sku.Name, "SKU should match")

	// Test outputs
	namespaceId := terraform.Output(t, terraformOptions, "servicebus_namespace_id")
	assert.NotEmpty(t, namespaceId, "Service Bus namespace ID should not be empty")

	namespaceNameOutput := terraform.Output(t, terraformOptions, "servicebus_namespace_name")
	assert.Equal(t, namespaceName, namespaceNameOutput, "Service Bus namespace name should match")

	// Test queues
	queues := terraform.OutputMap(t, terraformOptions, "servicebus_queues")
	assert.Contains(t, queues, "test-queue", "Should contain test-queue")

	// Test topics
	topics := terraform.OutputMap(t, terraformOptions, "servicebus_topics")
	assert.Contains(t, topics, "test-topic", "Should contain test-topic")

	// Test subscriptions
	subscriptions := terraform.OutputMap(t, terraformOptions, "servicebus_subscriptions")
	assert.Contains(t, subscriptions, "test-subscription", "Should contain test-subscription")

	// Test authorization rules
	namespaceAuthRules := terraform.OutputMap(t, terraformOptions, "servicebus_namespace_auth_rules")
	assert.Contains(t, namespaceAuthRules, "test-namespace-rule", "Should contain namespace auth rule")

	queueAuthRules := terraform.OutputMap(t, terraformOptions, "servicebus_queue_auth_rules")
	assert.Contains(t, queueAuthRules, "test-queue-rule", "Should contain queue auth rule")

	topicAuthRules := terraform.OutputMap(t, terraformOptions, "servicebus_topic_auth_rules")
	assert.Contains(t, topicAuthRules, "test-topic-rule", "Should contain topic auth rule")

	// Test identity configuration
	identity := terraform.Output(t, terraformOptions, "servicebus_identity")
	assert.NotNil(t, identity, "Identity should be configured")

	managedIdentityEnabled := terraform.Output(t, terraformOptions, "servicebus_managed_identity_enabled")
	assert.Equal(t, "true", managedIdentityEnabled, "Managed identity should be enabled")

	// Test SKU and capacity
	sku := terraform.Output(t, terraformOptions, "servicebus_sku")
	assert.Equal(t, "Standard", sku, "SKU should match")

	capacity := terraform.Output(t, terraformOptions, "servicebus_capacity")
	assert.Equal(t, "1", capacity, "Capacity should match")
}

func TestServiceBusPremium(t *testing.T) {
	t.Parallel()

	// Generate unique names
	uniqueId := random.UniqueId()
	location := "East US"
	resourceGroupName := fmt.Sprintf("rg-sb-premium-test-%s", uniqueId)
	namespaceName := fmt.Sprintf("sb-premium-test-%s", uniqueId)

	// Terraform options
	terraformOptions := &terraform.Options{
		TerraformDir: "../",

		Vars: map[string]interface{}{
			"resource_group_name": resourceGroupName,
			"location": location,
			"location_short": "eus",
			"environment": "test",
			"custom_name": strings.Replace(namespaceName, "sb-premium-test-", "", 1),

			// Premium SKU configuration
			"sku": "Premium",
			"capacity": 2,
			"premium_messaging_partitions": 2,
			"minimum_tls_version": "1.2",

			// Identity
			"enable_managed_identity": true,

			// Queues with partitioning
			"queues": []map[string]interface{}{
				{
					"name": "premium-queue",
					"max_size_in_megabytes": 2048,
					"requires_duplicate_detection": true,
					"duplicate_detection_history_time_window": "PT15M",
					"max_delivery_count": 5,
				},
			},

			// Topics with partitioning
			"topics": []map[string]interface{}{
				{
					"name": "premium-topic",
					"max_size_in_megabytes": 2048,
					"requires_duplicate_detection": true,
					"duplicate_detection_history_time_window": "PT15M",
					"subscriptions": []map[string]interface{}{
						{
							"name": "premium-subscription",
							"max_delivery_count": 5,
							"requires_session": true,
						},
					},
				},
			},

			// Disable other features for test
			"enable_network_rules": false,
			"enable_private_endpoint": false,
			"enable_diagnostic_settings": false,
			"enable_policy_assignments": false,
			"enable_custom_policies": false,
			"enable_policy_initiative": false,
			"enable_resource_lock": false,
		},

		NoColor: true,
	}

	// Clean up resources in the end
	defer terraform.Destroy(t, terraformOptions)
	defer azure.DeleteResourceGroupE(t, resourceGroupName)

	// Create resource group
	azure.CreateResourceGroupE(t, resourceGroupName, location)

	// Deploy Service Bus namespace
	terraform.InitAndApply(t, terraformOptions)

	// Test Premium SKU configuration
	namespace := azure.GetServiceBusNamespaceE(t, resourceGroupName, namespaceName)
	assert.NotNil(t, namespace, "Service Bus namespace should exist")
	assert.Equal(t, "Premium", *namespace.Sku.Name, "SKU should be Premium")
	assert.Equal(t, int32(2), *namespace.Sku.Capacity, "Capacity should be 2")

	// Test outputs
	sku := terraform.Output(t, terraformOptions, "servicebus_sku")
	assert.Equal(t, "Premium", sku, "SKU should match")

	capacity := terraform.Output(t, terraformOptions, "servicebus_capacity")
	assert.Equal(t, "2", capacity, "Capacity should match")
}

func TestServiceBusValidation(t *testing.T) {
	t.Parallel()

	// Test invalid SKU
	t.Run("InvalidSKU", func(t *testing.T) {
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"resource_group_name": "rg-test",
				"location": "East US",
				"location_short": "eus",
				"environment": "test",
				"custom_name": "test",
				"sku": "Invalid",
			},
			NoColor: true,
		}

		_, err := terraform.InitAndPlanE(t, terraformOptions)
		require.Error(t, err, "Should fail with invalid SKU")
		assert.Contains(t, err.Error(), "invalid", "Error should mention invalid SKU")
	})

	// Test invalid capacity
	t.Run("InvalidCapacity", func(t *testing.T) {
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"resource_group_name": "rg-test",
				"location": "East US",
				"location_short": "eus",
				"environment": "test",
				"custom_name": "test",
				"sku": "Premium",
				"capacity": 20, // Invalid capacity
			},
			NoColor: true,
		}

		_, err := terraform.InitAndPlanE(t, terraformOptions)
		require.Error(t, err, "Should fail with invalid capacity")
		assert.Contains(t, err.Error(), "invalid", "Error should mention invalid capacity")
	})

	// Test invalid TLS version
	t.Run("InvalidTLSVersion", func(t *testing.T) {
		terraformOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"resource_group_name": "rg-test",
				"location": "East US",
				"location_short": "eus",
				"environment": "test",
				"custom_name": "test",
				"minimum_tls_version": "0.9",
			},
			NoColor: true,
		}

		_, err := terraform.InitAndPlanE(t, terraformOptions)
		require.Error(t, err, "Should fail with invalid TLS version")
		assert.Contains(t, err.Error(), "invalid", "Error should mention invalid TLS version")
	})
}