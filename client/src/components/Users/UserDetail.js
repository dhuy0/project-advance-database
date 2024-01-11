// UserDetail.js

import React, { useState } from 'react';

const UserDetail = ({ user }) => {
  const [editableFields, setEditableFields] = useState({
    name: user.name || '',
    age: user.age || '',
    gender: user.gender || '',
    totalFees: user.totalFees || '',
    totalPaid: user.totalPaid || '',
    dentalHealthInfo: user.dentalHealthInfo || '',
    allergyNote: user.allergyNote || '',
    againstDrugNote: user.againstDrugNote || '',
    plantTreatment: user.plantTreatment || '',
    paymentInfo: user.paymentInfo || '',
  });

  const handleFieldChange = (fieldName, value) => {
    setEditableFields((prevFields) => ({
      ...prevFields,
      [fieldName]: value,
    }));
  };

  const handleSaveChanges = () => {
    // Implement your logic to save changes, for example, call an API
    console.log('Saving changes:', editableFields);
    // You may want to update the user object in the parent component or make an API call to save the changes.
  };

  return (
    <div className="user-detail">
      <h2>User Details</h2>
      <div>
        <label>Name:</label>
        <input
          type="text"
          value={editableFields.name}
          onChange={(e) => handleFieldChange('name', e.target.value)}
        />
      </div>
      <div>
        <label>Age:</label>
        <input
          type="text"
          value={editableFields.age}
          onChange={(e) => handleFieldChange('age', e.target.value)}
        />
      </div>
      <div>
        <label>Gender:</label>
        <input
          type="text"
          value={editableFields.gender}
          onChange={(e) => handleFieldChange('gender', e.target.value)}
        />
      </div>
      {/* Add similar sections for other fields */}
      <div>
        <button onClick={handleSaveChanges}>Save Changes</button>
      </div>
    </div>
  );
};

export default UserDetail;
