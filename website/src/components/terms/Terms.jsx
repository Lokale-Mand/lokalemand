import React from 'react'
import { useSelector } from 'react-redux'
import coverImg from '../../utils/cover-img.jpg'
import './terms.css'
import Loader from '../loader/Loader';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';

const Terms = () => {
    const setting = useSelector(state => (state.setting))
    const {t} = useTranslation()
    return (
        <section id='terms' className='terms'>
            {setting.setting === null ? <Loader screen='full' />
                : (
                    <>
                        <div className='cover'>
                            <img src={coverImg} className='img-fluid' alt="cover"></img>
                            <div className='title'>
                                <h3>{t("terms_and_conditions")}</h3>
                                <span> <Link to="/" className='text-light text-decoration-none'>{t("home")} /</Link> </span><span className='active'>{t("terms_and_conditions")}</span>
                            </div>
                        </div >
                        <div className='container'>
                            <div className='terms-container' dangerouslySetInnerHTML={{ __html: setting.setting.terms_conditions }}></div>
                        </div>
                    </>
                )}
        </section>
    )
}

export default Terms
