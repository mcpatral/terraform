resource "aws_key_pair" "utc-key" {
   key_name   = "utc-key"
   public_key = file("utc-key.pub")
}
resource "aws_instance" "bastion-host" {
  ami               = var.AMIS[var.REGION]
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.utc-key.id
  availability_zone = var.ZONE1
  security_groups   = [aws_security_group.Bastion.id]
  subnet_id         = var.PubSub1.id


  tags = {
    env  = "Dev"
    team = "config management"
  }
}
