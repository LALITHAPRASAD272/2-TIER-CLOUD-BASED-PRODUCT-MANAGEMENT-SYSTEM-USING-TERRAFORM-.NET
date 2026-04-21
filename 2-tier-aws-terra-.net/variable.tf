variable "key_name" {
  description = "EC2 Key Pair Name"
  default = "prasad-key"
}
variable "password" {
  default = "Admin1234!"
  description = "RDS Master Password"
  
}
variable "db_name" {
  default = "studentdb"
  description = "RDS Database Name"
  
}
variable "username" {
  default = "admin"
  description = "RDS Master Username"
  
}