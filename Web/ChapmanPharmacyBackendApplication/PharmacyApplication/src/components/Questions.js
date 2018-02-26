import React, { Component } from 'react';
import * as routes from '../constants/routes';
import { firebase } from '../firebase';
import { db } from '../firebase';

class QuestionsPage extends Component {
    constructor (props) {
        super(props);
        this.state = {
            questions: [],
            questionFirebaseRef : db.getQuestionReference()
        }
    }
    render () {
        return (
            <div className="wholeQuestionPage">
                <h1>Questions Page</h1> {/* Header for the Question Creation/Editing Page */}

                <div className="questionSelection">
                    <table>
                        <tbody>
                        {/* May need to put a <table> here if you do a <td> */}
                                {this.state.questions.map((question) => {
                                    return (
                                        <tr> {question.text} </tr>
                                    )
                                })}

                        </tbody>
                    </table>
                </div>

            </div>
        )
    }
    componentDidMount () {
        // Grab any questions in Firebase Database
        db.getQuestionReference().on('value', (snapshot) => {
            let questionsVal = snapshot.val();
            let stateToSet = [];
            for (let item in questionsVal) {
                stateToSet.push({
                    id : item,
                    text : item[item].text
                })
            }
            this.setState({
                questions: stateToSet
            });
        });
    }
    componentWillUnmount() {
        this.state.questionFirebaseRef.off();
    }
}

export default QuestionsPage;