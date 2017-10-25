resource "aws_security_group" "chef-server" {
    name = "vpc_chef-server"
    description = "Allow SSH in to Chef Server, HTTP/S access out."

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.chef-vpc.id}"

    tags {
        Name = "ChefServer_SecurityGroup"
    }
}

resource "aws_instance" "chef-server" {
    ami = "${var.amis["chef-server"]}"
    availability_zone = "us-east-1a"
    instance_type = "t2.large"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.chef-server.id}"]
    subnet_id = "${aws_subnet.us-east-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "Chef Server"
    }
}

resource "aws_eip" "chef-server-eip" {
  vpc = true
  instance                  = "${aws_instance.chef-server.id}"
  associate_with_private_ip = "${aws_instance.chef-server.private_ip}"
}

resource "aws_instance" "chef-node1" {
    ami = "${var.amis["chef-node"]}"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.chef-server.id}"]
    subnet_id = "${aws_subnet.us-east-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "Chef Node 1"
    }
}

resource "aws_eip" "chef-node1-eip" {
  vpc = true
  instance                  = "${aws_instance.chef-node1.id}"
  associate_with_private_ip = "${aws_instance.chef-node1.private_ip}"
}

resource "aws_instance" "chef-node2" {
    ami = "${var.amis["chef-node"]}"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.chef-server.id}"]
    subnet_id = "${aws_subnet.us-east-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "Chef Node 2"
    }
}

resource "aws_eip" "chef-node2-eip" {
  vpc = true
  instance                  = "${aws_instance.chef-node2.id}"
  associate_with_private_ip = "${aws_instance.chef-node2.private_ip}"
}
