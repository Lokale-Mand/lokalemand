import React from 'react'
import './slider.css'
// Import Swiper React components
import { Swiper, SwiperSlide } from "swiper/react";
import { Navigation, Thumbs, Mousewheel, Autoplay, Pagination } from "swiper";
import "swiper/css/pagination";
import "swiper/css";
import { useDispatch, useSelector } from 'react-redux';
import Loader from '../loader/Loader';
import { ActionTypes } from '../../model/action-type';
import { useNavigate } from 'react-router-dom';
import { setSelectedProductId } from '../../utils/manageLocalStorage';


// import slider3 from '../../utils/sliders/slider3.jpg'
// import slider4 from '../../utils/sliders/slider4.jpg'
// import slider5 from '../../utils/sliders/slider5.jpg'


const Slider = () => {

    const navigate = useNavigate()
    const dispatch = useDispatch()

    const language = useSelector((state)=> (state.language))
    const handleImageUrl = (slide) => {
        switch (slide.type) {
            case "default":

                break;
            case "category":
                dispatch({ type: ActionTypes.SET_FILTER_CATEGORY, payload: slide.type_id })
                navigate('/products/')
                break;
            case "product":
                dispatch({ type: ActionTypes.SET_SELECTED_PRODUCT, payload: slide.type_id });
                setSelectedProductId(slide.type_id)
                navigate('/product/')
                break;

            default:
                break;
        }
    }

    const setting  = useSelector(state=>state.setting)
    const shop = useSelector(state => state.shop);

    const placeHolderImage = (e) =>{
        e.target.src = setting.setting?.web_logo
    }
    return (
        <div className='slider '>
            {
                shop.shop === null
                    ? (
                        <Loader width='100%' height='500px' screen='full' />
                    )
                    : (
                        <div className="slider__flex ">
                            <div className="slider__images">
                                <Swiper

                                    loop={true}
                                    autoplay={{
                                        delay: 3000,
                                        disableOnInteraction: false,
                                    }}
                                    centeredSlides={false}
                                    // thumbs={{ swiper: imagesNavSlider && !imagesNavSlider.destroyed ? imagesNavSlider : null }}
                                    direction="horizontal"
                                    slidesPerView={1}
                                    spaceBetween={15}
                                    mousewheel={false}

                                    breakpoints={{
                                        0: {
                                            direction: "horizontal"
                                        },
                                        768: {
                                            direction: "horizontal"
                                        }
                                    }}
                                    className="swiper-container2"
                                    modules={[Navigation, Thumbs, Mousewheel, Autoplay, Pagination]}
                                    pagination={{
                                        dynamicBullets: true,
                                    }}
                                    navigation={true}
                                    key={language.current_language && language.current_language.type }
                                >

                                    {shop.shop.sliders.map((sld, index) => {
                                        return (

                                            <SwiperSlide key={index} >
                                                {sld.type==="slider_url" ?
                                                    <a href={sld.slider_url}>
                                                        <div className="slider__image" onClick={() => handleImageUrl(sld)}>
                                                            <img src={sld.image_url} onError={placeHolderImage} alt={sld.type} id='slider-photo' />
                                                        </div>
                                                    </a>
                                                    :
                                                    <div className="slider__image" onClick={() => handleImageUrl(sld)}>
                                                        <img src={sld.image_url} alt={sld.type} id='slider-photo' />
                                                    </div>
                                                }
                                            </SwiperSlide>

                                        );
                                    })}




                                </Swiper>
                            </div>



                        </div>
                    )
            }
        </div>
    )
}

export default Slider
