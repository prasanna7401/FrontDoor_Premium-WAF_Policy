waf_name = "<your-waf-name>"
fd_name  = "<your-fd-name>"

resource_group = "<your-resource-group>"
location       = "<your-location>"

tags = {
  deployment_type = "terraform-managed"
  environment     = "test" # Update as required
}

waf_mode = "Prevention" # or Detection