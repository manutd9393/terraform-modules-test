variable "resource_groups" {
  description = "A map of Resource Groups to be created"
  type = map(object({
    name     = string
    location = string
  }))
}
