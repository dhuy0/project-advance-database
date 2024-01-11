import React from "react";
import {  Route, Routes} from 'react-router-dom'

// context 
import { AuthContext } from "./shared/context/auth-context";

import AuthHook from "./shared/hooks/auth-hook";


// Components
import LandingPage from  './pages/LadingPage';
import DashBoard from './pages/dashboard/DashBoard';
import Patients from "./pages/dashboard/Patients";
import Dentists from './pages/dashboard/Dentists'
import SignIn from "./pages/auth/signin";
import DashBoardHome from "./pages/dashboard/Home";
import PatientDetail from "./pages/dashboard/PatientDetail";
import Home from "./pages/dashboard/Home";
export default function App() {
  const {login , logout, token, userId} = AuthHook();
  let routes ;
  if(!token) {
    routes = (
      <>
      <Route path = "/signin" element = {<SignIn/>}/>
      </>
    )
  }
  else {
    routes = (
      <Route path = "/dashboard" element = {<DashBoard/>}>
      <Route path = "patients" element = {<Patients/>}/>
      <Route path = "patients/:patientId" element = {<PatientDetail/>}/>
      <Route path = "dentists" element = {<Dentists/>}/>
      <Route path = "" element = {<DashBoardHome/>}/>
    </Route>
    )
  }

  return (
    <>
      <AuthContext.Provider value = {
      {isLoggedIn :!!token, 
        login ,
        logout, 
        userId, 
        token 
      }}></AuthContext.Provider>
    <Routes>
      <Route path = "/" element = {<LandingPage/>}/>
      {routes}
    </Routes>
    </>
  );
}
