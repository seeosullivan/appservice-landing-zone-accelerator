output "result" {
  value = azurecaf_name.this.result
}

output "results" {
  value = azurecaf_name.this.results
}

output "location" {
  value = var.location
}

output "id" {
  value = azurecaf_name.this.id
}

output "tags" {
  value = local.additional_tags
}
