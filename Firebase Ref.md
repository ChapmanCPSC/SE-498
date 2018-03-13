## Question
>Description: This is a collection of essential question information

* name: a string value which is the name of the question
**This must be duplicated in the question-name object**
**To duplicate, make sure the Unique ID of this question is inserted into the question-name object, then add a key called name with the same name listed here attached as a value**
*points: a numerical values which states the number of points received per question
* tags: Collection of the tags which this question has
**This references ID’s in the tags object.**
* imageforanswers : a boolean value which states whether or not this question has an image attached to each of the answer choices
**May be moved into choices**
* imageforquestion : a boolean value which states whether or not this question has an image attached to the question itself
**I.e., a question may display one mage, which the use must use in order to discern the correct answer**
* datecreated: the date the question was created and inserted into the DB
* timecreated: the time the question was created and inserted into the DB
* lastused
  * class : the ID of the course this question was last used in
  **Need to switch this to be the last game**
  * Date: the time which the question was last used
  * Time: the date which the question was last used
## question-name
>Description: The name of the question tied to the ID
*name: a string value which is the name of the question
>This is duplicated from the question object, so be sure to always update this by using the ID of the specific question and updating the name data here
>We duplicate all names into this table for easier, more efficient querying within both the iOS app and the web application
## Quiz
>Description: This is a collection of essential quiz information
*Title: A string value which is the name of the quiz
*available:
## Choices
>Description: The available answers for a specific question
**This object also utilizes the specific ID of a question.**
*answers : Collection of IDs for each answer, with a string value with the answer name
*correctanswers: Same collection of IDs as above, but with a boolean flag value stating whether or not the specific question would be considered to be a correct or incorrect answer
## Course
>Description: The course for which a set of student’s might be enrolled in. Stores information regarding specific quizzes that are used in the course
*coursecode: A string value stating the course reference name
I.e. “PHRM 577”
*faculty: The ID of the faculty member who is teaching the course
May be changed to be a collection of faculty members
*quizzes: a collection of quiz IDs, with a boolean value stating whether or not this quiz is featured in the course or not
*students: a collection of student IDs, with a boolean flag stating whether or not this student is enrolled in the course or not
*Title: a string value describing the full name of the course
*yearrank : A value stating the specific Pharmacy school year of the class
There are three sections that this key can take on: P1, P2, or P3
## faculty
>Description: The faculty member who is responsible for teaching different types of courses. 
*Courses: A collection of course IDs for which this faculty member is associated, with a boolean flag stating whether or not this course is attached or not
*Name: A string value for the faculty member’s full name. 
For iOS display
*Questions :  a collection of question IDs, with a boolean value stating whether or not this question is associated with the faculty member or not
*Quizzes : a collection of quiz IDs, with a boolean value stating whether or not this quiz is associated with the faculty member or not
## student
>Description : A collection of students, who are enrolled in specific courses
*courses : A collection of course IDs for which this student is associated, with a boolean flag stating whether or not this course is attached or not
*Profilepic: A string value which references the firebase storage URL path where the student’s photo profile pic is located
*Username : A string value with the username for the student
## game
Description : A collection of in-class games, in which students compete against each other in order to achieve the highest score
Tdb
## Score
>Description: A collection of scores 
## ingame-student-questions
>Description: A collection of choices made by a student within an in-class game
## tag
Description: A collection of meta-tags which can be used to filter and group either questions or quizzes
*Name : A string value containing the name of the tag
*Color : A color which can be used to better
*Questions : a collection of question IDs, with a boolean value stating whether or not this question is associated with this tag or not
*Quizzes : a collection of quiz IDs, with a boolean value stating whether or not this quiz is associated with this tag or not
## users
