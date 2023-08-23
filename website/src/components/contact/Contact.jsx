import React, { useEffect, useState, useSyncExternalStore } from 'react'
import { useSelector } from 'react-redux'
import coverImg from '../../utils/cover-img.jpg'
import './contact.css'
import { AiOutlineMail } from 'react-icons/ai'
import { BiPhoneCall, BiTimeFive } from 'react-icons/bi'
import { GoLocation } from 'react-icons/go'
import Loader from '../loader/Loader'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'

const Contact = () => {

    const setting = useSelector(state => (state.setting))
    const {t} = useTranslation()
    return (
        <section id='contact-us' className='contact-us'>
            {setting.setting === null ? <Loader screen='full' />
                : (
                    <>
                        <div className='cover'>
                            <img src={coverImg} className='img-fluid' alt="cover"></img>
                            <div className='title'>
                                <h3>{t("contact_us")}</h3>
                                <span> <Link to="/" className='text-light text-decoration-none'>{t("home")} /</Link> </span><span className='active'>{t("contact_us")}</span>
                            </div>
                        </div>
                        <div className='container'>
                            <div className='contact-wrapper'  dangerouslySetInnerHTML={{ __html: setting.setting.contact_us }}>

                                

                            </div>
                        </div>
                    </>
                )}


        </section>
    )
}

export default Contact
