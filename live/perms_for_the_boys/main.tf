module "roles_for_the_boys" {
  source          = "../../modules/asg_iam"

  role_name       = "the-boys-role"
  profile_name    = "the-boys-profile"
  trusted_entity  = "ec2.amazonaws.com"
}