import React from "react";

const Login = (props) => {
    return (
        <div className="login-container">
            <img src="rtfvote.png"></img>
            <h1 className="welcome-message">Welcome to the RTF Voting Platform.</h1>
            <button className="login-button" onClick = {props.connectWallet}>Connect RTF Wallet</button>
        </div>
    )
}

export default Login;