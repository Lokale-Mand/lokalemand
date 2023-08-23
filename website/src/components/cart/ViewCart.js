import React, { useEffect, useState } from 'react'
import './cart.css'
import { useSelector, useDispatch } from 'react-redux'
import { FaRupeeSign } from "react-icons/fa";
import { BsPlus } from "react-icons/bs";
import { BiMinus } from 'react-icons/bi'
import api from '../../api/api';
import { toast } from 'react-toastify'
import Cookies from 'universal-cookie'
import { ActionTypes } from '../../model/action-type';
import EmptyCart from '../../utils/zero-state-screens/Empty_Cart.svg'
import { useNavigate, Link } from 'react-router-dom';
import coverImg from '../../utils/cover-img.jpg'
import { RiCoupon2Fill, RiDeleteBinLine } from 'react-icons/ri'
import Loader from '../loader/Loader';
import { motion, useTransform } from 'framer-motion'
import { Dropdown } from 'react-bootstrap';
import Promo from './Promo';
import { useTranslation } from 'react-i18next';


const ViewCart = () => {


    const dispatch = useDispatch();
    const cookies = new Cookies();
    const navigate = useNavigate();

    const cart = useSelector(state => (state.cart))
    const city = useSelector(state => (state.city))
    const sizes = useSelector(state => (state.productSizes))
    const setting = useSelector(state => (state.setting))

    const [productSizes, setproductSizes] = useState(null)
    const [iscartEmpty, setiscartEmpty] = useState(false)
    const [isLoader, setisLoader] = useState(false)

    useEffect(() => {
        if (sizes.sizes === null || sizes.status === 'loading') {
            if (city.city !== null && cart.cart !== null) {
                api.getProductbyFilter(city.city.id, city.city.latitude, city.city.longitude)
                    .then(response => response.json())
                    .then(result => {
                        if (result.status === 1) {
                            setproductSizes(result.sizes)
                            dispatch({ type: ActionTypes.SET_PRODUCT_SIZES, payload: result.sizes })
                        }
                    })
            }
        }
        else {
            setproductSizes(sizes.sizes)
        }

        if (cart.cart === null && cart.status === 'fulfill') {
            setiscartEmpty(true)
        }
        else {
            setiscartEmpty(false)
        }

    }, [cart])



    //Add to Cart
    const addtoCart = async (product_id, product_variant_id, qty) => {
        setisLoader(true)

        await api.addToCart(cookies.get('jwt_token'), product_id, product_variant_id, qty)
            .then(response => response.json())
            .then(async (result) => {
                if (result.status === 1) {
                    toast.success(result.message)
                    await api.getCart(cookies.get('jwt_token'), city.city.latitude, city.city.longitude)
                        .then(resp => resp.json())
                        .then(res => {
                            setisLoader(false)

                            if (res.status === 1) {
                                dispatch({ type: ActionTypes.SET_CART, payload: res })
                            }

                        })
                    await api.getCart(cookies.get('jwt_token'), city.city.latitude, city.city.longitude, 1)
                        .then(resp => resp.json())
                        .then(res => {
                            setisLoader(false)

                            if (res.status === 1)
                                dispatch({ type: ActionTypes.SET_CART_CHECKOUT, payload: res.data })
                        })
                }
                else {
                    setisLoader(false)
                    toast.error(result.message)
                }
            })
    }

    //remove from Cart
    const removefromCart = async (product_id, product_variant_id) => {
        setisLoader(true)
        await api.removeFromCart(cookies.get('jwt_token'), product_id, product_variant_id)
            .then(response => response.json())
            .then(async (result) => {
                if (result.status === 1) {
                    toast.success(result.message)
                    await api.getCart(cookies.get('jwt_token'), city.city.latitude, city.city.longitude)
                        .then(resp => resp.json())
                        .then(res => {
                            setisLoader(false)
                            if (res.status === 1) {
                                dispatch({ type: ActionTypes.SET_CART, payload: res })
                            }
                            else {
                                dispatch({ type: ActionTypes.SET_CART, payload: null })
                            }
                        })
                        .catch(error => console.log(error))
                    await api.getCart(cookies.get('jwt_token'), city.city.latitude, city.city.longitude, 1)
                        .then(resp => resp.json())
                        .then(res => {
                            setisLoader(false)

                            if (res.status === 1)
                                dispatch({ type: ActionTypes.SET_CART_CHECKOUT, payload: res.data })
                        })
                }
                else {
                    setisLoader(false)
                    toast.error(result.message)
                }
            })
            .catch(error => console.log(error))
    }
    const { t } = useTranslation();

    return (
        <section id='viewcart' className='viewcart'>
            <div className='cover'>
                <img src={coverImg} className='img-fluid' alt="cover"></img>
                <div className='title'>
                    <h3>Cart</h3>
                    <span><Link to='/' className='text-light text-decoration-none'>Home / </Link></span><span className='active'>cart</span>
                </div>

            </div>

            <div className="view-cart-container">
                <div className='container'>

                    {iscartEmpty ? (
                        <div className='empty-cart co-12'>
                            <img src={EmptyCart} alt='empty-cart'></img>
                            <p>{t("empty_cart_list_message")}</p>
                            <span>{t("empty_cart_list_description")}</span>
                            <button type='button' onClick={() => {
                                navigate('/products')
                            }}>{t("empty_cart_list_button_name")}</button>
                        </div>) : (
                        <>
                            {cart.cart === null || productSizes === null
                                ? (
                                    <Loader screen='full' />
                                )
                                : (
                                    <>
                                        {isLoader ? <Loader screen='full' background='none' /> : null}
                                        <div className="row">

                                            <div className='viewcart-product-wrapper col-8'>
                                                <div className='product-heading'>
                                                    <h3>{t("your_cart")}</h3>
                                                    <span>{t("there_are")} </span><span className='title'>{cart.cart.total}</span> <span> {t("product_in_your_cart")}  </span>
                                                </div>

                                                <table className='products-table table'>
                                                    <thead>
                                                        <tr>
                                                            <th className='first-column'>{t("product")}</th>
                                                            <th className='hide-mobile'>{t("unit")}</th>
                                                            <th>{t("price")}</th>
                                                            <th>{("quantity")}</th>
                                                            <th className='hide-mobile'>{t("sub_total")}</th>
                                                            <th className='last-column'>{t("remove")}</th>
                                                        </tr>
                                                    </thead>

                                                    <tbody>
                                                        {cart.cart.data.cart.map((product, index) => (
                                                            <tr key={index} >
                                                                <th className='products-image-container first-column'>
                                                                    <div className='image-container'>
                                                                        <img src={product.image_url} alt='product'></img>
                                                                    </div>

                                                                    <div className=''>
                                                                        <span>{product.measurement} {product.unit} | {product.name}</span>

                                                                    </div>
                                                                </th>

                                                                <th className='unit hide-mobile'>
                                                                    {product.qty}
                                                                </th>

                                                                <th className='price'>
                                                                {setting.setting && setting.setting.currency}
                                                                    {(product.discounted_price === 0 ? product.price.toFixed(setting.setting && setting.setting.decimal_point) : product.discounted_price.toFixed(setting.setting && setting.setting.decimal_point))}
                                                                </th>

                                                                <th className='quantity'>
                                                                    <div>
                                                                        <button type='button' onClick={() => {

                                                                            if (product.qty > 1) {

                                                                                addtoCart(product.product_id, product.product_variant_id, product.qty - 1)

                                                                            }

                                                                        }}><BiMinus fill='#fff' fontSize={'2rem'} /></button>
                                                                        <span >{product.qty}</span>
                                                                        <button type='button' onClick={() => {
                                                                            if (product.is_unlimited_stock === 1) {
                                                                                if (Number(product.qty) < Number(setting.setting.max_cart_items_count)) {
                                                                                    addtoCart(product.product_id, product.product_variant_id, product.qty + 1)
                                                                                } else {
                                                                                    toast.error('Apologies, maximum product quantity limit reached!')
                                                                                }
                                                                            } else {
                                                                                if (Number(product.qty) >= Number(product.stock)) {
                                                                                    toast.error(t("out_of_stock_message"))

                                                                                } else if (Number(product.qty) >= Number(setting.setting.max_cart_items_count)) {
                                                                                    toast.error('Apologies, maximum product quantity limit reached!')
                                                                                }
                                                                                else {
                                                                                    addtoCart(product.product_id, product.product_variant_id, product.qty + 1)
                                                                                }
                                                                            }
                                                                        }}><BsPlus fill='#fff' fontSize={'2rem'} /></button>
                                                                    </div>

                                                                </th>

                                                                <th className='subtotal hide-mobile'>
                                                                    {setting.setting && setting.setting.currency}

                                                                    {(product.price * product.qty).toFixed(setting.setting && setting.setting.decimal_point)}
                                                                </th>

                                                                <th className='remove last-column'>
                                                                    <button whileTap={{ scale: 0.8 }} type='button' onClick={() => removefromCart(product.product_id, product.product_variant_id)}>
                                                                        <RiDeleteBinLine fill='red' fontSize={'2.985rem'} />
                                                                    </button>
                                                                </th>
                                                            </tr>
                                                        ))}
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div className="billing col-3">
                                                <div className="promo-section">

                                                    <div className="heading">
                                                        <span>{t("coupon")}</span>
                                                    </div>
                                                    <div className="promo-wrapper">
                                                        <div className="promo-container">
                                                            <div className="promo-button ">
                                                                <span className="">{t("have_coupon")}</span>
                                                                <button className="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#promooffcanvas" aria-controls="promooffcanvaslabel">{t("viewCoupon")}</button>
                                                            </div>
                                                            {cart.cart && cart.promo_code ?
                                                                <>
                                                                    <div className="promo-code">
                                                                        <div className="">
                                                                            <span><RiCoupon2Fill size={26} fill='var(--secondary-color)' /></span>
                                                                        </div>
                                                                        <div className="d-flex flex-column">
                                                                            <span className='promo-name'>{cart.promo_code.promo_code}</span>
                                                                            <span className='promo-discount-amount'>{cart.promo_code.message}</span>
                                                                        </div>
                                                                        <div className="d-flex flex-column">
                                                                            <span>{setting.setting && setting.setting.currency} {cart.promo_code.discount}</span>
                                                                            <span className='promo-remove' onClick={() => {
                                                                                dispatch({ type: ActionTypes.SET_CART_PROMO, payload: null });
                                                                                toast.info("Coupon Removed")
                                                                            }}> {t("remove")}</span>
                                                                        </div>
                                                                    </div>
                                                                </>
                                                                : <></>}
                                                        </div>
                                                    </div>

                                                </div>
                                                <div className='cart-summary-wrapper'>
                                                    <div className='heading'>
                                                        <span >{t("cart")} {t("total")}</span>
                                                    </div>
                                                    {cart.checkout === null
                                                        ? (<div className="d-flex justify-content-center">
                                                            <div className="spinner-border" role="status">
                                                                <span className="visually-hidden">Loading...</span>
                                                            </div>
                                                        </div>)
                                                        : (
                                                            <div className='summary'>
                                                                <div className='d-flex justify-content-between'>
                                                                    <span>{t("sub_total")}</span>
                                                                    <div className='d-flex align-items-center'>
                                                                        {setting.setting && setting.setting.currency}
                                                                        <span>{(cart.checkout.sub_total).toFixed(setting.setting && setting.setting.decimal_point)}</span>
                                                                    </div>
                                                                </div>

                                                                <div className='d-flex justify-content-between'>
                                                                    <span>{t("delivery_charge")}</span>
                                                                    <div className='d-flex align-items-center'>
                                                                        {setting.setting && setting.setting.currency}
                                                                        <span>{(cart.checkout.delivery_charge.total_delivery_charge).toFixed(setting.setting && setting.setting.decimal_point)}</span>
                                                                    </div>
                                                                </div>
                                                                {cart.promo_code && <>
                                                                    <div className='d-flex justify-content-between'>
                                                                        <span>{t("discount")}</span>
                                                                        <div className='d-flex align-items-center'>

                                                                            <span>-   {setting.setting && setting.setting.currency}{(cart.promo_code.discount).toFixed(setting.setting && setting.setting.decimal_point)}</span>
                                                                        </div>
                                                                    </div>
                                                                </>}

                                                                <div className='d-flex justify-content-between total'>
                                                                    <span>{t("total")}</span>
                                                                    <div className='d-flex align-items-center total-amount'>
                                                                        {setting.setting && setting.setting.currency}
                                                                        {cart.promo_code ?
                                                                            <span>{(cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge)}</span>
                                                                            : <>
                                                                                <span>{cart.checkout.total_amount.toFixed(setting.setting && setting.setting.decimal_point)}</span>
                                                                            </>}
                                                                    </div>
                                                                </div>


                                                                <div className='button-container'>
                                                                    <Link to='/checkout' className='checkout'>{t("proceed_to_checkout")}</Link>
                                                                </div>

                                                            </div>)}



                                                </div>
                                            </div>
                                        </div>
                                    </>
                                )}
                        </>
                    )}
                </div>
            </div>
            <Promo />
        </section>

    )
}

export default ViewCart
