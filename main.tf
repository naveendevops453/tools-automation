module "tools" {
  for_each = var.tools
  source = "./module"
  name  = var.tools["name"]
  instance_type = each.value["instance_type"]
}

