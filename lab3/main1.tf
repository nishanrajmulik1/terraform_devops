variable "raw_user_data" {
  description = "A messy, comma-separated list of new hires"
  type        = string
  default     = "Mula, Gula, Bula, Dula"
}

locals {
  # 1. split(",", ...) turns the string into a list: ["Alice", " BOB", " charlie.brown ", " DAVE "]
  # 2. We use a for loop to iterate over that list.
  # 3. trimspace() removes leading/trailing spaces.
  # 4. lower() converts everything to lowercase.
  clean_user_list = [
    for user in split(",", var.raw_user_data) : lower(trimspace(user))
  ]
}

resource "aws_iam_user" "new_hires" {
  # toset() is required because for_each only accepts maps or sets of strings
  for_each = toset(local.clean_user_list)
  
  name = each.value
}

output "processed_users" {
  description = "The cleaned list of user accounts created"
  value       = local.clean_user_list
}
