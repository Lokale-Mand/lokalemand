import React, { useState, useEffect } from 'react';
import './footer.css';
import { Link, useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import api from '../../api/api'
import { ActionTypes } from '../../model/action-type';
import Loader from '../loader/Loader';
import paystack_svg from '../../utils/ic_paystack.svg'
import paypal_svg from '../../utils/ic_paypal.svg'
import paytm_svg from '../../utils/ic_paytm.svg'
import cod_svg from '../../utils/ic_cod.svg'
import razorpay_svg from '../../utils/ic_razorpay.svg'
import stripe_svg from '../../utils/ic_stripe.svg'
import { useTranslation } from 'react-i18next';

export const Footer = () => {

    const dispatch = useDispatch();
    const navigate = useNavigate();
    const setting = useSelector(state => (state.setting))

    const { t } = useTranslation();

    const fetchCategory = (id = 0) => {
        api.getCategory(id)
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {
                    dispatch({ type: ActionTypes.SET_CATEGORY, payload: result.data });
                }
            })
            .catch(error => console.log("error ", error))
        }
        

    useEffect(() => {
        fetchCategory();
    }, [])

const category = useSelector((state)=>(state.category))    
    
const selectCategory = (ctg) => {
    if (ctg.has_child) {
        
        fetchCategory(ctg.id)
        navigate('/products')
        }else {
            dispatch({ type: ActionTypes.SET_FILTER_CATEGORY, payload: ctg.id })
            navigate('/products')

        }
    }

    return (
        <section id="footer">
            <div className="container pb-3">
                <div className="row ">
                    <div className="col-xs-3 col-sm-3 col-md-3 col-12" >
                        <h5>{t('category_footer')}</h5>

                        {category.category === null
                            ? (

                                <Loader background='none' width='fit-content' height='fit-content' />
                            )
                            : (
                                <ul className='category-list'>
                                    {category.category.map((ctg, index) => (
                                        <li key={index}>
                                            <button className='link' onClick={() => {
                                                selectCategory(ctg)
                                                window.scrollTo({ top: 0, behavior: 'smooth' })
                                            }}>
                                                {ctg.name}
                                            </button>
                                        </li>
                                    ))}
                                </ul>
                            )}

                    </div>

                    <div className="col-xs-3 col-sm-3 col-md-3 col-12">
                        <h5>{t('store_info')}</h5>
                        <ul className="link-list">
                            <li><a href={`https://maps.google.com/?q=${setting.setting !== null ? setting.setting.store_address : "bhuj"}`}>{setting.setting !== null ? setting.setting.store_address : "address"}</a></li>
                            <li><a href={`tel:${setting.setting !== null ? setting.setting.support_number : "number"}`}>{setting.setting !== null ? setting.setting.support_number : "number"}</a></li>
                            <li><a href={`mailto:${setting.setting !== null ? setting.setting.support_email : "email"}`}>{setting.setting !== null ? setting.setting.support_email : "email"}</a></li>

                        </ul>
                    </div>


                    <div className="col-xs-3 col-sm-3 col-md-3 col-12">
                        <h5>{t('company')}</h5>
                        <ul className="link-list" onClick={() => { window.scrollTo({ top: 0, behavior: 'smooth' }) }}>
                            <li><Link to={'/about'}>{t("about_us")}</Link></li>
                            <li><Link to={'/faq'}>{t("faq")}</Link></li>
                            <li><Link to={'/contact'}>{t("contact_us")}</Link></li>
                            <li><Link to={'/terms'}>{t("terms_and_conditions")}</Link></li>
                            <li><Link to={'/policy/Privacy_Policy'}>{t("privacy_policy")}</Link></li>
                            <li><Link to={'/policy/ReturnsAndExchangesPolicy'}>{t("recharge_and_exchange_policy")}</Link></li>
                            <li><Link to={'/policy/Shipping_Policy'}>{t("shipping_policy")}</Link></li>
                            <li><Link to={'/policy/Cancellation_Policy'}>{t("cancellation_policy")}</Link></li>
                        </ul>
                    </div>



                    <div className="col-xs-3 col-sm-3 col-md-3 col-12">
                        <div className=' gap-3'>
                            <div>
                                <h5 className='app-title'>{setting.setting && setting.setting.web_settings.app_title}</h5>
                                {setting.setting ? <>
                                    <div className="download_desc">
                                        <p>{setting.setting.web_settings.app_short_description}</p>
                                    </div>
                                    <div className='gap-3 d-flex justify-content-center'>
                                        {setting.setting.web_settings.is_android_app === "1" ?
                                            <a href={setting.setting.web_settings.android_app_url} className='download-button'>
                                                <img src={setting.setting.web_settings.play_store_logo} alt='google-play'></img>
                                            </a>
                                            : <></>}
                                        {setting.setting.web_settings.is_ios_app === "1" ?
                                            <a href={setting.setting.web_settings.ios_app_url} className='download-button'>
                                                <img src={setting.setting.web_settings.ios_store_logo} alt='google-play'></img>
                                            </a>
                                            : <></>}


                                    </div>
                                </>
                                    : <></>}
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div className="footer ">
                <div className="container flex-sm-row flex-column gap-3 bottom-section-footer">
                    {setting.setting && setting.setting.social_media.length>0 &&
                        <div className="social-media-icons order-sm-0">
                            <span>{t('follow_us')}: 
                            
                             {setting.setting.social_media.map((icon, index)=>{
                                return (
                                <>
                                    <a key={index} href={icon.link} className='socical-icons'><i className={`${icon.icon} fa-lg`} style={{ color: "#fff" }}></i></a>
                                </>
                                )
                            })}
                            </span>
                        </div>
                    }
                    <div className="copyright order-sm-1 order-2">
                        <div className="col-xs-12 col-sm-12 col-md-12 mt-2 mt-sm-2 text-center text-white">
                            <span className='company_name'>{setting.setting !== null ? setting.setting.web_settings.copyright_details : "App Name"}</span>
                        </div>
                    </div>
                    {setting.payment_setting ?
                        <div className="payment_methods_container order-sm-1">
                            {setting.payment_setting.cod_payment_method === "1" ?
                                <span className='payment_methods'>
                                    <img src={cod_svg} alt="" srcSet="" />
                                </span>
                                : <></>}
                            {setting.payment_setting.paystack_payment_method === "1" ?
                                <span className='payment_methods'>
                                    <img src={paystack_svg} alt="" srcSet="" />
                                </span>
                                : <></>}
                            {setting.payment_setting.paypal_payment_method === "1" ?
                                <span className='payment_methods'>
                                    <img src={paypal_svg} alt="" srcSet="" />
                                </span>
                                : <></>}
                            {setting.payment_setting.stripe_payment_method === "1" ?
                                <span className='payment_methods'>
                                    <img src={stripe_svg} alt="" srcSet="" />
                                </span>
                                : <></>}
                            {/* {setting.payment_setting.paytm_payment_method === "1" ?
                                <span className='payment_methods'>
                                    <img src={paytm_svg} alt="" srcSet="" />
                                </span>
                                : <></>} */}
                            {setting.payment_setting.razorpay_payment_method === "1" ?
                                <span className='payment_methods'>
                                    <img src={razorpay_svg} alt="" srcSet="" />
                                </span>
                                : <></>}
                        </div>
                        : <></>}
                </div>
            </div>
        </section>
    );
};