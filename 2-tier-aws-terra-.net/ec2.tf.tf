resource "aws_instance" "dotnet_server" {
  ami           = "ami-0aa31b568c1e8d622" # Amazon Linux 2023 (change if needed)
  instance_type = "t3.micro"
  key_name      = var.key_name

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

   user_data = templatefile("${path.module}/userdata.sh", {
    DB_HOST     = aws_db_instance.mysql.address
    DB_USER     = var.username
    DB_PASSWORD = var.password
  })

  tags = {
    Name = "Dotnet-App-Server"
  }
}
