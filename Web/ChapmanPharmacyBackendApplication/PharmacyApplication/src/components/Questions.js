import React, { Component } from 'react';
import * as routes from '../constants/routes';
import firebase from 'firebase'

class QuestionsPage extends Component {
    constructor (props) {
        super(props);
        this.state = {
            questions: []
        }
    }
    render () {
        const qf = firebase.database().ref('question/5a2ec76bf4b843a79183/text');
        let SweetBabyRay  = "";
        qf.on("value", function(snapshot) {
            SweetBabyRay = snapshot.val();
        });
        return (
            <div className="wholeQuestionPage">
                <h1>Questions Page</h1> {/* Header for the Question Creation/Editing Page */}
                <h2> {SweetBabyRay} </h2>
                <div className="questionSelection">
                    <table>
                        <tbody>
                        {/* May need to put a <table> here if you do a <td>*/}
                                {this.state.questions.map((question) => {
                                    return (
                                        <tr> question.text </tr>
                                    )
                                })}

                        </tbody>
                    </table>
                </div>
                {/*
                <table>
                    <tbody>
                        <tr>
                            <td> Hello </td>
                        </tr>
                    </tbody>
                </table> */}
            </div>
        )
    }
    componentDidMount () {
        const questionsRef = firebase.database().ref('question');
        // Grab any questions in Firebase Database
        questionsRef.on('value', (snapshot) => {
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
}

export default QuestionsPage;