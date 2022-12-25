                Tickets / User story

1- There is a new app that need to be hosts in aws called utc 

create a vpc for it with below attributes:

region = us-east-1

AZs = 1a and 1b

public subnet = 2

private subnet = 4

nat gateway = 2 

Internet gateway = true

cidr_block = 10.10.0.0/16

tags {

   Name = utc-vpc

   env  = dev

   team = “config management”

}

2- The utc app app needs to span across 3 AZS 

Go ahead and add another public subnet in 1c

and two extra private subnet in 1c as well

3- for the utc app , we need 4 security group for all the tiers 

go ahead and Create 4 security groups as follow:

==> alb sg {

Allow inbound from everywhere to 80 and 443 port ( http and https protocols)

Allow all outbound

tags: {

  env: dev

  team = “config management”

}

}

==>bation-host-sg {

Allow inbound my ip to 22 ( ssh protocol)

Allow all outbound

tags: {

  env: dev

  team = “config management”

}

}

==>app-server sg {

Allow inbound from alb sg to 80 ( http protocol)

Allow inbound from bastion-host-sg to 22 ( ssh protocol)

Allow all outbound

tags: {

  env: dev

  team = “config management”

}

}

==>database-sg {

Allow inbound from aps-server sg to 3306 ( mysql protocol)

Allow all outbound

tags: {

  env: dev

  team = “config management”

}

}

4- this infrastructure will need a keypair called utc-key

Go ahead and create it. please make sure it has the extension .pem

5– We will have a server in the private subnet with no ssh access. go ahead and create a bastion host, copy the key pair ( utc-key) to it so we can access the private server.

remember to change the permission on the key to 400

NB: use the bastion sg for this server.

tags: {

  env: dev

  team = “config managment”

}

6- we need 2 ec2 in each availability zone go ahead and create those servers with below specs:

instance type: t2 micro

AZs : private 1a and 1b

sg: app-server sg

ami: amazon linux 2

key_name : utc-key

vpc : utc-vpc

user data: 

#!/bin/bash

yum update -y

yum install -y httpd.x86_64

systemctl start httpd.service

systemctl enable httpd.service

echo “Hello World from $(hostname -f)” > /var/www/html/index.html

tags: {

  Name: appserver-1a /appserver-1b

  env: dev

  team = “config management”

}

7- run some testing to make sure from the bation host we can ssh to these ec2 in private 1a and 1b

also make sure that apache is running and able to render content.

8- Create a target group for the load balancer. with below specs:

target group name: utc-target-group

target type: instances

target: both app servers in the private subnet

protocol: http

port : 80

vpc : utc-vpc

protocol version: http1

health check: {

     protocol: http

     path: /

}

tags: {

  env: dev

  team = “config management”

}

9- Create a hosted zone in aws with our domain, or register a new domain in route 53

task:

check with the config management team if a domain exists or if we need to create one from scratch. ( as we already have a hosted zone in aws and we just need a subdomain called learning.yourdomain)

task: 

 -make sure we have a hosted zone in any case.

10- request a certification if not available already so we can use https protocol as follow:

certificate type: public

fully qualified domain: *.yourdomain ( this will create a certificate for any subsequent subdomain.)

11- We need to create a load balancer. ( ALB)

listener: port 80

targetgroup: utc-target-group

12- we need the database RDS mysql ( fully managed by AWS)

database: utc-dev-database

username: utcuser

password: utcdev12345

13- Create an IAM role to give access from ec2 to s3 bucket

14- create an efs volume and attach it to both app-servers.

15- create a cron job in the appserver to upload the httpd log files into s3 bucket.

16- Create an ami from any of the app-server so we don’t have to repeat the setup on the next ec2 launch. call it utcappserver

17- create a lunch template for our auto scaling with bellow specs:

instance type: t2.micro

ami: utcappserver

sg: app-server sg

vpc: utc-vpc

key_name: utc-key

18- create an auto scaling group for utc-target-group with dynamic acalling base on cpu utilisation.

we should scale out when cpu reach 80 and scale back in wgen cpu goes down.

19- create a topic in sns service called utc-auto-scaliing. also create a subscription for that topic with the team email and make it configure autoscaling notification using that topic.