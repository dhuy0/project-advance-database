import React from 'react'
import { Outlet } from 'react-router-dom';

import SideBar from '../../components/dashboard/SideBar';
import NavBar from '../../components/dashboard/NavBar';
import HeadTitle from '../../components/dashboard/HeadTitle';
import './DashBoard.css'
function DashBoard() {

  return (
    <>
    <SideBar/>
    <section className="content">
      <NavBar/>
      <main>
        
        <Outlet/>
      </main>
    </section>
    </>
  )
}

export default DashBoard;