// UsersList.js

import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import './UsersList.css';
import UserDetail from './UserDetail';

const UsersList = () => {
  const [userData, setUserData] = useState({
    page: 1,
    per_page: 6,
    total: 0,
    total_pages: 1,
    data: [],
  });

  const [selectedUser, setSelectedUser] = useState(null);

  useEffect(() => {
    // Fetch user data from the API
    const fetchUserData = async () => {
      try {
        const response = await fetch('https://reqres.in/api/users?page=1&per_page=6');
        const data = await response.json();
        setUserData(data);
      } catch (error) {
        console.error('Error fetching user data:', error);
      }
    };

    fetchUserData();
  }, []); // Empty dependency array to ensure the effect runs only once

  const handlePageChange = async (pageNumber) => {
    try {
      const response = await fetch(`https://reqres.in/api/users?page=${pageNumber}&per_page=6`);
      const data = await response.json();
      setUserData(data);
    } catch (error) {
      console.error('Error fetching user data:', error);
    }
  };

  const handleDetailsClick = (user) => {
    setSelectedUser(user);
  };

  const handleCloseDetails = () => {
    setSelectedUser(null);
  };

  return (
    <div className="hospital-theme">
      <table>
        <thead>
          <tr>
            <th>Id</th>
            <th>Email</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Avatar</th>
            <th>Details</th>
          </tr>
        </thead>
        <tbody>
          {userData.data.map((user) => (
            <React.Fragment key={user.id}>
              <tr>
                <td>{user.id}</td>
                <td>{user.email}</td>
                <td>{user.first_name}</td>
                <td>{user.last_name}</td>
                <td>
                  <img src={user.avatar} alt={`Avatar of ${user.first_name}`} />
                </td>
                <td>
                <Link to={`/user/${user.id}`}>Details</Link>
                </td>
              </tr>
              {selectedUser && selectedUser.id === user.id && (
                <tr>
                  <td colSpan="6">
                    <UserDetail user={selectedUser} />
                  </td>
                </tr>
              )}
            </React.Fragment>
          ))}
        </tbody>
      </table>

      {/* Pagination */}
      <div className="pagination">
        {Array.from({ length: userData.total_pages }, (_, index) => (
          <button
            key={index + 1}
            onClick={() => handlePageChange(index + 1)}
            className={userData.page === index + 1 ? 'active' : ''}
          >
            {index + 1}
          </button>
        ))}
      </div>

      {/* User Details Modal */}
      {selectedUser && (
        <div className="user-details-modal">
          <div className="modal-content">
            <span className="close" onClick={handleCloseDetails}>
              &times;
            </span>
            <h2>User Details</h2>
            {/* Display user details here if needed */}
          </div>
        </div>
      )}
    </div>
  );
};

export default UsersList;
