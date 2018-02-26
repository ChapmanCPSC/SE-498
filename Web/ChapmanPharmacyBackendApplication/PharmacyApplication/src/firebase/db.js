import { db } from './firebase';

// User API

export const doCreateUser = (id, email) =>
    db.ref(`Users/${id}`).set({
        email,
    });

export const onceGetUsers = () =>
    db.ref('Users').once('value');

export function getQuestionReference() {
    return db.ref('question')
}



// Other Entity APIs ...