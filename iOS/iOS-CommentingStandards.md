
**QuizEdu Commenting Standards**

# General Commenting
*In general make sure your comments are well spaced out, grammatically correct, spelling checked and uses simple easy to understand vocabulary.*

Use the following syntax for commenting all throughout:
```
/*
Comment Here
*/
```

And the comment lays above the commented about subject of interest. Leave one line space between the comment and the subject of interest  Ex:
```
/*
Comment Here
*/

Class Student{

}
```

Unless you’re comment is referring to one line or so then just use this syntax and don’t leave a line after:

`
//Global high-score variable is used throughout the app to update the current student’s high-score locally
var globalHighscore = 0;
`


# Maintenance notes
*If any notes are necessary for future engineers to get the project to build or to help them achieve something that would otherwise take them a lot of time to figure out, mention it where it is needed.*
```
/*
Dear maintainer:
 
Once you are done trying to 'optimize' this routine,
and have realized what a terrible mistake that was,
please increment the following counter as a warning
to the next guy:
 
total_hours_wasted_here = 42
*/
```


# Models
*At the top of the model just explain why this model exists and what it helps to achieve, and if it helps how it works with the wrappers.*

# Classes
*At the top of the class explain the utility of the class and why one would create an object of that class*

*Explain what parameters constructors take and what different constructors achieve*

# Functions
*Just simply explain what the function achieves. If it takes parameters explain what those parameters are. If it returns something explain if it is more of a completion handler or an instant return kind of a thing and explain what it returns. If the function calls another function on return explain why this chaining action is beneficial and if it is necessary for the functions be useful or if the function can be used on its own.*

# Variables
*If it makes sense to explain why a variable exists then do it.*
```
//Global high-score variable is used throughout the app to update the current student’s high-score locally
var globalHighscore = 0;
```
