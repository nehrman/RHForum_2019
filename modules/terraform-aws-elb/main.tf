resource "aws_lb" "lb_new" {
    name = 
    name_prefix = 
    internal = 
    load_balancer_type =
    idle_timeout = 
    enable_deletion_protection = 
    enable_cross_zone_load_balancing = 
    ip_address_type =  
    
    access_log {
        bucket = 
        prefix = 
        enabled = 
    }

    subnet_mapping {
        subnet_id = 
        allocation_id = 
    }
}

resource "aws_lb_listener" "lb_new" {

}