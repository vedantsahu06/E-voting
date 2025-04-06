import React, { useState } from 'react';
import { FaUser } from 'react-icons/fa';
import { FaSquarePhone } from 'react-icons/fa6';
import { useNavigate } from 'react-router-dom';
import './LoginForm.css';

const LoginForm = ({ onLogin }) => {
    const [phone, setPhone] = useState('');
    const [otpSent, setOtpSent] = useState(false);
    const [otp, setOtp] = useState('');
    const navigate = useNavigate(); // Hook for navigation

    const handleSendOtp = (e) => {
        e.preventDefault();
        if (phone.length === 10) { 
            setOtpSent(true);
            alert('OTP Sent to ' + phone);
        } else {
            alert('Please enter a valid phone number');
        }
    };

    const handleVote = (e) => {
        e.preventDefault();
        if (otp.length === 6) {  // Simple OTP validation
            alert('Voting successful!');
            onLogin();  // Mark user as authenticated
            navigate('/slider'); // Redirect to the Carousel
        } else {
            alert('Invalid OTP. Please try again.');
        }
    };

    return (
        <div className="wrapper">
            <form>
                <h1>Login</h1>
                <div className="input-box">
                    <input type="text" name="adid" placeholder="Aadhar Id" required />
                    <FaUser className='icon' />
                </div>
                
                {!otpSent ? (
                    <div className="input-box">
                        <input 
                            type="text" 
                            name="phone" 
                            placeholder="Phone" 
                            value={phone} 
                            onChange={(e) => setPhone(e.target.value)}
                            required 
                        />
                        <FaSquarePhone className='icon' />
                    </div>
                ) : (
                    <div className="input-box">
                        <input 
                            type="text" 
                            name="otp" 
                            placeholder="Enter OTP" 
                            value={otp} 
                            onChange={(e) => setOtp(e.target.value)}
                            required 
                        />
                    </div>
                )}
                
                {!otpSent ? (
                    <button type="submit" onClick={handleSendOtp}>Send OTP</button>
                ) : (
                    <button type="submit" onClick={handleVote}>Vote</button>
                )}
            </form>
        </div>
    );
};

export default LoginForm;
