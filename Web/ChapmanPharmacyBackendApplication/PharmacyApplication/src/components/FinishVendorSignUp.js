function Welcome(props) {
    return <h1>Hello, {props.name}. Welcome to {props.business}!</h1>;
}

const element = <Welcome name="Sara" business="McDonalds" />;
ReactDOM.render(element, document.getElementById('root'));