import React from 'react'
import Navbar from "../components/Navbar";
import Hero from "../components/Hero";
import Insurance from "../components/Insurance";
import Services from "../components/Services";
import Team from "../components/Team";
import Testimonials from "../components/Testimonials";
import FAQs from "../components/FAQs";
import Contact from "../components/Contact";
import Footer from "../components/Footer";
import Features from "../components/Features";


function LadingPage() {
  return (
    <div>
      <Navbar />
      <Hero />
      <Services />
      <Insurance />
      <Features  /> 
      <Team />
      <Testimonials />
      <FAQs />
      <Contact />
      < Footer />
    </div>
  )
}

export default LadingPage