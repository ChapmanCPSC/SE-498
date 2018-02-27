# REACT APP

> The Web Portal section of the Pharmacy School quiz application is built on the
> Using the React framework, we will be following closely how to run builds based on this [document](https://medium.com/@Zaccc123/https-medium-com-zaccc123-continuous-integration-and-deployment-setup-for-react-app-7b5f4bd76cdd).

* CircleCI is set up to run tests everytime a merge occurs within the github repo. It takes instructions from your config.yml file and runs the unit tests you specify.

* The config.yml has already been made and it exists within the SE-498/Web/ChapmanPharmacyBackendApplication/PharmacyApplication/.circleci directory. 

* Since we are using react, which is built from node.js, within your .yml, make sure npm install is included. If not, the dependcies will not be installed and your code tests will fail!

* When running tests, there are two changes to this config file that may need to be made. Make sure the working_directory is set to the specified location where the test code is. Second, the "npm tests" command is set to this current folder. If your test code exists in another folder, change this.

* Regarding the structure of the config.yml file and extra capabilities, please refer to this [document](https://circleci.com/docs/2.0/sample-config/)

# Firebase

> For this project, we are using CircleCI [CircleCI](https://circleci.com/), which is a tool that directly interfaces with a github repo for fast and easy testing that can be automated.
> Using the React framework, we will be following closely how to run builds based on this [document](https://medium.com/@Zaccc123/https-medium-com-zaccc123-continuous-integration-and-deployment-setup-for-react-app-7b5f4bd76cdd).

* CircleCI is set up to run tests everytime a merge occurs within the github repo. It takes instructions from your config.yml file and runs the unit tests you specify.

* The config.yml has already been made and it exists within the SE-498/Web/ChapmanPharmacyBackendApplication/PharmacyApplication/.circleci directory. 

* Since we are using react, which is built from node.js, within your .yml, make sure npm install is included. If not, the dependcies will not be installed and your code tests will fail!

* When running tests, there are two changes to this config file that may need to be made. Make sure the working_directory is set to the specified location where the test code is. Second, the "npm tests" command is set to this current folder. If your test code exists in another folder, change this.

* Regarding the structure of the config.yml file and extra capabilities, please refer to this [document](https://circleci.com/docs/2.0/sample-config/)




# CircleCI Intergration Testing

> For this project, we are using CircleCI [CircleCI](https://circleci.com/), which is a tool that directly interfaces with a github repo for fast and easy testing that can be automated.
> Using the React framework, we will be following closely how to run builds based on this [document](https://medium.com/@Zaccc123/https-medium-com-zaccc123-continuous-integration-and-deployment-setup-for-react-app-7b5f4bd76cdd).

* CircleCI is set up to run tests everytime a merge occurs within the github repo. It takes instructions from your config.yml file and runs the unit tests you specify.

* The config.yml has already been made and it exists within the SE-498/Web/ChapmanPharmacyBackendApplication/PharmacyApplication/.circleci directory. 

* Since we are using react, which is built from node.js, within your .yml, make sure npm install is included. If not, the dependcies will not be installed and your code tests will fail!

* When running tests, there are two changes to this config file that may need to be made. Make sure the working_directory is set to the specified location where the test code is. Second, the "npm tests" command is set to this current folder. If your test code exists in another folder, change this.

* Regarding the structure of the config.yml file and extra capabilities, please refer to this [document](https://circleci.com/docs/2.0/sample-config/)



