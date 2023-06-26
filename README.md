# CarCare
The project delivered is a mobile application which we call CarCare. CarCare is a native multi-platform mobile application developed using Flutter. It is designed to help car owners manage their car maintenance tasks. The app generates a personalized maintenance schedule based on the user’s car details such as brand and mileage as input and displays days left for each of the upcoming maintenance tasks. CarCare also enables users to share their experiences through community posts, fostering engagement and knowledge-sharing among users. Additionally, the app provides users with current automobiles news and updates.

## Main project objectives
From high level view, the main objectives of this project are:
• To enable users to save their maintenance records and activities history digitally.
• For the app to generate personalized and detailed maintenance schedules for users.
• Support community interaction where users can share their journey through posting and be able to view and comment on others’ too.

### A.System Design Specification
As part of the system design phase, we created a context diagram that further levels down to level 1 and UML class diagram. We also designed the frontend and backend of the application using flutter framework and firebase cloud store respectively. A detailed description is as follows:
#### i. Logical System Design 
**UML Class Diagram**<br>
In the class diagram below, there are 5 classes: user, post, car, record and schedule. Where each of them has a unique Id as their primary key.
Car and Post classes use User’s uid primary key as their foreign key. And Record and Schedule use Car’s Id primary key as their foreign key.

<img width="875" alt="UML" src="https://github.com/semereab-merry/CarCare/assets/59441158/f5881241-c551-4d01-a4af-5834ae470db7">
<br>
<br>

**Level 1 Diagram** <br> 
The diagram below shows the exploded view of the previous context diagram into detailed processes and data flow. Details are as follows:
8 Processes: Register user, Authenticate User, Create Car Profile, Display Schedule, Save Records, Share Content, Display Posts and Display News.
5 Data Stores: Users, Cars, Schedules, Maintenance records and Posts.
- New users first sign up with their details through the Register user process and their
details is stored in the Users data store.
- The registered user (car owner) can sign-in by providing the appropriate credentials to the Authenticate User process. This process then passes user details to the following process Create car profile.
- User details from Authenticate user process and car data from the user are then passed to the Create car profile process for users to create a profile for their car. Car details are then stored in the Cars data store for later schedule generation.
- After car profile creation, a user first adds their recent maintenance activity details (dates) to the Display Schedule process. The data will then be stored in the Schedules data store and the Display Schedule process continuously updates the schedule by counting down the days to show user the remaining days to their next maintenance activity.
- Once the user does their maintenance activity, they can update their schedule by confirming to the same process and it will update the schedule by calculating the remaining days from on the current date and details from the Schedule data store.
- A User can save their maintenance records in the Maintenance records data store through the process Save records. In the application, users can take a picture of their physical maintenance records and add details if need be and the images along with the details will be stored in the Maintenance records data store.
- Users can also share posts to the Share Content process by adding their post content and the details will be stored in the Posts data store. The app then displays all contents from different users stored in the Posts data store to its users through Display Posts process.
- The system also displays automobile news to users by requesting news feed from the News API entity through the Display News process. After request acceptance, the News API then sends news feeds back to the process and the display news process displays automobile news to users.

<img width="875" alt="Level 1 diagram" src="https://github.com/semereab-merry/CarCare/assets/59441158/f4c30b3b-d6bd-4843-b7ab-6be18c81ca2e">

<br> 

#### ii. Software design
The software design of the application mainly uses two technologies: Flutter framework for the frontend and Firebase for backend.
For a clearer understanding of the implemented application, please click on this visual demo. 
#### Backend design <br>
We developed the backend using Google’s Firebase. Firebase is a set of backend cloud computing services and application development platforms provided by Google. To enable the Firebase in our app we first created apps and attached the generated API address with flutter apps.

<img width="795" alt="Firebase" src="https://github.com/semereab-merry/CarCare/assets/59441158/72724dc1-8083-4c50-9e85-0e79b98ba537">
<br><br>

As indicated in the screenshot above, we used the three features from all the firebase capabilities:
Firestore Database: Firebase provides two main databases: Cloud Firestore and Firebase Realtime Database. In this application we used Cloud <br>

**Firestore:** It is a NoSQL cloud-hosted database, but it uses a document-oriented data model and provides a richer set of querying capabilities. It supports real-time updates and provides a more flexible data model that allows storing of complex nested data structures. 
<br><br>
<img width="738" alt="Firebase database" src="https://github.com/semereab-merry/CarCare/assets/59441158/66470f34-f753-4678-a946-132a0db285d4">
<br><br>

**Authentication:** The feature provides an easy and secure way to authenticate users to the mobile application. Firebase Authentication offers a variety of verification methods including email and password, phone number, Google, Facebook, Twitter, and others. This feature also stores all the registered users’ authentication details.
<br><br>

<img width="750" alt="Firebase Authentication" src="https://github.com/semereab-merry/CarCare/assets/59441158/38e5fe02-7d7b-4e3c-ac17-27f52622918e">
<br><br>

**Storage:** This feature is a cloud-based storage solution that is used to store and serve user- generated content such as images, videos, and audio files. It is designed to be secure, reliable, and scalable, and is built on Google Cloud Storage infrastructure. Storage provides a simple API for uploading and downloading files.
<br><br>
<img width="789" alt="Firebase Storage" src="https://github.com/semereab-merry/CarCare/assets/59441158/34e904a4-ba3d-47f2-9f63-ce2a2a82de2c">
<br>
#### Frontend design
The front-end design is built using Flutter framework, an open-source UI software development kit created by Google. Flutter is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase. It uses Dart programming language, which is also developed by Google, and provides a rich set of customizable UI widgets and tools for building beautiful and responsive user interfaces.
One of the main advantages of Flutter is its "hot reload" feature, which allows developers to see changes to the code in real-time, without having to rebuild the entire application. This makes development faster and more efficient. Overall, it is a powerful and versatile framework for mobile application development, particularly for high-quality applications with a fast and efficient development process.
The app includes around thirteen neat and highly user-friendly pages. When building the frontend, we began with creating classes.
<br>

**Screens:** there are around 13 screens created.
- Login and Signup Screens: When a user opens the app, the first page displayed is the Signup page where new user fills their email and set password to create an account. Moreover, this page forwards returning users to the Login page. If a user already has an account, then they may switch to Login page. Then users login to their registered account using their email address and password.
- Home: This is the landing page when a user logs
into the app. This page uses the UserProvider to
identify the current user and give the output accordingly.
Supervisor Name: Ashraf Khalil
- Profile Screen: This page is the user’s account profile page. The page displays the user’s details, posts and buttons to add post and sign out.
- Car Profile Screen: Upon clicking, it gets the car id of the currently logged user and the clicked car. Then it shows the details of the car accordingly.
- Add cars screen: a page where users input their car details to add their car in the app. The application allows users to add more than one car in their account.
- Update Schedule Screen: Upon clicking the car widget in the home screen, the schedule screen displays the generated personal maintenance schedules of the users can.
- Add Posts and Comments Screens: These two screens enable users to share contents about their experiences and interests through posting and commenting.
- Add Records and Past Records Screens: Allow users to save images of their maintenance records and enables them to have access to it whenever they wanted from the Past Records screen.
- News and Feed Screens: These screens contain a list of popular news feeds on automobiles for the users to stay updated. In this project since we are only working on three brands (Toyota, Nissan, Hyundai), the news feed are displayed accordingly.

Some of the pages are shown below:


| Home page | Car profile page | Posts page|
| ----------- | ----------- |  ----------- |
| <img width="300" alt="UML" src="https://github.com/semereab-merry/CarCare/assets/59441158/2f73588b-b9c6-4989-92d6-44795cc90a8d"> | <img width="300" alt="UML" src="https://github.com/semereab-merry/CarCare/assets/59441158/282b49fc-73c4-4eaf-aabc-8363582a4519">  | <img width="300" alt="UML" src="https://github.com/semereab-merry/CarCare/assets/59441158/458d0a8c-d72e-4a56-8bb8-fd9b6266f1e0">  |


<br> 


