# iOS-MedQuiz
The iOS Medical Quiz App

# Pods

> Pods add extra functionality to our iOS project

* To make sure the project builds correctly please navigate to the root directory of the iOS project and run the following commands

```
pod install

```
* From now on open the project's workspace file, in that case it's "MedQuiz.xcworkspace". If a file with that name no longer exists simply look for the file with .xcworkspace extension and use it to build/run the project.


# TravisCI (Continous Intergration) Testing
> For this project we are using Travis CI. Which is a tool that directly interfaces with a github repo for fast and easy testing that can be automated. 
* Travis CI will send you an email notification if your build/commit passed or fail.
* Every time a team member makes a commit to the repo. Travis CI will automatically conduct the automated testing on the files being commited.
* Travis CI will keeps a history of all the builds/commits made by the dev team. It will allow you to see when a build was broken and who did it.

* Travis CI is set up to run tests everytime a merge occurs within the github repo. It takes instructions from your config.yml file and runs the unit tests you specify. https://docs.travis-ci.com/user/for-beginners/
* The config.yml was made and exists on the ChapmanCPSC/SE-498 repo.
* When running tests make sure your .travis.yml file is in the right location.
* Refer to this link regarding the structure of the .travis.yml file. https://docs.travis-ci.com/user/getting-started#To-get-started-with-Travis-CI
