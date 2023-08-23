import React from 'react'
import { useSelector } from 'react-redux'
import coverImg from '../../utils/cover-img.jpg'
import './policy.css'
import Loader from '../loader/Loader';
import { Link, useParams } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

const Policy = () => {

    const setting = useSelector(state => (state.setting))
    const { policy_type } = useParams()
    const { t } = useTranslation()
    return (
        <section id='policy' className='policy'>
            {setting.setting === null ? <Loader screen='full' />
                : (
                    <>
                        <div className='cover'>
                            <img src={coverImg} className='img-fluid' alt="cover"></img>
                            <div className='title'>
                                <h3>{policy_type === 'Privacy_Policy'
                                    ? <span className='active'>{t("privacy_policy")}</span>
                                    : policy_type === 'ReturnsAndExchangesPolicy'
                                        ? <span className='active'>{t("recharge_and_exchange_policy")}</span>
                                        : policy_type === 'Shipping_Policy'
                                            ? <span className='active'>{t("shipping_policy")}y</span>
                                            : policy_type === 'Cancellation_Policy'
                                                ? <span className='active'>{t("cancellation_policy")}</span>
                                                : null}</h3>
                                <span> <Link to="/" className='text-light text-decoration-none'>{t("Home")} /</Link> </span>{policy_type === 'Privacy_Policy'
                                    ? <span className='active'>{t("privacy_policy")}</span>
                                    : policy_type === 'ReturnsAndExchangesPolicy'
                                        ? <span className='active'>{t("recharge_and_exchange_policy")}</span>
                                        : policy_type === 'Shipping_Policy'
                                            ? <span className='active'>{t("ShippingPolic")}y</span>
                                            : policy_type === 'Cancellation_Policy'
                                                ? <span className='active'>{t("cancellation_policy")}</span>
                                                : null}
                            </div>
                        </div >
                        <div className='container'>
                            {policy_type === 'Privacy_Policy'
                                ? <div className='policy-container' dangerouslySetInnerHTML={{ __html: setting.setting.privacy_policy }}></div>
                                : policy_type === 'ReturnsAndExchangesPolicy'
                                    ? <div className='policy-container' dangerouslySetInnerHTML={{ __html: setting.setting.returns_and_exchanges_policy }}></div>
                                    : policy_type === 'Shipping_Policy'
                                        ? <div className='policy-container' dangerouslySetInnerHTML={{ __html: setting.setting.shipping_policy }}></div>
                                        : policy_type === 'Cancellation_Policy'
                                            ? <div className='policy-container' dangerouslySetInnerHTML={{ __html: setting.setting.cancellation_policy }}></div>
                                            : null}

                        </div>
                    </>
                )}
        </section>
    )
}

export default Policy
