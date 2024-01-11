import React from 'react'


import SideBar from '../components/dashboard/SideBar';
import NavBar from '../components/dashboard/NavBar';
import HeadTitle from '../components/dashboard/HeadTitle';
import './DashBoard.css'
function DashBoard() {

  return (
    <>
    <SideBar/>
    <section className="content">
      <NavBar/>
      <main>
        <HeadTitle navlink = "Home"/>
        <div className="box-info">
          <li>
            <i className="fas fa-calendar-check"></i>
            <span className="text">
              <h3>1.5K</h3>
              <p>New Orders</p>
            </span>
          </li>
          <li>
            <i className="fas fa-people-group"></i>
            <span className="text">
              <h3>1M</h3>
              <p>Clients</p>
            </span>
          </li>
          <li>
            <i className="fas fa-dollar-sign"></i>
            <span className="text">
              <h3>$900k</h3>
              <p>Turnover</p>
            </span>
          </li>
        </div>

        <div className="table-data">
          <div className="order">
            <div className="head">
              <h3>Recent Orders</h3>
              <i className="fas fa-search"></i>
              <i className="fas fa-filter"></i>
            </div>

            <table>
              <thead>
                <tr>
                  <th>User</th>
                  <th>Order Date</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>
                    <img src="profile.png" alt="" />
                    <p>User Name</p>
                  </td>
                  <td>07-05-2023</td>
                  <td><span className="status pending">Pending</span></td>
                </tr>
                <tr>
                  <td>
                    <img src="profile.png" alt="" />
                    <p>User Name</p>
                  </td>
                  <td>07-05-2023</td>
                  <td><span className="status pending">Pending</span></td>
                </tr>
                <tr>
                  <td>
                    <img src="profile.png" alt="" />
                    <p>User Name</p>
                  </td>
                  <td>07-05-2023</td>
                  <td><span className="status process">Process</span></td>
                </tr>
                <tr>
                  <td>
                    <img src="profile.png" alt="" />
                    <p>User Name</p>
                  </td>
                  <td>07-05-2023</td>
                  <td><span className="status process">Process</span></td>
                </tr>
                <tr>
                  <td>
                    <img src="profile.png" alt="" />
                    <p>User Name</p>
                  </td>
                  <td>07-05-2023</td>
                  <td><span className="status complete">Complete</span></td>
                </tr>
              </tbody>
            </table>
          </div>

        </div>
      </main>
    </section>
    </>
  )
}

export default DashBoard;