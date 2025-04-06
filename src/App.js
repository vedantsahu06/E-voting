import React, { useState } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import LoginForm from "./Components/LoginForm/LoginForm";
import Carousel from "./Components/Carousel Slider/slider";

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  const handleLogin = () => {
    // Simulate authentication (Replace with actual login logic)
    setIsAuthenticated(true);
  };

  return (
    <Router>
      <Routes>
        <Route path="/" element={isAuthenticated ? <Navigate to="/slider" /> : <LoginForm onLogin={handleLogin} />} />
        <Route path="/slider" element={isAuthenticated ? <Carousel /> : <Navigate to="/" />} />
      </Routes>
    </Router>
  );
}

export default App;
