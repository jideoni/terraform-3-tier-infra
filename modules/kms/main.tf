resource "aws_kms_key" "ruby-dev-mykey" {
  description             = "This key is used to encrypt"
  enable_key_rotation     = true
  is_enabled              = true
  rotation_period_in_days = 91
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "ruby_dev_key_alias" {
  name          = var.alias
  target_key_id = aws_kms_key.ruby-dev-mykey.key_id
}
