git-deploy
==========

git-deploy is simple and easy-to-use git deployment tool. There is lot of functionality that just works out of the box. Other things can be done through configuration, saved in .deployfile.

Usage
-----

	npm install -g node-git-deploy
	git-deploy <config>
	
Config
------

Config is stored in json file

	{
	  "applications": {
	    "myApp": {
	      "handler": "bitbucket",
	      "post_deploy": "",
	      "deploy": "",
	      "pre_deploy": ""
	    }
	  }
	}
	
Config contains list of applications, which can be deployed on current server.

.deployfile
-----------
Deploy file should be in your project root. It is not mandatory to use .deployfile, but there you can override server actions.
	

Instalation
-----------
Just run
		
	gulp

Job done!

License
-------
The MIT License (MIT)