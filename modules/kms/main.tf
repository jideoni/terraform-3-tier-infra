resource "aws_kms_key" "ruby-dev-mykey" {
  description             = "This key is used to encrypt"
  enable_key_rotation     = true
  is_enabled              = true
  rotation_period_in_days = 91
  deletion_window_in_days = 10
}
