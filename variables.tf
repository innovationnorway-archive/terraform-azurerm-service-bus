variable "name" {
  type        = string
  description = "The name of the namespace."
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group."
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of the namespace. The options are: `Basic`, `Standard`, `Premium`."
}

variable "capacity" {
  type        = number
  default     = 0
  description = "The number of message units."
}

variable "topics" {
  type        = any
  default     = []
  description = "List of topics."
}

variable "authorization_rules" {
  type        = any
  default     = []
  description = "List of namespace authorization rules."
}

variable "zone_redundant" {
  type        = bool
  default     = false
  description = "(Optional) Whether or not this resource is zone redundant. sku needs to be Premium. Defaults to false."
}

variable "queues" {
  type        = any
  default     = []
  description = "List of queues."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = " Map of tags to assign to the resources."
}

locals {
  authorization_rules = [
    for rule in var.authorization_rules : merge({
      name   = ""
      rights = []
    }, rule)
  ]

  default_authorization_rule = {
    name                        = "RootManageSharedAccessKey"
    primary_connection_string   = azurerm_servicebus_namespace.main.default_primary_connection_string
    secondary_connection_string = azurerm_servicebus_namespace.main.default_secondary_connection_string
    primary_key                 = azurerm_servicebus_namespace.main.default_primary_key
    secondary_key               = azurerm_servicebus_namespace.main.default_secondary_key
  }

  topics = [
    for topic in var.topics : merge({
      name                       = ""
      status                     = "Active"
      auto_delete_on_idle        = null
      default_message_ttl        = null
      enable_batched_operations  = null
      enable_express             = null
      enable_partitioning        = null
      max_size                   = null
      enable_duplicate_detection = null
      enable_ordering            = null
      authorization_rules        = []
      subscriptions              = []

      duplicate_detection_history_time_window = null
    }, topic)
  ]

  topic_authorization_rules = flatten([
    for topic in local.topics : [
      for rule in topic.authorization_rules : merge({
        name   = ""
        rights = []
        }, rule, {
        topic_name = topic.name
      })
    ]
  ])

  topic_subscriptions = flatten([
    for topic in local.topics : [
      for subscription in topic.subscriptions :
      merge({
        name                      = ""
        auto_delete_on_idle       = null
        default_message_ttl       = null
        lock_duration             = null
        enable_batched_operations = null
        max_delivery_count        = null
        enable_session            = null
        forward_to                = null
        rules                     = []

        enable_dead_lettering_on_message_expiration = null
        }, subscription, {
        topic_name = topic.name
      })
    ]
  ])

  topic_subscription_rules = flatten([
    for subscription in local.topic_subscriptions : [
      for rule in subscription.rules : merge({
        name       = ""
        sql_filter = ""
        action     = ""
        }, rule, {
        topic_name        = subscription.topic_name
        subscription_name = subscription.name
      })
    ]
  ])

  queues = [
    for queue in var.queues : merge({
      name                       = ""
      auto_delete_on_idle        = null
      default_message_ttl        = null
      enable_express             = false
      enable_partitioning        = false
      lock_duration              = null
      max_size                   = null
      enable_duplicate_detection = false
      enable_session             = false
      max_delivery_count         = 10
      authorization_rules        = []

      enable_dead_lettering_on_message_expiration = false
      duplicate_detection_history_time_window     = null
    }, queue)
  ]

  queue_authorization_rules = flatten([
    for queue in local.queues : [
      for rule in queue.authorization_rules : merge({
        name   = ""
        rights = []
        }, rule, {
        queue_name = queue.name
      })
    ]
  ])
}
