// Initialize Firebase
import * as firebase from 'firebase';

// Initialize Firebase
const config = {
    apiKey: "AIzaSyAWJEhgK19vZkUH4jWRCmDnrmlrWycgPug",
    authDomain: "cusp-quiz-app.firebaseapp.com",
    databaseURL: "https://cusp-quiz-app.firebaseio.com",
    projectId: "cusp-quiz-app",
    storageBucket: "cusp-quiz-app.appspot.com",
    messagingSenderId: "678976715567"
};
firebase.initializeApp(config);

if (!firebase.apps.length) {
    firebase.initializeApp(config);
}

const db = firebase.database();
const auth = firebase.auth();
export {
    db,
    auth,
};