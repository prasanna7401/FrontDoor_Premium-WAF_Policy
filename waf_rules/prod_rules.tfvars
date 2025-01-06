prod_rules = [
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
        match_values       = [
          "8.8.8.8", "1.1.1.1", "100.100.100.100"
          ]
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
        match_values       = [
          "CA", "US"
          ]
        match_variable     = "SocketAddr"
        negation_condition = false
        operator           = "GeoMatch"
        transforms         = []
      }
    ]
  },
]