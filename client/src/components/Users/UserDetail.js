// UserDetails.js

import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';

const UserDetails = () => {
  const { patientId } = useParams();
  console.log(patientId)
  const [userDetails, setUserDetails] = useState(null);

  useEffect(() => {
    // Fetch user details based on the ID
    const fetchUserDetails = async () => {
      try {
        const response = await fetch(`https://reqres.in/api/users/${patientId}`);
        const data = await response.json();
        setUserDetails(data.data); // Assuming the user details are present in the 'data' property
      } catch (error) {
        console.error('Error fetching user details:', error);
      }
    };

    fetchUserDetails();
  }, [patientId]); // Re-run effect when the 'id' parameter changes

  return (
    <div className="hospital-theme">
      <h2>User Details</h2>
      {userDetails ? (
        <div>
          <p>ID: {userDetails.id}</p>
          <p>Email: {userDetails.email}</p>
          <p>First Name: {userDetails.first_name}</p>
          <p>Last Name: {userDetails.last_name}</p>
          <img src={userDetails.avatar} alt={`Avatar of ${userDetails.first_name}`} />
          {/* Display other user details here based on your data structure */}
        </div>
      ) : (
        <p>Loading...</p>
      )}
    </div>
  );
};

export default UserDetails;
