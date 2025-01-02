# These are SAMPLE RULES - MODIFY them based on your requirement.

test_rules = [
  # ALLOW IP SET
  {
    action                         = "Allow"
    enabled                        = true
    name                           = "AllowedIPs"
    priority                       = 101
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 100
    type                           = "MatchRule"
    match_conditions = [
      {
        match_values       = ["8.8.8.8", "1.1.1.1"]
        match_variable     = "RemoteAddr"
        negation_condition = false
        operator           = "IPMatch"
        transforms         = []
      }
    ]
  },
  # ALLOW GEOGRAPHY SET
  {
    action                         = "Allow"
    enabled                        = true
    name                           = "AllowedCountries"
    priority                       = 102
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 100
    type                           = "MatchRule"
    match_conditions = [
      {
        match_values       = ["CA", "US"]
        match_variable     = "SocketAddr"
        negation_condition = false
        operator           = "GeoMatch"
        transforms         = []
      }
    ]
  },
  # ALLOW traffic to URLs from specific sources
  {
    action                         = "Allow"
    enabled                        = true
    name                           = "UrlOnly"
    priority                       = 103
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 100
    type                           = "MatchRule"
    match_conditions = [
      {
        match_values       = ["www.github.com", "www.linkedin.com"]
        match_variable     = "RequestUri"
        negation_condition = false
        operator           = "Contains"
        transforms         = []
      },
      {
        match_values       = ["CA", "US", "IN", "GB"]
        match_variable     = "SocketAddr"
        negation_condition = false
        operator           = "GeoMatch"
        transforms         = []
      },
      { 
        match_values       = ["8.8.8.8","10.0.0.0/24"]
        match_variable     = "RemoteAddr"
        negation_condition = false
        operator           = "IPMatch"
        transforms         = []
      },
    ]
  },
  # BLOCK IP SET
  {
    action                         = "Block"
    enabled                        = true
    name                           = "BlockedIPs"
    priority                       = 104
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 100
    type                           = "MatchRule"
    match_conditions = [
      {
        match_values       = ["201.201.201.201"]
        match_variable     = "RemoteAddr"
        negation_condition = false
        operator           = "IPMatch"
        transforms         = []
      }
    ]
  },
  # Block GEOGRAPHY SET
  {
    action                         = "Block"
    enabled                        = true
    name                           = "BlockedCountries"
    priority                       = 105
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 100
    type                           = "MatchRule"
    match_conditions = [
      {
        match_values       = ["CN", "RU"]
        match_variable     = "SocketAddr"
        negation_condition = false
        operator           = "GeoMatch"
        transforms         = []
      }
    ]
  },
]