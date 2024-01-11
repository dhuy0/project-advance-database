import React from "react";
import {  Route, Routes} from 'react-router-dom'



// Components
import LandingPage from  './pages/LadingPage';
import DashBoard from './pages/DashBoard';
import SignIn from "./pages/auth/signin";

export default function App() {
  return (
    <Routes>
      <Route path="/" element = {<LandingPage/>}/>
      <Route path = "/dashboard" element = {<DashBoard/>}/>
      <Route path = "/signin" element = {<SignIn/>}/>
    </Routes>
  );
}
