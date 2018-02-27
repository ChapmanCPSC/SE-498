import React, { Component } from 'react';
import * as routes from '../../constants/routes';
import { firebase } from '../../firebase';
import { db } from '../../firebase';

class QuestionsPage extends Component {
    constructor (props) {
        super(props);
        this.state = {
            currentlySelectedQuestion : "defaultOption",
            newQuestionText : "",
            questions: []
        };
        this.handleChange = this.handleChange.bind(this);
        this.handleAddQuestionSubmit = this.handleAddQuestionSubmit.bind(this);
    }

    handleChange(event) {
        this.setState({[event.target.name]: event.target.value})
    }
    handleAddQuestionSubmit(event) {
        event.preventDefault();
        const ref = db.getQuestionReference();
        let newAddition = ref.push();
        newAddition.set({
            text: this.state.newQuestionText
        });
        this.setState({currentlySelectedQuestion: newAddition.key})
    }
    render () {
        return (
            <div className="wholeQuestionPage">
                <h1>Questions Page</h1> {/* Header for the Question Creation/Editing Page */}

                <div className="questionSelection">
                    {/* TODO: Must maintain concurrency: I.e. if a question is deleted by another admin, need to make sure
                        the currently selected question changed back to default, or alerts the user
                    */}
                    <select name="currentlySelectedQuestion" value={this.state.currentlySelectedQuestion} onChange={this.handleChange}>
                        <option name="currentlySelectedQuestion"
                                value="defaultOption"
                                key="defaultOption">---Please Select a Question---</option>
                        {this.state.questions.map((question) => {
                            return (
                                <option name="currentlySelectedQuestion"
                                        key={question.id}
                                        value={question.id}>{question.questionText}</option>
                            )
                        })}
                    </select>
                </div>

                {/* Here is a box and button for adding a new question */}
                <div className="addNewQuestion">
                    <form onSubmit={this.handleAddQuestionSubmit}>
                        <input type="text"
                               name="newQuestionText"
                               placeholder="Please enter your question"
                               value={this.state.newQuestionText}
                               onChange={this.handleChange}
                        />
                        <button>Add Question</button>
                    </form>
                </div>

                {/* Here is the box for the editing and creation of questions */}
            </div>
        )
    }
    componentDidMount () {
        db.getQuestionReference().on('value', (snapshot) => {
            let questionsVal = snapshot.val();
            let stateToSet = [];
            for (let item in questionsVal) {
                stateToSet.push({
                    id : item,
                    questionText : questionsVal[item].text
                })
            }
            this.setState({
                questions: stateToSet
            });
        });
    }
    componentWillUnmount() {
        db.getQuestionReference().off();
    }
}

export default QuestionsPage;