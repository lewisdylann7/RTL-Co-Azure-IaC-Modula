module "networking" {
    source = "./modules/networking"
    prefix = var.prefix
    location = var.location
}

module "security" {
    source = "./modules/security"
    location = var.location
    prefix = var.prefix
    admin_password = var.admin_password
    vm_principal_id = module.compute.vm_principal_id
}


module "data" {
    source = "./modules/data"
    location = var.location
    prefix = var.prefix
    admin_password = var.admin_password
    db_subnet_id = module.networking.db_subnet_id
  
}

module "compute" {
    source = "./modules/compute"
    prefix = var.prefix
    location = var.location
    admin_password = module.security.key_vault_secret_value
    subnet_id = module.networking.subnet_id
}



