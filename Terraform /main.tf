module "cluster"{
    source = "./modules/cluster"
}
module "app" {
  source = "./modules/app"
  default_cluster = module.cluster.default_cluster
}
module "vm" {
    source = "./modules/vm"
  
}