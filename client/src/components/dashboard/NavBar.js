import React from 'react'

function NavBar(props) {
  return (
    <nav>
        <i className="fas fa-bars menu-btn" onClick = {props.showSideBar}></i>
        <a href="#" className="nav-link">Categories</a>
        <form action="#">
          <div className="form-input">
            <input type="search" placeholder="search..." />
            <button className="search-btn">
              <i className="fas fa-search search-icon"></i>
            </button>
          </div>
        </form>

        <input type="checkbox" hidden id="switch-mode" />
        <label for="switch-mode" className="switch-mode"></label>

        <a href="#" className="notification">
          <i className="fas fa-bell"></i>
          <span className="num">28</span>
        </a>

        <a href="#" className="profile">
          <img src="profile.png" alt="" />
        </a>
      </nav>
  )
}

export default NavBar