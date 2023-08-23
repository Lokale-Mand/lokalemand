import React from 'react'
import { useSelector } from 'react-redux'
import coverImg from '../../utils/cover-img.jpg'
import './about.css'
import Loader from '../loader/Loader';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';

const About = () => {

    const setting = useSelector(state => state.setting);
    const {t} = useTranslation()

    const placeHolderImage = (e) =>{
        e.target.src = setting.setting?.web_logo
    }
    return (
        <section id='about-us' className='about-us'>
            {setting.status === 'loading' || setting.setting === null
                ? (
                    <Loader screen='full' />
                )
                : (
                    <>
                        <div className='cover'>
                            <img src={coverImg} className='img-fluid' alt="cover" onError={placeHolderImage}></img>
                            <div className='title'>
                                <h3>{t("about_us")}</h3>
                                <span> <Link to="/" className='text-light text-decoration-none'>{t("home")} /</Link> </span><span className='active'>{t("about_us")}</span>
                            </div>
                        </div >
                        <div className='container'>
                            <div className='about-container' dangerouslySetInnerHTML={{ __html: setting.setting.about_us }}></div>
                        </div>
                    </>

                )}
        </section >
    )
}

export default About
