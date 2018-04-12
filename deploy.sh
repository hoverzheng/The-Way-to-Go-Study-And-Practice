#!/bin/bash
#

## deploy book
deploy_book()
{
	echo "start deploy book ..."
}


## deploy master(default)
deploy_master()
{
	git commit -m "updates"
	git remote add origin https://github.com/hoverzheng/The-Way-to-Go-Study-And-Practice.git
	git push -u origin master
}


# main
main()
{
	echo "main"
}


# run 
main
