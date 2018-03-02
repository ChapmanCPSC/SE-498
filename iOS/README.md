# iOS-MedQuiz
The iOS Medical Quiz App

> The iOS app section of the Chapman Pharmacy School quiz application is built using Swift and Xcode. This documents/links explain how to run builds and get started with iOS Development.
> https://codewithchris.com/how-to-make-an-iphone-app/  
> https://codewithchris.com/deploy-your-app-on-an-iphone/

* Travis CI is set up to run tests everytime a merge occurs within the github repo. It takes instructions from your config.yml file and runs the unit tests you specify. https://docs.travis-ci.com/user/for-beginners/
* The config.yml was made and exists on the ChapmanCPSC/SE-498 repo.
* When running tests make sure your .travis.yml file is in the right location.
* Refer to this link regarding the structure of the .travis.yml file. https://docs.travis-ci.com/user/getting-started#To-get-started-with-Travis-CI

# TravisCI (Continous Intergration) Testing
> For this project we are using Travis CI. Which is a tool that directly interfaces with a github repo for fast and easy testing that can be automated. 
* Travis CI will send you an email notification if your build/commit passed or fail.
* Every time a team member makes a commit to the repo. Travis CI will automatically conduct the automated testing on the files being commited.
* Travis CI will keeps a history of all the builds/commits made by the dev team. It will allow you to see when a build was broken and who did it.
