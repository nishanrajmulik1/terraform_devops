# # Define the variable for the environment
# variable "environment" {
#   description = "The environment for the instance"
#   type        = string
#   default     = "dev"
# }

# # Variable sets
# variable "departments" {
#     type = set(string)
#     default = ["finance", "engineering", "hr"]
# }

variable "raw_user_data" {
  description = "A messy, comma-separated list of new hires"
  type        = string
  default     = "Mula, Gula, Bula, Dula"
}


#prefix = "nr-dev" or "nr-prod"
#nr-dev-hr-data-2026
#nr-prod-hr-data-2026

locals{
    # bucket_prefix = var.environment=="prod"?"nr-prod":"nr-dev"
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

# resource "aws_s3_bucket" "departments" {
#     for_each = var.departments
#     bucket = "${local.bucket_prefix}-${each.value}-data-2026"
#     tags = {
#         env = upper(var.environment)
#         Name = "${local.bucket_prefix}-${each.value}-data-2026"
#     }
# }

# output "all_buckets" {
#     value = [for i in aws_s3_bucket.departments:i.bucket]
# }

output "processed_users" {
  description = "The cleaned list of user accounts created"
  value       = local.clean_user_list
}
