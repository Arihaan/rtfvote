import React from "react";

const Connected = (props) => {

    return (
        <div className="connected-container">
            <img src="rtfvote.png" width={100}></img>

            <p className="connected-account">Your RTF wallet is connected!<br/><br/>Your Address: {props.account}</p>
            <h2 className="connected-header">Where do you want the next fight to be?</h2>

            <div class="venues-container">
                <div class="voting-button" id="button1" onClick={() => props.selectButton(1)}>
                    <h2>{props.venues[0][0]}</h2>
                    <img class="venue-image" src={props.venues[0][1]} alt="Venue Image 1"/>
                    <p>Current Votes: <span id="votes1">{props.venues[0][2].toNumber()}</span></p>
                </div>

                <div class="voting-button" id="button2" onClick={() => props.selectButton(2)}>
                    <h2>{props.venues[1][0]}</h2>
                    <img class="venue-image" src={props.venues[1][1]} alt="Venue Image 2"/>
                    <p>Current Votes: <span id="votes2">{props.venues[1][2].toNumber()}</span></p>
                </div>
            </div>

            <h6 className="connected-account">Remaining Time: {(props.remainingTime / 3600).toFixed(1)} hours</h6>

            { props.showButton ? (
                <div>    
                <button className="login-button" onClick={props.withdrawFunction}>Withdraw Staked RTF (Removes Vote)</button>
                </div>
            ) : (
                <div>    
                    <button className="login-button" onClick={props.voteFunction}>Stake 0.002 RTF to Vote!</button>
                </div>
            )}

            
        </div>
    )
}

export default Connected;