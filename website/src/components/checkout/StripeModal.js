import { ElementsConsumer, CardElement } from '@stripe/react-stripe-js';
import React, { useState, useRef } from 'react'
import './checkout.css'
import { AiOutlineCloseCircle } from 'react-icons/ai'
import api from '../../api/api';
import Cookies from 'universal-cookie';
import { motion } from 'framer-motion'
import { toast } from 'react-toastify';
import Loader from '../loader/Loader';
import { Button, Modal } from 'react-bootstrap';
import animate1 from '../../utils/order_placed_back_animation.json'
import animate2 from '../../utils/order_success_tick_animation.json'
import Lottie from 'lottie-react';
import { useNavigate } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { ActionTypes } from '../../model/action-type';

const CARD_OPTIONS = {
    iconStyle: "solid",
    style: {
        base: {
            // iconColor: "#c4f0ff",
            fontWeight: 500,
            fontFamily: "Roboto, Open Sans, Segoe UI, sans-serif",
            fontSize: "16px",
            fontSmoothing: "antialiased",
            ":-webkit-autofill": { color: "#fce883" },
            "::placeholder": { color: "#87bbfd" },
            border: "2px solid black"
        },
        invalid: {
            // iconColor: "#ffc7ee",
            color: "#ffc7ee"
        }
    }
};



const StripeModal = (props) => {

    const cookies = new Cookies();
    const closeModal = useRef();
    const navigate = useNavigate();

    const dispatch = useDispatch();


    const user = useSelector((state)=> state.user)

    const [loadingPay, setloadingPay] = useState(false)

    const handleSubmit = async (event) => {
        event.preventDefault()
        const { stripe, elements, orderID } = props;

        setloadingPay(true)
        if (!stripe || !elements) {
            // Stripe.js has not yet loaded.
            // Make sure to disable form submission until Stripe.js has loaded.
            setloadingPay(false)
            return;
        }

        if (!orderID) {
            setloadingPay(false)
            return;
        }



        const SK = props.client_secret

        // Confirm the PaymentIntent with the Payment Element
        const { paymentIntent, error } = await stripe.confirmCardPayment(SK, {
            payment_method: {
                card: elements.getElement(CardElement),
                billing_details: {
                    name: user.user && user.user.name,
                    address: {
                        line1: '510 Townsend St',
                        postal_code: '98140',
                        city: 'San Francisco',
                        state: 'CA',
                        country: 'US',
                    },
                    
                },
            },
        });
        if (error) {
            console.error(error);
            closeModal.current.click()
            toast.error(error.message)
        } else if (paymentIntent.status === 'succeeded') {
            // Redirect the customer to a success page
            // window.location.href = '/success';
            await api.addTransaction(cookies.get('jwt_token'), orderID, props.transaction_id, "Stripe")
                .then(response => response.json())
                .then(result => {
                    if (result.status === 1) {
                        setShow(true)
                        setIsOrderPlaced(true)
                        setloadingPay(false)
                    }
                    else {
                        setloadingPay(false)
                    }
                    closeModal.current.click()
                })
                .catch(error => console.log(error))
            } else {
                // Handle other payment status scenarios
                setloadingPay(false)
            console.log('Payment failed');
        }
    }

    const [isOrderPlaced, setIsOrderPlaced] = useState(false);
    const [show, setShow] = useState(false);
    const handleClose = () => {
        api.removeCart(cookies.get('jwt_token')).then(response => response.json())
            .then(async (result) => {
                if (result.status === 1) {
                    dispatch({ type: ActionTypes.SET_CART, payload: null })
                    dispatch({ type: ActionTypes.SET_CART_CHECKOUT, payload: null })
                }
            })
        setShow(false)
        navigate('/')
    };
    return (
        <>
            {isOrderPlaced ?

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
                            <Modal.Title><Lottie animationData={animate2} loop={true}></Lottie></Modal.Title>
                        </Modal.Header>
                        <Modal.Body className='success_body'>
                            Order Placed Successfully
                        </Modal.Body>
                        <Modal.Footer className="success_footer">
                            <Button variant="primary" onClick={handleClose} className='checkout_btn'>
                                Go to Home Page
                            </Button>

                        </Modal.Footer>
                    </Modal>
                </>
                : null}
           
            <div className="modal-body">

                <div className='stripe-container d-flex flex-column p-0'>

                    <div className="d-flex flex-row justify-content-between header">
                        <span className='heading'>Egrocers Payment</span>
                        <button type="button" className="close-stripe" data-bs-dismiss="modal" aria-label="Close" ref={closeModal}><AiOutlineCloseCircle /></button>
                    </div>
                    <form onSubmit={handleSubmit} id="stripe-form" className='row p-5 border-3'>
                        {/* <CardSection /> */}
                        <fieldset className='FormGroup p-4'>
                            <div className="FormRow">

                                <CardElement options={CARD_OPTIONS} />
                            </div>
                        </fieldset>
                        {loadingPay
                            ? <Loader screen='full' background='none' />
                            :
                            <button whileTap={{ scale: 0.8 }} type='submit' disabled={!props.stripe} className='pay-stripe'>Pay</button>
                        }
                    </form>
                </div>

            </div>
        </>
    )
}


export default function InjectCheckout(props) {
    return (
        <ElementsConsumer orderID={props.orderID} client_secret={props.client_secret} transaction_id={props.transaction_id} amount={props.amount}>
            {({ stripe, elements, orderID, client_secret, transaction_id, amount }) => (
                <>
                    <StripeModal stripe={stripe} elements={elements} orderID={props.orderID} client_secret={props.client_secret} transaction_id={props.transaction_id} amount={props.amount}></StripeModal>
                </>
            )}
        </ElementsConsumer>
    )
}








