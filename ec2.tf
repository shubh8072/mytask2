provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA2YIADDJHUMVFKPEF"
  secret_key = "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"
}
resource "aws_instance" "os4" {
  ami = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
key_name = "shubham0"
security_groups=["serviceSG"]
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("C:/Users/Shailendra Gupta/Downloads/shubham0.pem")
    host     = aws_instance.os4.public_ip
  } 
provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd php git -y",
      "sudo yum install -y amazon-efs-utils",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",
      "sudo git clone https://github.com/shubh8072/shubham123.git /var/www/html"    
]
  }

  tags = {
    Name = "HelloWorld3"
  }
}
output "op3"{
value=aws_instance.os4.public_ip
}
resource "aws_efs_file_system" "foo" {
  creation_token = "my-product"

  tags = {
    Name = "MyProduct"
  }
}
resource "aws_efs_mount_target" "alpha" {
  file_system_id = "${aws_efs_file_system.foo.id}"
  subnet_id      = "${aws_instance.os4.subnet_id}"
}
resource "null_resource" "null1" {

	depends_on = [
		aws_efs_mount_target.alpha
	]
	connection {
                type = "ssh"
                user = "ec2-user"
                private_key = file("C:/Users/Shailendra Gupta/Downloads/shubham0.pem")
                host = aws_instance.os4.public_ip
        }


        provisioner "remote-exec" {
                inline = [
     
                        "sudo mount ${aws_efs_file_system.foo.id}:/ /var/www/html",
			"sudo rm -rf /var/www/html/*",
                        "sudo git clone https://github.com/shubh8072/shubham123.git /var/www/html"
                ]
        }
}