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
    ami = "${lookup(var.amis, var.chef-server)}"
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