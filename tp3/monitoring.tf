# monitoring.tf

resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.resource_group_name}-alerts"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "vm-alerts"

  email_receiver {
    name          = "admin"
    email_address = var.alert_email_address
  }
}

# espace disque

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "vm2" {
  name                = "disque-70-prcnt"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  scopes              = [azurerm_linux_virtual_machine.vm2.id]

  evaluation_frequency = "PT5M"
  window_duration      = "PT10M"
  severity             = 2
  enabled              = true

  criteria {
    query = <<-KQL
      InsightsMetrics
      | where Origin == "vm.azm.ms"
      | where Namespace == "LogicalDisk" and Name == "FreeSpacePercentage"
      | extend t = todynamic(Tags)
      | extend Disk = coalesce(
          tostring(t["vm.azm.ms/mountId"]),
          tostring(t["vm.azm.ms/disk"]),
          tostring(t["device"])
        )
      | summarize UsedPct = 100.0 - avg(Val)
          by bin(TimeGenerated, 5m), _ResourceId, Disk
      | where UsedPct >= 90
    KQL
    time_aggregation_method = "Count"
    operator         = "GreaterThan"
    threshold        = 0
    failing_periods {
      number_of_evaluation_periods     = 1
      minimum_failing_periods_to_trigger_alert = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.main.id]
  }
}

# CPU Metric Alert

resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "cpu-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes = [azurerm_linux_virtual_machine.vm1.id]
  description         = "Alert when CPU usage exceeds 70%"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }

  window_size   = "PT5M"
  frequency     = "PT1M"
  auto_mitigate = true

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# RAM Metric Alert
resource "azurerm_monitor_metric_alert" "ram_alert" {
  name                = "ram-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes = [azurerm_linux_virtual_machine.vm1.id]
  description         = "Less than 512Mo available"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 512000000
  }

  window_size   = "PT5M"
  frequency     = "PT1M"
  auto_mitigate = true

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# Monitoring port MYSQL
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "port_3306_alert" {
  name                = "port-3306-not-reachable"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  scopes              = [azurerm_linux_virtual_machine.vm2.id]

  evaluation_frequency = "PT5M"
  window_duration      = "PT10M"
  severity             = 2
  enabled              = true

  criteria {
    query = <<-KQL
      VMConnection
      | where TimeGenerated > ago(10m)
      | where DestinationPort == 3306
      | summarize ConnectionCount = count() by bin(TimeGenerated, 5m), _ResourceId, DestinationPort
      | where ConnectionCount == 0
    KQL
    time_aggregation_method = "Count"
    operator        = "GreaterThan"
    threshold       = 0
    failing_periods {
      number_of_evaluation_periods           = 1
      minimum_failing_periods_to_trigger_alert = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.main.id]
  }
}


# Monitoring service MYSQL
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "mysql_service_alert" {
  name                = "mysql-service-not-running"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  scopes              = [azurerm_linux_virtual_machine.vm2.id]

  evaluation_frequency = "PT5M"
  window_duration      = "PT10M"
  severity             = 2
  enabled              = true

  criteria {
    query = <<-KQL
      Perf
      | where ObjectName == "Process" and CounterName == "Working Set" and InstanceName contains "mysqld"
      | summarize ProcessCount = count() by bin(TimeGenerated, 5m), _ResourceId
      | where ProcessCount == 0
    KQL
    time_aggregation_method = "Count"
    operator        = "GreaterThan"
    threshold       = 0
    failing_periods {
      number_of_evaluation_periods           = 1
      minimum_failing_periods_to_trigger_alert = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.main.id]
  }
}
