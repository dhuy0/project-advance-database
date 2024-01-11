// HeadTitle.js

import React from 'react';
import { NavLink, useLocation } from 'react-router-dom';

import './HeadTitle.css';

function HeadTitle(props) {
  const location = useLocation();
  const pathnames = location.pathname.split('/').filter((x) => x);

  return (
    <div className="head-title">
      <div className="left">
        <h1>Dashboard</h1>
        <ul className="breadcrumb">
          <li>
            <NavLink to="/">Dashboard</NavLink>
          </li>
          {pathnames.map((pathname, index) => (
            <React.Fragment key={index}>
              <i className="fas fa-chevron-right"></i>
              <li>
                {index === pathnames.length - 1 ? (
                  <a href="#" className="active">
                    {pathname}
                  </a>
                ) : (
                  <NavLink to={`/${pathnames.slice(0, index + 1).join('/')}`}>{pathname}</NavLink>
                )}
              </li>
            </React.Fragment>
          ))}
        </ul>
      </div>
      <a href="#" className="download-btn">
        <i className="fas fa-cloud-download-alt"></i>
        <span className="text">Download Report</span>
      </a>
    </div>
  );
}

export default HeadTitle;
