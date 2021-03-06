 #
 # An instance in the VPC used to do development work on server provisioning
 # 

resource "aws_security_group" "devhost" 
{
  name = "devhost_ingress"
  description = "SSH in from anywhere"
  vpc_id = "${aws_vpc.logserver_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 9200
    to_port = 9200
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 9292
    to_port = 9292
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 9300
    to_port = 9300
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "devhost" {
	ami = "${lookup(var.amazon_linux_amis, var.aws_region)}"
    instance_type = "m1.small"
    associate_public_ip_address = true
    subnet_id = "${aws_subnet.logserver_subnet1.id}"
    security_groups = [ "${aws_security_group.devhost.id}" ]
  	key_name = "${var.key_name}"
  	user_data = "${file("./data/devhost.userdata")}"
}

output "devhost_address" {
  value = "${aws_instance.devhost.public_dns}"
}

