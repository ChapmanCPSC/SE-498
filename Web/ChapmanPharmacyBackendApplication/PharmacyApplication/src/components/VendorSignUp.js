import React, { Component } from 'react';
import { Link, withRouter,} from 'react-router-dom';
import { auth, db } from '../firebase';
import * as routes from '../constants/routes';


const SignUpPage = ({ history }) =>
    <div>
        <h1>Vendyr Sign Up Part 1</h1>
        <SignUpForm history={history} />
    </div>


const INITIAL_STATE = {
    business_name: '',
    email: '',
    passwordOne: '',
    passwordTwo: '',
    error: null,
};

const byPropKey = (propertyName, value) => () => ({
    [propertyName]: value,
});

class SignUpForm extends Component {
    constructor(props) {
        super(props);

        this.state = { ...INITIAL_STATE };
    }

    onSubmit = (event) => {
        const {
            business_name,
            email,
            passwordOne,
        } = this.state;

        const {
            history,
        } = this.props;

        auth.doCreateUserWithEmailAndPassword(email, passwordOne, business_name)
            .then(authUser => {
                this.setState(() => ({...INITIAL_STATE }));
                history.push(routes.HOME);

                // Create a user in your own accessible Firebase Database too
                db.doCreateUser(authUser.uid, email, business_name)
                    .then(() => {
                        this.setState(() => ({ ...INITIAL_STATE }));
                        history.push(routes.HOME);
                    })
                    .catch(error => {
                        this.setState(byPropKey('error', error));
                    });
            })
            .catch(error => {
                this.setState(byPropKey('error', error));
            });

        event.preventDefault();
    }

    render() {
        const {
            business_name,
            email,
            passwordOne,
            passwordTwo,
            error,
        } = this.state;

        const isInvalid =
            business_name === '' ||
            passwordOne !== passwordTwo ||
            passwordOne === '' ||
            email === '';
        return (
            <form onSubmit={this.onSubmit}>
                <input
                    value={business_name}
                    onChange={event => this.setState(byPropKey('business_name', event.target.value))}
                    type="text"
                    placeholder="Your Business Name"
                />
                <input
                    value={email}
                    onChange={event => this.setState(byPropKey('email', event.target.value))}
                    type="text"
                    placeholder="Email Address"
                />
                <input
                    value={passwordOne}
                    onChange={event => this.setState(byPropKey('passwordOne', event.target.value))}
                    type="password"
                    placeholder="Password"
                />
                <input
                    value={passwordTwo}
                    onChange={event => this.setState(byPropKey('passwordTwo', event.target.value))}
                    type="password"
                    placeholder="Confirm Password"
                />
                <button disabled={isInvalid} type="submit">
                    Sign Up
                </button>

                { error && <p>{error.message}</p> }
            </form>
        );
    }
}

const SignUpLink = () =>
    <p>
        Don't have an account?
        {' '}
        <Link to={routes.VENDOR_SIGN_UP}>Vendor Sign Up</Link>
    </p>

export default withRouter(SignUpPage);

export {
    SignUpForm,
    SignUpLink,
};