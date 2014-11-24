git-deploy
==========

git-deploy is simple and easy-to-use git deployment tool. There is lot of functionality that just works out of the box. Other things can be done through configuration, saved in .deployfile.

Usage
-----

	npm install -g node-git-deploy
	git-deploy <config>
	
Config
------

Config is stored in yaml file. This tool is super easy to config! No magic, it just works. Example config is in YAML, but you can use JSON as well.

	#
	# git-deploy example config
	#
	
	# temp is used by some deploy strategies for storing some backup files
	temp: "/tmp/git-deploy"
	port: 3929
	server_name: "janzal"
	
	# enable/disable ui
	ui: true
	# key-value basic authorization for UI controls
	# auth:
	#    admin: "123456"
	
	# object of deployed applications
	# keys are application identifiers and values are objects containing deployment details
	applications:
	
	  firstApp: # app name
	    # these three items are only mandatory for deployment
	    handler: "bitbucket" # handler - currently is supported only bitbucket and github
	    strategy: "hardcore" # there are plenty of strategies, which can be used for deploy. Currently is supported only hardcore
	
	    branches:
	        # branch deploy configuration
	        master:
	            destination: "/Users/janzaloudek/Development/misc/xx/deploy/firstApp/master" # where to deploy application
	            # post_deploy and pre_deploy will be executed in context of destination folder
	            post_deploy: "composer install"
	            pre_deploy: ""
	
	        # ...and you can handle multiple branches
	        dev:
	            destination: "/Users/janzaloudek/Development/misc/xx/deploy/firstApp/dev"
	
	        staging:
	            destination: "/Users/janzaloudek/Development/misc/xx/deploy/firstApp/staging"
	
	



	
Config contains list of applications, which can be deployed on current server.

.deployfile
-----------
Deploy file should be in your project root. It is not mandatory to use .deployfile, but there you can override server actions. It uses also uses YAML. Currently, there is only `post_deploy` parameter.

	master:
		post_deploy: "composer update; composer install"
	
	dev:
		post_deploy: "npm install; composer install"
	

Instalation
-----------
Just run

	npm install		
	gulp

Job done!

License
-------
The MIT License (MIT)