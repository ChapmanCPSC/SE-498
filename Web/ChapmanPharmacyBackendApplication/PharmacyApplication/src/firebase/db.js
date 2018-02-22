import { db } from './firebase';

// User API

export const doCreateUser = (id, email) =>
    db.ref(`Users/${id}`).set({
        email,
    });

export const onceGetUsers = () =>
    db.ref('Users').once('value');


// Other Entity APIs ...