import React, { useEffect, useRef, useState } from 'react'
import { AiOutlineCloseCircle } from 'react-icons/ai'
import { useDispatch, useSelector } from 'react-redux';
import api from '../../api/api';
import Cookies from 'universal-cookie';
import { ActionTypes } from '../../model/action-type';
import { toast } from 'react-toastify';
import { useTranslation } from 'react-i18next';


function Promo() {

    const cookies = new Cookies();

    const dispatch = useDispatch();

    const closeCanvas = useRef();

    const cart = useSelector((state) => state.cart)
    const setting = useSelector((state) => state.setting)
    const city = useSelector((state) => state.city)

    const [promo_detail, setPromoDetail] = useState(null);

    const amount = cart.checkout && cart.checkout.sub_total;

    const fetchpromo_codes = async () => {
        await api.getPromo(cookies.get('jwt_token'), amount).then(response => response.json())
            .then((result) => {
                if (result.status === 1) {
                    setPromoDetail(result.data)
                }
            })
    }
    const applyPromoCode = async (promo) => {
        await api.setPromo(cookies.get('jwt_token'), promo.promo_code, amount).then(response => response.json()).then((result) => {
            if (result.status) {
                dispatch({ type: ActionTypes.SET_CART_PROMO, payload: result.data });
                toast.success("Coupon Applied Successfully")
                // cart.promo_code && (cart.checkout.total_amount =Number(cart.promo_code.discounted_amount));
                closeCanvas.current.click();
            }
        })
    }

    useEffect(() => {
        if (cart.promo_code) {

        } else {
            cart.checkout && fetchpromo_codes();
        }
    }, [cart])

    const {t} = useTranslation()
    return (
        <>
            <div tabIndex="-1" className={`promo-sidebar-container offcanvas offcanvas-end`} id="promooffcanvas" aria-labelledby="promooffcanvaslabel" >
                <div className='promo-sidebar-header'>
                    <span>{t("coupon")}</span>
                    <button type="button" className="close-canvas bg-transparent" data-bs-dismiss="offcanvas" aria-label="Close" ref={closeCanvas}><AiOutlineCloseCircle size={26} /></button>
                </div>
                <div className="promo-sidebar-body">
                    <div className="row-reverse">
                        {promo_detail && promo_detail.map((promo, index) => (
                            <>

                                <div className="col-12 promo-card" key={index}>
                                    <div className="promo-card-e1">
                                        <div className="promo-details">
                                            <div className="promo-img col-4">
                                                <img src={promo.image_url} alt="" />
                                            </div>
                                            <div className="promo-name">
                                                <span className="promo-code">{promo.promo_code}</span>
                                                <span className="promo-discount">{promo.promo_code_message}</span>
                                            </div>
                                        </div>
                                        <div className="promo-apply">
                                            <span className={`btn ${!promo.is_applicable && 'disabled'}`}
                                                onClick={() => {
                                                    if (promo.is_applicable) {
                                                        applyPromoCode(promo)
                                                    }
                                                }}>{t("apply")}</span>
                                        </div>
                                    </div>
                                    <div className="promo-card-e2">
                                        {promo.is_applicable ?
                                            <span className="promo-description">{`${t("you_will_save")} ${setting.setting && setting.setting.currency} ${promo.discount} ${t("on_this_coupon")}`}</span>
                                            :
                                            <span className="promo-description">{t("not_applicable")}</span>
                                        }
                                    </div>
                                </div>
                            </>
                        ))}
                    </div>
                </div>


            </div>
        </>
    )
}

export default Promo
