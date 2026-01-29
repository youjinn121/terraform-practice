#!/bin/bash

curl $(terraform output -raw  alb_dns_name):1234