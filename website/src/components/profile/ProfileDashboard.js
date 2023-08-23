import React, { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { useNavigate, useSearchParams } from 'react-router-dom';
import { ActionTypes } from '../../model/action-type';
import './profile.css'

import coverImg from '../../utils/cover-img.jpg'
import { FaUserCircle, FaListAlt, FaHome, FaEdit } from 'react-icons/fa'
import { GoChecklist } from 'react-icons/go'
import { FiLogOut } from 'react-icons/fi'
import { IoIosArrowForward, IoMdLogOut } from 'react-icons/io'
import { AiFillDelete, AiOutlineCloseCircle } from 'react-icons/ai'
import Cookies from 'universal-cookie'
import { toast } from 'react-toastify';
import Order from '../order/Order';
import Address from '../address/Address';
import Transaction from '../transaction/Transaction';
import { confirmAlert } from 'react-confirm-alert';
import 'react-confirm-alert/src/react-confirm-alert.css';
import { removelocalstorageOTP, gelocalstoragetOTP } from '../../utils/manageLocalStorage';
import api from '../../api/api';
import { RiLogoutCircleRFill } from 'react-icons/ri';
import { useTranslation } from 'react-i18next';

const ProfileDashboard = () => {
    //initialize Cookies
    const cookies = new Cookies();

    const setting = useSelector((state)=>state.setting)
    const navigate = useNavigate();
    const dispatch = useDispatch();
    const closeCanvas = useRef(null)
    const user = useSelector(state => (state.user))

    useEffect(() => {
        if (user.status === 'loading') {
            navigate('/')
        }
    }, [user])


    const [profileClick, setprofileClick] = useState(true)
    const [orderClick, setorderClick] = useState(false)
    const [addressClick, setaddressClick] = useState(false)
    const [transactionClick, settransactionClick] = useState(false)
    const [username, setusername] = useState(user.user && user.user.name)
    const [useremail, setuseremail] = useState(user.user && user.user.email)
    const [selectedFile, setselectedFile] = useState()
    const [isupdating, setisupdating] = useState(false);

    const getCurrentUser = (token) => {
        api.getUser(token)
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {
                    dispatch({ type: ActionTypes.SET_CURRENT_USER, payload: result.user });
                    setisupdating(false);
                }
            })
    }
    const handleUpdateUser = async(e) => {
        e.preventDefault()

        setisupdating(true)
        if (cookies.get('jwt_token') !== undefined) {
            await api.edit_profile(username, useremail, selectedFile, cookies.get('jwt_token'))
                .then(response => response.json())
                .then(result => {
                    if (result.status === 1) {
                        getCurrentUser(cookies.get('jwt_token'));
                    }
                    else {
                        toast.error(result.message);
                        setisupdating(false)
                    }
                }).catch((error)=>{
                    toast.error(error)
                })
        }
        // setuseremail("")
        // setselectedFile()
        // setusername("")
    }
    const handleLogout = () => {

        confirmAlert({
            title: t('logout_title'),
            message: t('logout_message'),
            buttons: [
                {
                    label: t("Ok"),
                    onClick: async () => {
                        await api.logout(cookies.get('jwt_token')).then(response => response.json())
                            .then(result => {
                                if (result.status === 1) {
                                    cookies.remove('jwt_token')
                                    removelocalstorageOTP()
                                    dispatch({ type: ActionTypes.LOGOUT_AUTH, payload: null });
                                    toast.success("You're Successfully Logged Out")
                                    navigate('/');
                                }
                                else {
                                    toast.info(result.message)
                                }
                            })

                    }
                },
                {
                    label: t('Cancel'),
                    onClick: () => { }
                }
            ]
        })


    }

    const handleDeleteAcount = () => {

        confirmAlert({
            title: t('DeleteUserAccount'),
            message: t(`delete_user_message`),
            buttons: [
                {
                    label: t('Ok'),
                    onClick: async () => {

                        await api.deleteAccount(cookies.get('jwt_token'), gelocalstoragetOTP()).then(response => response.json())
                            .then(result => {
                                if (result.status === 1) {
                                    cookies.remove('jwt_token')
                                    removelocalstorageOTP()
                                    dispatch({ type: ActionTypes.LOGOUT_AUTH, payload: null });
                                    toast.info("You're Account is Succesfully Deleted!!")
                                    navigate('/')
                                }
                                else {
                                    toast.info(result.message)
                                }
                            })

                    }
                },
                {
                    label: t('Cancel'),
                    onClick: () => { }
                }
            ]
        })

    }


    const { t } = useTranslation()

    const profileNav = () => {
        return (
            <>
                {isupdating
                    ? (
                        <div className="d-flex justify-content-center">
                            <div className="spinner-border" role="status">
                                <span className="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    )
                    : <div className="basicInfo-container">
                        <div className="image-container">
                            <img src={user.user && user.user.profile} alt='logo'></img>
                            <div className="button-container-badge">
                                <label htmlFor="file">
                                    <span className="badge-img"><FaEdit size={25} fill='var(--secondary-color)' /></span>
                                </label>
                            </div>
                        </div>
                        <p>{user.user.name.split(' ')[0]}</p>
                        <span>{user.user.email}</span>
                    </div>
                }


                <div className="navigation-container">


                    <button type='button' className='navigation-container-button ' onClick={() => {
                        setprofileClick(true)
                        setaddressClick(false)
                        setorderClick(false)
                        settransactionClick(false)
                        closeCanvas.current.click()
                    }}>

                        <span>
                            <FaUserCircle size={35} className='mx-3' fill={'var(--secondary-color)'} />
                            {t("profile")}
                        </span>
                        <IoIosArrowForward className="profile-navigate-arrow" />
                    </button>
                    <button type='button' className='navigation-container-button ' onClick={() => {
                        setprofileClick(false)
                        setaddressClick(false)
                        setorderClick(true)
                        settransactionClick(false)
                        setisupdating(false)
                        closeCanvas.current.click()
                        
                    }}>
                        <span >
                            <FaListAlt size={35} className='mx-3' fill={'var(--secondary-color)'} />
                            {t("all_orders")}
                        </span>
                        <IoIosArrowForward className="profile-navigate-arrow" />
                    </button>
                    <button type='button' className='navigation-container-button ' onClick={() => {
                        setprofileClick(false)
                        setaddressClick(true)
                        setorderClick(false)
                        settransactionClick(false)
                        setisupdating(false)
                        closeCanvas.current.click()
                        
                    }}>
                        <span >
                            <FaHome size={35} className='mx-3' fill={'var(--secondary-color)'} />
                        {t("manage_address")}
                        </span>
                        <IoIosArrowForward className="profile-navigate-arrow" />
                    </button>
                    <button type='button' className='navigation-container-button ' onClick={() => {
                        setprofileClick(false)
                        setaddressClick(false)
                        setorderClick(false)
                        settransactionClick(true)
                        setisupdating(false)
                        closeCanvas.current.click()
                        
                        if (window.innerWidth < 768) document.getElementsByClassName('sidebar')[0].classList.toggle('active')
                    }} >
                        <span>
                            <GoChecklist size={35} className='mx-3' fill={'var(--secondary-color)'} />
                            {t("transaction_history")}
                        </span>
                        <IoIosArrowForward className="profile-navigate-arrow" />
                    </button>
                    <button type='button' className='navigation-container-button no-hover' onClick={handleLogout}>
                        <span>
                            <IoMdLogOut size={35} className='mx-3' fill={'var(--secondary-color)'} />
                            {/* <img src={logout} height='35px' className='logout-img' alt="" /> */}
                            {t("logout")}
                        </span>
                        <IoIosArrowForward className="profile-navigate-arrow" />
                    </button>
                    <button type='button' className='navigation-container-button ' onClick={handleDeleteAcount}>
                        <span>
                            <AiFillDelete size={35} className='mx-3' fill={'var(--secondary-color)'} />
                            {t("delete_account")}
                        </span>
                        <IoIosArrowForward className="profile-navigate-arrow" />
                    </button>
                </div>

            </>
        )
    }
    return (
        <>
            {user.status === 'loading'
                ? (
                    <div className="d-flex justify-content-center">
                        <div className="spinner-border" role="status">
                            <span className="visually-hidden">Loading...</span>
                        </div>
                    </div>
                ) : (
                    <section id='profile'>


                        <div className="hide-desktop offcanvas offcanvas-start" tabIndex="-1" id="profilenavoffcanvasExample" aria-labelledby="profilenavoffcanvasExampleLabel" data-bs-backdrop="false" >
                            <div className="canvas-header">
                                <div className='site-brand'>
                                    <img src={setting.setting && setting.setting.web_settings.web_logo} height="50px" alt="logo"></img>
                                </div>

                                <button type="button" ref={closeCanvas} className="close-canvas" data-bs-dismiss="offcanvas" aria-label="Close" onClick={() => {
                                    document.getElementsByClassName('profile-account')[0].classList.remove('active')

                                }}><AiOutlineCloseCircle /></button>
                            </div>
                            <div className='sidebar'>
                                {profileNav()}
                            </div>
                        </div>

                        <div className='cover'>
                            <img src={coverImg} className='img-fluid' alt="cover"></img>
                        </div>
                        <div className='container py-5'>
                            <div className='content-container row'>

                                <div className='sidebar hide-mobile-screen col-3'>

                                    {profileNav()}


                                </div>
                                <div className='table-content col-md-9   '>
                                    <h4>{t("profile_info")}</h4>


                                    {profileClick
                                        ?// <ProfileContent isupdating={isupdating} setisupdating={setisupdating} />
                                        <>
                                            <div className='d-flex flex-column'>
                                                <div className='heading'>
                                                    {t("profile")}
                                                </div>
                                                <div className='actual-content my-5'>
                                                    {user.status === 'loading'
                                                        ? (
                                                            <div className="d-flex justify-content-center">
                                                                <div className="spinner-border" role="status">
                                                                    <span className="visually-hidden">Loading...</span>
                                                                </div>
                                                            </div>
                                                        )
                                                        : (
                                                            <form onSubmit={handleUpdateUser}>
                                                                <div className='inputs-container'>
                                                                    <input type='text' placeholder='user name' value={username} onChange={(e) => {
                                                                        setusername(e.target.value)
                                                                    }} required />
                                                                    <input type='email' placeholder='email address' value={useremail} onChange={(e) => {
                                                                        setuseremail(e.target.value)
                                                                    }} required />
                                                                    <input type='tel' placeholder='mobile number' value={user.user.mobile} readOnly style={{ color: "var(--sub-text-color)" }} />
                                                                    {/* accept={'image/*'} */}
                                                                    <input type="file" id="file" name='file' onChange={(e) => { setselectedFile(e.target.files[0]) }} />
                                                                </div>
                                                                <button whileTap={{ scale: 0.8 }} type='submit' disabled={isupdating} >{t("update_profile")}</button>
                                                            </form>
                                                        )}
                                                </div>
                                            </div></>
                                        : null}

                                    {orderClick
                                        ? <Order />
                                        : null}

                                    {transactionClick
                                        ? <Transaction />
                                        : null}

                                    {addressClick
                                        ? <Address />
                                        : null}

                                </div>
                            </div>

                        </div>

                    </section>
                )}
        </>
    )
}

export default ProfileDashboard
