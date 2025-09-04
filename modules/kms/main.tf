resource "aws_kms_key" "ruby-dev-mykey" {
  description             = "This key is used to encrypt"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}
