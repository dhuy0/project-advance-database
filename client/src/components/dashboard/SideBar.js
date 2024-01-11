import React from 'react'
import { NavLink } from 'react-router-dom'

import './SideBar.css'

function SideBar() {


  return (
    <section className="sidebar" >
      <NavLink to = '/dashboard' className="logo">
        <i className="fab fa-slack"></i>
        <span className="text">Admin Panel</span>
      </NavLink>

      <ul className="side-menu top">
        <li className="active">
          <NavLink to = "/dashboard" className="nav-link">
            <i className="fas fa-border-all"></i>
            <span className="text">Dashboard</span>
          </NavLink>
        </li>
        <li>
          <NavLink to = "/dashboard/patients" className="nav-link">
          <i class="fa-solid fa-clipboard-user"></i>
            <span className="text">Pattients</span>
          </NavLink>
        </li>
        <li>
          <NavLink to ='/dashboard/dentists' className="nav-link">
          <i class="fa-solid fa-user-doctor"></i>
            <span className="text">Dentists</span>
          </NavLink>
        </li>
        <li>
          <NavLink to = "/" className="nav-link">
            <i className="fas fa-message"></i>
            <span className="text">Message</span>
          </NavLink>
        </li>
        <li>
          <NavLink to = "/" className="nav-link">
            <i className="fas fa-people-group"></i>
            <span className="text">Team</span>
          </NavLink>
        </li>
      </ul>

      <ul className="side-menu">
        <li>
          <NavLink to = "/">
            <i className="fas fa-cog"></i>
            <span className="text">Settings</span>
          </NavLink>
        </li>
        <li>
          <NavLink to = "/" className="logout">
            <i className="fas fa-right-from-bracket"></i>
            <span className="text">Logout</span>
          </NavLink>
        </li>
      </ul>
    </section>
  )
}

export default SideBar