# Azure Service bus

Create Service Bus in Azure.

## Example Usage

### Topics

```hcl
resource "azurerm_resource_group" "main" {
  name     = "example-resources"
  location = "westeurope"
}

module "service_bus" {
  source = "innovationnorway/service-bus/azurerm"

  name = "example"

  resource_group_name = azurerm_resource_group.main.name

  topics = [
    {
      name = "example"
      enable_partitioning = true
      authorization_rules = [
        {
          name   = "example"
          rights = ["listen", "send"]
        }
      ]
    }
  ]
}
```

### Queues

```hcl
resource "azurerm_resource_group" "main" {
  name     = "example-resources"
  location = "westeurope"
}

module "service_bus" {
  source = "innovationnorway/service-bus/azurerm"

  name = "example"

  resource_group_name = azurerm_resource_group.main.name

  queues = [
    {
      name = "example"
      authorization_rules = [
        {
          name   = "example"
          rights = ["listen", "send"]
        }
      ]
    }
  ]
}
```

### Forwarding (Topic subscriptions)

```hcl
resource "azurerm_resource_group" "main" {
  name     = "example-resources"
  location = "westeurope"
}

module "service_bus" {
  source = "innovationnorway/service-bus/azurerm"

  name = "example"

  resource_group_name = azurerm_resource_group.main.name

  topics = [
    {
      name = "source"
      enable_partitioning = true
      subscriptions = [
        {
          name = "example"
          forward_to = "destination"
          max_delivery_count = 1
        }
      ]
    },
    {
      name = "destination"
      enable_partitioning = true
    }
  ]
}
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | The name of the namespace. |
| `resource_group_name` | `string` | The name of an existing resource group. |
| `sku` | `string` | The SKU of the namespace. The options are: `Basic`, `Standard`, `Premium`. Default: `Standard`. |
| `capacity` | `number` | The number of message units. The options are: `1`, `2`, `4`. |
| `zone_redundant` | `bool` | (Optional) Whether or not this resource is zone redundant. sku needs to be `Premium`. Defaults to `false`. |
| `authorization_rules` | `list` | List of namespace authorization rules. |
| `topics` | `list` | List of `topics`. |
| `queues` | `list` | List of `queues`. |
| `tags` | `map` | Map of tags to assign to the resources. |

The `authorization_rules` object must have the following keys:

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | The name of the authorization rule. |
| `rights` | `list` | List of authorization rule rights. The options are: `listen`, `send` and `manage`. |

The `topics` object accepts the following keys:

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | **Required**. The name of the topic. |
| `status` | `string` | The status of the topic. The options are: `Active` and `Disabled`. Default: `Active`. |
| `auto_delete_on_idle` | `string` | ISO 8601 timespan duration for idle interval after which the topic is automatically deleted. |
| `default_message_ttl` | `string` | ISO 8601 timespan duration for default message time to live value. |
| `duplicate_detection_history_time_window` | `string` | ISO 8601 timespan duration that defines the duration of the duplicate detection history. |
| `enable_batched_operations` | `bool` | Allow server-side batched operations. |
| `enable_express` | `bool` | Enable Express Entities. |
| `enable_partitioning` | `bool` | Whether the topic is partitioned across multiple message brokers. |
| `max_size` | `number` | Maximum size of topic in megabytes, which is the size of the memory allocated for the topic. | 
| `enable_duplicate_detection` | `bool` | Whether the topic requires duplicate detection. |
| `enable_ordering` | `bool` | Whether the topic supports ordering. |
| `authorization_rules` | `list` | List of topic authorization rules. |
| `subscriptions` | `list` | List of topic subscriptions. |

The `subscriptions` object accepts the following keys:

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | **Required**. The name of the subscription. |
| `auto_delete_on_idle` | `string` | ISO 8601 timespan duration for idle interval after which the topic is automatically deleted. |
| `default_message_ttl` | `string` | ISO 8601 timespan duration for default message timespan to live value. |
| `lock_duration` | `string` | ISO 8601 timespan duration for lock duration timespan for the subscription. |
| `enable_batched_operations` | `bool` | Allow server-side batched operations. |
| `max_delivery_count` | `number` | The number of maximum deliveries. |
| `enable_session` | `bool` | Whether the subscription supports the concept of sessions. |
| `forward_to` | `string` | The queue or topic name to forward the messages to. |
| `enable_dead_lettering_on_message_expiration` | `bool` | Whether a subscription has dead letter support when a message expires. |
| `rules` | `list` | List of subscription rules. |

The `rules` object accepts the following keys:

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | **Required**. The name of the topic subscription rule. |
| `sql_filter` | `string` | The filter SQL expression. |
| `action` | `string` | The action SQL expression. |

The `queues` object accepts the following keys:

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | **Required**. The name of the queue. |
| `auto_delete_on_idle` | `string` | ISO 8601 timespan duration for idle interval after which the queue is automatically deleted. |
| `default_message_ttl` | `string` | ISO 8601 timespan duration for default message to live value. |
| `enable_express` | `bool` | Whether Express Entities are enabled.  |
| `enable_partitioning` | `bool` | Whether the queue is to be partitioned across multiple message brokers. |
| `lock_duration` | `string` | ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. |
| `max_size` | `string` | Maximum size of queue in megabytes, which is the size of the memory allocated for the queue. |
| `enable_duplicate_detection` | `bool` | Whether this queue requires duplicate detection. |
| `enable_session` | `bool` | Whether the queue supports the concept of sessions. |
| `max_delivery_count` | `number` | The maximum delivery count. A message is automatically deadlettered after this number of deliveries. |
| `enable_dead_lettering_on_message_expiration` | `bool` | Whether this queue has dead letter support when a message expires. |
| `duplicate_detection_history_time_window` | `string` | ISO 8601 timespan duration that defines the duration of the duplicate detection history. |
| `authorization_rules` | `list` | List of queue authorization rules. |
