import React from 'react'
import HeadTitle from '../../components/dashboard/HeadTitle'
function Home() {
    const pathSite = [{path : "/dashboard", label : "DashBoard"},
                    {}                        
]
  return (
    <>
    <HeadTitle navlinks = "Home"/>
    <div>Home</div>
    </>
  )
}

export default Home