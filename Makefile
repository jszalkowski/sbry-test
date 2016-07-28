#!/bin/bash

create: ## 
		ssh-keygen -q -t rsa -f ~/.ssh/sbry -N '' -C sbry
	       	terraform get
		terraform apply



