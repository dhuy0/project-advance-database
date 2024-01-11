import React from 'react'
import HeadTitle from '../../components/dashboard/HeadTitle'
import UsersList from '../../components/Users/UsersList'
function Patients() {
  return (
    <>
    <HeadTitle navlink = "Patients"/>
    <UsersList/>
    </>
  )
}

export default Patients