// Initialize Firebase
import * as firebase from 'firebase';

// Initialize Firebase
const config = {
    apiKey: "AIzaSyANryDOt1eaE6p46Rrc20QCtAP8DGun0ro",
    authDomain: "vendyrtest.firebaseapp.com",
    databaseURL: "https://vendyrtest.firebaseio.com",
    projectId: "vendyrtest",
    storageBucket: "vendyrtest.appspot.com",
    messagingSenderId: "848346568011"
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