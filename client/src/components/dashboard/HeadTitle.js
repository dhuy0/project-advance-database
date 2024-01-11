import React from 'react'

import './HeadTitle.css'
function HeadTitle(props) {
  return (
    <div className="head-title">
    <div className="left">
      <h1>Dashboard</h1>
      <ul className="breadcrumb">
        <li>
          <a href="#">Dashboard</a>
        </li>
        <i className="fas fa-chevron-right"></i>
        <li>
          <a href="#" className="active">{props.navlink}</a>
        </li>
      </ul>
    </div>
    <a href="#" className="download-btn">
      <i className="fas fa-cloud-download-alt"></i>
      <span className="text">Download Report</span>
    </a>
  </div>
  )
}

export default HeadTitle