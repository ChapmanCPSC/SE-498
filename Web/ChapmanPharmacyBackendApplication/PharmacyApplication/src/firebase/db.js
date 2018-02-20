import { db } from './firebase';

// User API

export const doCreateUser = (id, email, business_name) =>
    db.ref(`Vendors/${id}`).set({
        email,
        business_name,
    });

export const onceGetUsers = () =>
    db.ref('Vendors').once('value');


// Other Entity APIs ...