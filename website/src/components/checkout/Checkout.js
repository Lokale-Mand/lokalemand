import React, { memo, useRef, useEffect, useState, useCallback } from 'react'
import { Calendar } from 'react-calendar'
import coverImg from '../../utils/cover-img.jpg'
import Address from '../address/Address'
import './checkout.css'
import 'react-calendar/dist/Calendar.css'
import api from '../../api/api'
import rozerpay from '../../utils/ic_razorpay.svg'
import paystack from '../../utils/ic_paystack.svg'
import Stripe from '../../utils/ic_stripe.svg'
import cod from '../../utils/ic_cod.svg'
import { useDispatch, useSelector } from 'react-redux'
import paypal from "../../utils/ic_paypal.svg"
import { FaRupeeSign } from "react-icons/fa";
import Cookies from 'universal-cookie'
import { toast } from 'react-toastify'
import { Link, useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import Modal from 'react-bootstrap/Modal';

//lottie animation JSONs
import Lottie, { useLottie } from 'lottie-react';
import animate1 from '../../utils/order_placed_back_animation.json'
import animate2 from '../../utils/order_success_tick_animation.json'

//payment methods
import useRazorpay from 'react-razorpay'
import { loadStripe } from '@stripe/stripe-js';
import {
    Elements,
} from '@stripe/react-stripe-js';
// import CheckoutForm from './CheckoutForm'
import InjectCheckout from './StripeModal'
import PaystackPop from '@paystack/inline-js';
import Loader from '../loader/Loader'
import { Button } from 'react-bootstrap'
import { ActionTypes } from '../../model/action-type';
import { RiCoupon2Fill } from 'react-icons/ri'
import Promo from '../cart/Promo'
import { PayPalButtons, PayPalScriptProvider } from '@paypal/react-paypal-js'
import { useTranslation } from 'react-i18next'



const Checkout = () => {
    const dispatch = useDispatch()
    const city = useSelector(state => state.city);
    const cart = useSelector(state => (state.cart))
    const address = useSelector((state)=>state.address)
    const user = useSelector(state => (state.user))
    const setting = useSelector(state => (state.setting))
    const [paymentUrl, setpaymentUrl] = useState(null)
    
    const paypalStatus = useRef(false);
    
    const cookies = new Cookies();
    const navigate = useNavigate()
    
    const stripePromise = loadStripe(setting.payment_setting && setting.payment_setting.stripe_publishable_key)




    const [IsOrderPlaced, setIsOrderPlaced] = useState(false);
    useEffect(() => {
        if (cookies.get('jwt_token') === undefined) {
            toast.error("You are unauthorized!!")
            navigate('/')
        }
        else {
            fetchTimeSlot()
            // fetchOrders()
        }
    }, [])
    useEffect(() => {

        const handleMessage = (event) => {
            if (event.origin === api.getAppUrl()) {
                if (event.data === "success") {
                    paypalStatus.current = true;
                    setShow(true);
                    setIsOrderPlaced(true);
                } else {
                    toast.error("Payment failed");
                }
            }
        };


        window.addEventListener('message', handleMessage);
        // Clean up by removing the event listener when the component unmounts
        return () => {
            window.removeEventListener('message', handleMessage);
        };

    }, [window])

    const [timeslots, settimeslots] = useState(null)
    const [selectedAddress, setselectedAddress] = useState(null)
    const [expectedDate, setexpectedDate] = useState(new Date())
    const [expectedTime, setexpectedTime] = useState(null)
    const [paymentMethod, setpaymentMethod] = useState("COD")
    const [deliveryTime, setDeliveryTime] = useState("")
    const [orderID, setOrderID] = useState(null)
    const [loadingPlaceOrder, setloadingPlaceOrder] = useState(false)
    const [stripeOrderId, setstripeOrderId] = useState(null)
    const [stripeClientSecret, setstripeClientSecret] = useState(null)
    const [stripeTransactionId, setstripeTransactionId] = useState(null)
    const [show, setShow] = useState(false);
    // const [paymentSettings, setpaymentSettings] = useState(null)
    const [isLoader, setisLoader] = useState(false)
    const fetchTimeSlot = () => {
        api.fetchTimeSlot()
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {
                    settimeslots(result.data)
                    setexpectedTime(result.data.time_slots[0])
                }
            })
            .catch(error => console.log(error))

    }
    const Razorpay = useRazorpay()
    const handleRozarpayPayment = useCallback(
        (order_id, razorpay_transaction_id, amount, name, email, mobile, app_name) => {
            // const amount = total_amount
            // const name = user.user.name
            // const email = user.user.email
            // const mobile = user.user.mobile
            const key = setting.payment_setting && setting.payment_setting.razorpay_key
            const options = {
                key: key,
                amount: amount * 100,
                currency: "INR",
                name: name,
                description: app_name,
                image: setting.setting && setting.setting.web_settings.web_logo,
                order_id: razorpay_transaction_id,
                handler: async (res) => {
                    if (res.razorpay_payment_id) {
                        setloadingPlaceOrder(true)
                        await api.addRazorpayTransaction(cookies.get('jwt_token'), order_id, res.razorpay_payment_id, res.razorpay_order_id, res.razorpay_payment_id, res.razorpay_signature)
                            .then(response => response.json())
                            .then(result => {
                                setloadingPlaceOrder(false)
                                if (result.status === 1) {
                                    toast.success(result.message)
                                    setIsOrderPlaced(true);
                                    setShow(true)
                                }
                                else {
                                    toast.error(result.message)
                                }
                            })
                            .catch(error => console.log(error))
                        //Add Transaction
                    }


                },
                prefill: {
                    name: name,
                    email: email,
                    contact: mobile,
                },
                notes: {
                    address: "Razorpay Corporate ",
                },
                theme: {
                    color: setting.setting && setting.setting.web_settings.color,
                },
            };

            const rzpay = new Razorpay(options);
            rzpay.on('payment.failed', function (response) {
                console.log(response.error)
            })
            rzpay.open()
        },
        [Razorpay]
    )


    const handlePayStackPayment = (email, amount, currency, support_email, orderid) => {
        let handler = PaystackPop.setup({
            key: setting.payment_setting && setting.payment_setting.paystack_public_key,
            email: email,
            amount: parseFloat(amount) * 100,
            currency: currency,
            ref: (new Date()).getTime().toString(),
            label: support_email,
            onClose: function () {
            },
            callback: async function (response) {

                setloadingPlaceOrder(true)
                await api.addTransaction(cookies.get('jwt_token'), orderid, response.reference, paymentMethod)
                    .then(response => response.json())
                    .then(result => {
                        setloadingPlaceOrder(false)
                        if (result.status === 1) {
                            toast.success(result.message)
                            setIsOrderPlaced(true);
                            setShow(true)
                        }
                        else {
                            toast.error(result.message)
                        }
                    })
                    .catch(error => console.log(error))

            }
        });

        handler.openIframe();
    }


    const HandlePlaceOrder = async (e) => {
        // e.preventDefault();


        setDeliveryTime(`${expectedDate.getDate()}-${expectedDate.getMonth() + 1}-${expectedDate.getFullYear()} ${expectedTime.title}`)
        const delivery_time = `${expectedDate.getDate()}-${expectedDate.getMonth() + 1}-${expectedDate.getFullYear()} ${expectedTime.title}`;

        //place order

        if (address.selected_address === null) {
            toast.error("Please Select Delivery Address")
        }
        else if (delivery_time === null) {
            toast.error("Please Select Preffered Delivery Time")
        }
        else {
            setloadingPlaceOrder(true)

            if (paymentMethod === 'COD') {
                // place order


                await api.placeOrder(cookies.get('jwt_token'), cart.checkout.product_variant_id, cart.checkout.quantity, cart.checkout.sub_total, cart.checkout.delivery_charge.total_delivery_charge, cart.promo_code ? (cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge) : cart.checkout.total_amount, paymentMethod, address.selected_address.id, delivery_time)
                    .then(response => response.json())
                    .then(async (result) => {
                        setisLoader(false)
                        if (result.status === 1) {
                            toast.success("Order Successfully Placed!")
                            setloadingPlaceOrder(false)

                            setIsOrderPlaced(true);
                            setShow(true)
                        }
                        else {
                            toast.error(result.message)
                            setloadingPlaceOrder(false)
                        }
                    })
                    .catch(error => {
                        setisLoader(false)
                        setloadingPlaceOrder(false)
                        console.log(error)
                    })
            }
            else if (paymentMethod === 'Razorpay') {
                await api.placeOrder(cookies.get('jwt_token'), cart.checkout.product_variant_id, cart.checkout.quantity, cart.checkout.sub_total, cart.checkout.delivery_charge.total_delivery_charge, cart.promo_code ? (cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge) : cart.checkout.total_amount, paymentMethod, address.selected_address.id, delivery_time)
                    .then(response => response.json())
                    .then(async result => {

                        // fetchOrders();
                        if (result.status === 1) {
                            await api.initiate_transaction(cookies.get('jwt_token'), result.data.order_id, "Razorpay")
                                .then(resp => resp.json())
                                .then(res => {
                                    setisLoader(false)

                                    if (res.status === 1) {
                                        setloadingPlaceOrder(false)
                                        handleRozarpayPayment(result.data.order_id, res.data.transaction_id, cart.promo_code ? (cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge) : cart.checkout.total_amount, user.user.name, user.user.email, user.user.mobile, setting.setting.app_name);
                                    }
                                    else {
                                        toast.error(res.message)
                                        setloadingPlaceOrder(false)
                                    }
                                })
                                .catch(error => console.error(error))

                        }
                        else {
                            toast.error(result.message)
                            setloadingPlaceOrder(false)
                        }
                    })
                    .catch(error => console.log(error))
            }
            else if (paymentMethod === 'Paystack') {
                await api.placeOrder(cookies.get('jwt_token'), cart.checkout.product_variant_id, cart.checkout.quantity, cart.checkout.sub_total, cart.checkout.delivery_charge.total_delivery_charge, cart.promo_code ? (cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge) : cart.checkout.total_amount, paymentMethod, address.selected_address.id, delivery_time)
                    .then(response => response.json())
                    .then(result => {
                        // fetchOrders();
                        if (result.status === 1) {
                            setloadingPlaceOrder(false)
                            setOrderID(result.data.order_id)
                            handlePayStackPayment(user.user.email, cart.promo_code ? (cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge) : cart.checkout.total_amount, setting.payment_setting.paystack_currency_code, setting.setting.support_email, result.data.order_id)

                        }
                        else {
                            toast.error(result.message)
                            setloadingPlaceOrder(false)
                        }
                    })
                    .catch(error => console.log(error))

            }
            else if (paymentMethod === "Stripe") {
                await api.placeOrder(cookies.get('jwt_token'), cart.checkout.product_variant_id, cart.checkout.quantity, cart.checkout.sub_total, cart.checkout.delivery_charge.total_delivery_charge, cart.promo_code ? (cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge) : cart.checkout.total_amount, paymentMethod, address.selected_address.id, delivery_time)
                    .then(response => response.json())
                    .then(async result => {
                        if (result.status === 1) {
                            

                            await api.initiate_transaction(cookies.get('jwt_token'), result.data.order_id, 'Stripe')
                                .then(resp => resp.json())
                                .then(res => {

                                    setloadingPlaceOrder(false)
                                    setstripeOrderId(result.data.order_id)
                                    setstripeClientSecret(res.data.client_secret)
                                    setstripeTransactionId(res.data.id)
                                })
                                .catch(error => console.log(error))
                            // fetchOrders();
                        }
                        else {
                            toast.error(result.message)
                            setloadingPlaceOrder(false)
                        }
                    })
                    .catch(error => console.log(error))


                // setstripeOrderId(400)

                setloadingPlaceOrder(false)
            }
            else if (paymentMethod === 'Paypal') {
                await api.placeOrder(cookies.get('jwt_token'), cart.checkout.product_variant_id, cart.checkout.quantity, cart.checkout.sub_total, cart.checkout.delivery_charge.total_delivery_charge, cart.promo_code ? (cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge) : cart.checkout.total_amount, paymentMethod, address.selected_address.id, delivery_time)
                    .then(response => response.json())
                    .then(async result => {

                        // fetchOrders();
                        if (result.status === 1) {
                            await api.initiate_transaction(cookies.get('jwt_token'), result.data.order_id, "Paypal")
                                .then(resp => resp.json())
                                .then(res => {
                                    // console.log(res.data.paypal_redirect_url)
                                    setisLoader(false)

                                    if (res.status === 1) {
                                        setloadingPlaceOrder(false)
                                        setpaymentUrl(res.data.paypal_redirect_url);
                                        // window.open(res.data.paypal_redirect_url, '_blank', 'location=yes,height=570,width=520,scrollbars=yes,status=yes')
                                        // document.getElementById("iframe_id").contentWindow.location.href
                                        // handleRozarpayyPayment(result.data.order_id, res.data.transaction_id, cart.checkout.total_amount, user.user.name, user.user.email, user.user.mobile, setting.setting.app_name);

                                        var ccavenue_redirect_url = res.data.paypal_redirect_url;
                                        //var ccavenue_redirect_url = "https://admin.pocketgroceries.in/customer/ccavenue_payment";

                                        var subWindow = window.open(ccavenue_redirect_url, '_blank', 'location=yes,height=570,width=520,scrollbars=yes,status=yes');
                                        var redirect_url = res.data.paypal_redirect_url
                                        /*subWindow.postMessage('Hello from parent window!', '*');
                                        console.log("redirect_url : ",redirect_url);*/
                                        const checkChildWindow = setInterval((e) => {
                                            if (subWindow && subWindow.closed) {
                                                clearInterval(checkChildWindow);
                                                console.log('Child window is closed');
                                                if (subWindow && subWindow.closed && !paypalStatus.current) {
                                                    toast.error("Payment failed ");
                                                    // Perform any actions or display a message here
                                                }

                                            }
                                        }, 1500); // Adjust the interval (in milliseconds) as needed

                                    } else {
                                        toast.error(res.message)
                                        setloadingPlaceOrder(false)
                                    }
                                })
                                .catch(error => console.error(error))

                        }
                        else {
                            toast.error(result.message)
                            setloadingPlaceOrder(false)
                        }
                    })
                    .catch(error => console.log(error))
            }
            // else if (paymentMethod === "Paytm") {
            //      await api.placeOrder(cookies.get('jwt_token'), cart.checkout.product_variant_id, cart.checkout.quantity, cart.checkout.sub_total, cart.checkout.delivery_charge.total_delivery_charge, cart.promo_code ? cart.promo_code.discounted_amount: cart.checkout.total_amount, paymentMethod, address.selected_address.id, delivery_time)
            //         .then(response => response.json())
            //         .then(async result => {
            //             if (result.status === 1) {

            //             }

            //         })
            //         .catch(error => console.error(error))
            // }
        }

    }

    const handleClose = () => {
        setisLoader(true)
        api.removeCart(cookies.get('jwt_token')).then(response => response.json())
            .then(async (result) => {
                if (result.status === 1) {
                    dispatch({ type: ActionTypes.SET_CART, payload: null })
                    dispatch({ type: ActionTypes.SET_CART_CHECKOUT, payload: null })
                }
            })
        setShow(false)
        paypalStatus.current = false;
        navigate('/')
    };



    useEffect(() => {
        if (IsOrderPlaced) {
            setShow(true);
            setTimeout(async () => {
                handleClose();
            }, 5000);
        }
    }, [IsOrderPlaced]);

    // useEffect(()=>{
    //     if (address.address && !address.selected_address) {
    //         dispatch({type:ActionTypes.SET_SELECTED_ADDRESS, payload:address.address.find((element)=>element.is_default == 1 )})
    //     }
    // },[address])

    const { t } = useTranslation()
    return (
        <>
            <section id='checkout'>
                {/* {console.log(IsOrderPlaced)} */}
                {IsOrderPlaced ?

                    <>
                        <Modal
                            show={show}
                            onHide={handleClose}
                            backdrop="static"
                            keyboard={true}
                            className='success_modal'
                        >
                            <Lottie className='lottie-content' animationData={animate1} loop={true}></Lottie>
                            <Modal.Header closeButton className='flex-column-reverse success_header'>
                                <Modal.Title><Lottie animationData={animate2} loop={false}></Lottie></Modal.Title>
                            </Modal.Header>
                            <Modal.Body className='success_body'>
                                {t("order_placed_description")}
                            </Modal.Body>
                            <Modal.Footer className="success_footer">
                                <Button variant="primary" onClick={handleClose} className='checkout_btn'>
                                    {t("go_to_home")}
                                </Button>

                            </Modal.Footer>
                        </Modal>
                    </>
                    : null}
                {/* //     {stripepayment ? <PaymentElement /> : null} */}
                <div className='cover'>
                    <img src={coverImg} className='img-fluid' alt="cover"></img>
                    <div className='title'>
                        <h3>{t("checkout")}</h3>
                        <span><Link to="" className="text-white text-decoration-none">{t("home")} / </Link> </span><span className='active'>{t("checkout")}</span>
                    </div>
                </div>



                {
                    setting.payment_setting === null && expectedTime === null
                        ? (
                            <Loader screen='full' />
                        )
                        : (
                            <>
                                <div className='checkout-container container'>

                                    <div className='checkout-util-container col-lg-9'>
                                        <div className='billibg-address-wrapper checkout-component'>
                                            <span className='heading'>{t("billing_details")}</span>

                                            <Address setselectedAddress={setselectedAddress} selectedAddress={selectedAddress} />
                                        </div>
                                        {timeslots && timeslots.time_slots_is_enabled === "true" ?
                                            <>
                                                <div className='delivery-day-wrapper checkout-component'>
                                                    <span className='heading'>{t("prefered_day")}</span>
                                                    <div className='d-flex justify-content-center p-3'>
                                                        <Calendar value={expectedDate} onChange={(e) => {
                                                            if (new Date(e) >= new Date()) {
                                                                setexpectedDate(new Date(e))
                                                            }
                                                            else if (new Date(e).getDate() === new Date().getDate() && new Date(e).getMonth() === new Date().getMonth() && new Date(e).getFullYear() === new Date().getFullYear()) {
                                                                setexpectedDate(new Date(e))
                                                            }
                                                            else {
                                                                toast.info('Please Select Valid Delivery Day')
                                                            }
                                                        }}
                                                            calendarType={"US"} />
                                                    </div>
                                                </div>
                                                <div className='delivery-time-wrapper checkout-component'>
                                                    <span className='heading'>{t("prefered_time")}</span>
                                                    <div className='d-flex p-3' style={{ flexWrap: "wrap" }}>
                                                        {timeslots === null
                                                            ? <Loader screen='full' />

                                                            : (
                                                                <>
                                                                    {timeslots.time_slots.map((timeslot, index) => (
                                                                        <div key={index} className='time-slot-container'>
                                                                            <div>
                                                                                <input type="radio" name="TimeSlotRadio" id={`TimeSlotRadioId${index}`} defaultChecked={index === 0 ? true : false} onChange={() => {
                                                                                    setexpectedTime(timeslot);
                                                                                }} />
                                                                            </div>
                                                                            <div>
                                                                                {timeslot.title}
                                                                            </div>
                                                                        </div>
                                                                    ))}
                                                                </>
                                                            )
                                                        }
                                                    </div>
                                                </div>
                                            </>
                                            : <></>}


                                    </div >

                                    <div className='order-container'>
                                        <div className="promo-section">

                                            <div className="heading">
                                                <span>{t("coupon")}</span>
                                            </div>
                                            <div className="promo-wrapper">
                                                <div className="promo-container">
                                                    <div className="promo-button d-block d-lg-flex">
                                                        <span className="">{t("have_coupon")}</span>
                                                        <button className="btn btn-primary" data-bs-toggle="offcanvas" data-bs-target="#promooffcanvas" aria-controls="promooffcanvaslabel">{t("view_coupon")}</button>
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
                                        <div className='payment-wrapper checkout-component'>
                                            <span className='heading'>{t("payment_method")}</span>

                                            {setting.payment_setting.cod_payment_method === "1"
                                                ? (
                                                    <label className="form-check-label" htmlFor='cod'>
                                                        <div className='payment-selector'>
                                                            <div className="">
                                                                <img src={cod} alt='cod' />
                                                                <span>{t("cash_on_delivery")}</span>
                                                            </div>
                                                            <input type="radio" name="payment-method" id='cod' defaultChecked={true} onChange={() => {
                                                                setpaymentMethod("COD")
                                                            }} />
                                                        </div>
                                                    </label>
                                                ) : null}

                                            {setting.payment_setting.razorpay_payment_method === "1"
                                                ? (
                                                    <label className="form-check-label" htmlFor='razorpay'>
                                                        <div className='payment-selector'>
                                                            <div className="">
                                                                <img src={rozerpay} alt='cod' />
                                                                <span>{t("razorpay")}</span>
                                                            </div>
                                                            <input type="radio" name="payment-method" id='razorpay' onChange={() => {
                                                                setpaymentMethod("Razorpay")
                                                            }} />
                                                        </div>
                                                    </label>
                                                ) : null}

                                            {setting.payment_setting.paystack_payment_method === "1"
                                                ? (
                                                    <label className="form-check-label" htmlFor='paystack'>
                                                        <div className='payment-selector'>
                                                            <div className="">
                                                                <img src={paystack} alt='cod' />
                                                                <span>{t("paystack")}</span>
                                                            </div>
                                                            <input type="radio" name="payment-method" id='paystack' onChange={() => {
                                                                setpaymentMethod("Paystack")
                                                            }} />
                                                        </div>
                                                    </label>
                                                ) : null}

                                            {setting.payment_setting.stripe_payment_method === "1"
                                                ? (
                                                    <label className="form-check-label" htmlFor='stripe'>
                                                        <div className='payment-selector'>
                                                            <div className="">
                                                                <img src={Stripe} alt='stripe' />
                                                                <span>{t("stripe")}</span>

                                                            </div>
                                                            <input type="radio" name="payment-method" id='stripe' onChange={() => {
                                                                setpaymentMethod("Stripe")
                                                            }} />
                                                        </div>
                                                    </label>
                                                ) : null}

                                            {setting.payment_setting.paypal_payment_method === "1"
                                                ? (
                                                    <>
                                                        <label className="form-check-label" htmlFor='paypal'>
                                                            <div className='payment-selector'>
                                                                <div className="">
                                                                    <img src={paypal} alt='paypal' />
                                                                    <span>{t("paypal")}</span>
                                                                </div>
                                                                <input type="radio" name="payment-method" id='paypal' onChange={() => {
                                                                    setpaymentMethod("Paypal")
                                                                }} />
                                                            </div>
                                                        </label>

                                                    </>
                                                ) : null}


                                            {/* {console.log(cart)} */}
                                        </div>


                                        <div className='order-summary-wrapper checkout-component'>

                                            <div className="order-bill">
                                                <div className='heading'>{t("order_summary")}</div>

                                                <div className='order-details'>
                                                    {cart.checkout === null || user.user === null
                                                        ? (
                                                            <Loader screen='full' />

                                                        )
                                                        : (
                                                            <div className='summary'>
                                                                <div className='d-flex justify-content-between'>
                                                                    <span>{t("sub_total")}</span>
                                                                    <div className='d-flex align-items-center'>

                                                                        <span>{setting.setting && setting.setting.currency}   {(cart.checkout.sub_total).toFixed(setting.setting && setting.setting.decimal_point)}</span>
                                                                    </div>
                                                                </div>

                                                                <div className='d-flex justify-content-between'>
                                                                    <span>{t("delivery_charge")}</span>
                                                                    <div className='d-flex align-items-center'>

                                                                        <span>{setting.setting && setting.setting.currency}  {(cart.checkout.delivery_charge.total_delivery_charge).toFixed(setting.setting && setting.setting.decimal_point)}</span>
                                                                    </div>
                                                                </div>
                                                                {cart.promo_code && <>
                                                                    <div className='d-flex justify-content-between'>
                                                                        <span>{t("discount")}</span>
                                                                        <div className='d-flex align-items-center'>

                                                                            <span>- {setting.setting && setting.setting.currency}    {(cart.promo_code.discount).toFixed(setting.setting && setting.setting.decimal_point)}</span>
                                                                        </div>
                                                                    </div>
                                                                </>}
                                                                <div className='d-flex justify-content-between total'>
                                                                    <span>{t("total")}</span>
                                                                    <div className='d-flex align-items-center total-amount' style={{ color: "var(--secondary-color)" }}>

                                                                        {cart.promo_code ?
                                                                            <span>{setting.setting && setting.setting.currency} {(cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge).toFixed(setting.setting && setting.setting.decimal_point)}</span>
                                                                            : <>
                                                                                <span>{setting.setting && setting.setting.currency} {(cart.checkout.total_amount).toFixed(setting.setting && setting.setting.decimal_point)}</span>
                                                                            </>}
                                                                    </div>
                                                                </div>




                                                                {loadingPlaceOrder
                                                                    ?
                                                                    <Loader screen='full' background='none' />
                                                                    : <>
                                                                        <div className='button-container'>

                                                                            {paymentMethod === "Stripe"
                                                                                ? <motion.button whileTap={{ scale: 0.8 }} type='button' className='checkout' onClick={(e) => { e.preventDefault(); HandlePlaceOrder() }} data-bs-toggle="modal" data-bs-target="#stripeModal">{t("place_order")}</motion.button>
                                                                                : <motion.button whileTap={{ scale: 0.8 }} type='button' className='checkout' onClick={(e) => { e.preventDefault(); HandlePlaceOrder() }}>{t("place_order")}</motion.button>
                                                                            }
                                                                        </div>
                                                                    </>
                                                                }

                                                            </div>)}
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div >
                            </>
                        )
                }


                <Promo />

            </section >

            <div className="modal fade" id="stripeModal" data-bs-backdrop="static" tabIndex="-1" aria-labelledby="stripeModalLabel" aria-hidden="true">
                <div className="modal-dialog modal-dialog-centered modal-lg">
                    <div className="modal-content" style={{ minWidth: "100%" }}>
                        {stripeOrderId === null || stripeClientSecret === null || stripeTransactionId === null
                            ? <Loader width='100%' height='100%' />
                            :
                            <Elements stripe={stripePromise} orderID={stripeOrderId} client_secret={stripeClientSecret} transaction_id={stripeTransactionId} amount={cart.promo_code ? (cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge) : cart.checkout.total_amount}>
                                <InjectCheckout orderID={stripeOrderId} client_secret={stripeClientSecret} transaction_id={stripeTransactionId} amount={cart.promo_code ? (cart.promo_code.discounted_amount + cart.checkout.delivery_charge.total_delivery_charge) : cart.checkout.total_amount} />
                            </Elements>
                        }

                    </div>
                </div>
            </div>
        </>
    )
}
export default Checkout
