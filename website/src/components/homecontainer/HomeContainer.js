import React, { useRef } from 'react'
import { AiOutlineArrowRight } from 'react-icons/ai'
import { FaChevronLeft, FaChevronRight } from 'react-icons/fa'
import { Link } from 'react-router-dom'
import Category from '../category/Category'
import Slider from '../sliders/Slider'
import './homecontainer.css'
import Offers from '../offer/Offers'
import { useSelector } from 'react-redux'

const HomeContainer = () => {
    const shop = useSelector((state) => state.shop)
    return (

        // elementor-section-height-min-height elementor-section-items-stretch elementor-section-boxed elementor-section-height-default
        <section id="home" className='home-section container home-element section'>
            {/* Slider & Category */}
            

            <div className='home-container row'>
                <div className="col-md-12 p-0 col-12">
                    <Slider />
                </div>
            </div>

            
            <div className='category_section'>
                <div className="container">

                    <Category />

                </div>
            </div>

            
        </section>

    )
}

export default HomeContainer
