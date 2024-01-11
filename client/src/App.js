import React from "react";
import {  Route, Routes} from 'react-router-dom'



// Components
import LandingPage from  './pages/LadingPage';
import DashBoard from './pages/dashboard/DashBoard';
import Patients from "./pages/dashboard/Patients";
import Dentists from './pages/dashboard/Dentists'
import SignIn from "./pages/auth/signin";
import DashBoardHome from "./pages/dashboard/Home";
import PatientDetail from "./pages/dashboard/PatientDetail";
export default function App() {
  return (
    <Routes>
      <Route path="/" element = {<LandingPage/>}/>
      <Route path = "/dashboard/" element = {<DashBoard/>}>
        
        <Route path = "patients" element = {<Patients/>}/>
        <Route path = "patients/:patientId" element = {<PatientDetail/>}/>
        <Route path = "dentists" element = {<Dentists/>}/>
        <Route path = "" element = {<DashBoardHome/>}/>
      </Route>
      <Route path = "/signin" element = {<SignIn/>}/>
    </Routes>
  );
}
