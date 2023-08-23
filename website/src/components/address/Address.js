import React, { useState, useEffect, useRef } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import Cookies from 'universal-cookie';
import api from '../../api/api';
import './address.css'
import { FiEdit } from 'react-icons/fi'
import { RiDeleteBinLine } from 'react-icons/ri'
import { GrAddCircle } from 'react-icons/gr'
import NewAddress from './NewAddress';
import { toast } from 'react-toastify';
import Loader from '../loader/Loader';
import { useTranslation } from 'react-i18next';
import { ActionTypes } from '../../model/action-type';

const Address = (props) => {

    //initialize cookies
    const cookies = new Cookies();
    const dispatch = useDispatch();

    const [isAddressSelected, setIsAddressSelected] = useState(false);
    const [show, setShow] = useState(false)
    const [isLoader, setisLoader] = useState(false)


    const fetchAddress = (token) => {
        api.getAddress(token)
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {
                    dispatch({ type: ActionTypes.SET_ADDRESS, payload: result.data })
                    if (result.data.find((element) => element.is_default == 1)) {

                        dispatch({ type: ActionTypes.SET_SELECTED_ADDRESS, payload: result.data.find((element) => element.is_default == 1) })
                    }
                } else {
                    dispatch({ type: ActionTypes.SET_ADDRESS, payload: null })
                    setisLoader(false)
                }
                setisLoader(false)
            })
    }

    const user = useSelector(state => (state.user))
    const address = useSelector(state => state.address)


    useEffect(() => {
        if (cookies.get('jwt_token') !== undefined && user.user !== null) {
            fetchAddress(cookies.get('jwt_token'))
        }
    }, [user])
    useEffect(() => {
        // if (address.address && !address.selected_address) {
        //     dispatch({ type: ActionTypes.SET_SELECTED_ADDRESS, payload: address.address.find((element) => element.is_default == 1) })
        // }
    }, [address])




    const deleteAddress = (address_id) => {
        setisLoader(true)
        api.deleteAddress(cookies.get('jwt_token'), address_id)
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {
                    toast.success('Succesfully Deleted Address!')
                    fetchAddress(cookies.get('jwt_token'))
                }
            })
            .catch(error => console.log(error))
    }

    const { t } = useTranslation()
    return (
        <div className='address-wrapper'>
            {address.status !== "fulfill" || isLoader
                ? (
                    <Loader width='100%' height='300px' />
                )
                : (
                    <>
                        {address.address && address.address.map((address, index) => (
                            <div key={index} className='address-component'>
                                <div className='d-flex justify-content-between'>
                                    <div className='d-flex gap-2 align-items-center justify'>
                                        <input className="form-input" type="radio" name="AddressRadio" id={`AddressRadioId${index}`} defaultChecked={address.is_default === 1} onChange={() => {
                                            dispatch({ type: ActionTypes.SET_SELECTED_ADDRESS, payload: address })
                                        }} />
                                        <label className="form-check-label" htmlFor={`AddressRadioId${index}`}>
                                            <span>{address.name}</span>

                                            <span className='home mx-3'>{address.type}</span>
                                        </label>
                                    </div>

                                    <div className='d-flex gap-2'>
                                        <button type='button' className='edit' onClick={() => {
                                            setisLoader(true)
                                            dispatch({ type: ActionTypes.SET_SELECTED_ADDRESS, payload: address })
                                            setIsAddressSelected(true)
                                            setShow(true)
                                            setisLoader(false)

                                        }}>
                                            <FiEdit fill='var(--secondary-color)' size={24} />
                                        </button>

                                        <button type='button' className='remove' onClick={() => deleteAddress(address.id)}>
                                            <RiDeleteBinLine fill='red' size={24} />
                                        </button>
                                    </div>
                                </div>

                                <div className='address'>
                                    {address.address}, {address.landmark}, {address.area}, {address.city}, {address.state}, {address.pincode}-{address.country}
                                </div>

                                <div className='mobile'>
                                    {address.mobile}
                                </div>
                            </div>
                        ))}

                        <div className='address-component new-address'>
                            <button type='button' onClick={(e) => {
                                dispatch({ type: ActionTypes.SET_SELECTED_ADDRESS, payload: null });
                                setIsAddressSelected(false)
                                setShow(true)
                            }}>
                                <GrAddCircle fontSize='3rem' /> {t("add_new_address")}
                            </button>
                        </div>
                    </>
                )}

            <NewAddress setIsAddressSelected={setIsAddressSelected} isAddressSelected={isAddressSelected} show={show} setshow={setShow} isLoader={isLoader} setisLoader={setisLoader} />
        </div>
    )
}

export default Address
