###########################################
################## AWS ####################
###########################################

provider "aws" {

    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
  
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

###########################################
############# Confluent Cloud #############
###########################################

variable "ccloud_broker_list" {}

variable "ccloud_access_key" {}

variable "ccloud_secret_key" {}

###########################################
################## Others #################
###########################################

variable "global_prefix" {

    default = "current-identity"
    
}

variable "alexa_skill_id" {}

variable "twitter_oauth_access_token" {}
variable "twitter_oauth_access_token_secret" {}
variable "twitter_oauth_consumer_key" {}
variable "twitter_oauth_consumer_secret" {}