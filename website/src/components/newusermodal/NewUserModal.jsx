import React, { useRef, useState } from 'react'
import { Modal } from 'react-bootstrap'
import { useDispatch, useSelector } from 'react-redux'
import Cookies from 'universal-cookie';
import api from '../../api/api';
import { toast } from 'react-toastify';
import { ActionTypes } from '../../model/action-type';
import '../login/login.css'
import './newmodal.css'
import { useTranslation } from 'react-i18next';

function NewUserModal() {
    const cookies = new Cookies();
    const dispatch = useDispatch();

    const user = useSelector((state) => state.user);
    const setting = useSelector((state) => state.setting)

    const [username, setusername] = useState();
    const [useremail, setuseremail] = useState();
    const [isLoading, setisLoading] = useState(false);
    const [selectedFile, setSelectedFile] = useState(null);
    const [error, setError] = useState("");

    const closeModalRef = useRef();

    const handleUpdateUser = (e) => {
        e.preventDefault()

        setisLoading(true)
        if (cookies.get('jwt_token') !== undefined) {
            api.edit_profile(username, useremail, selectedFile, cookies.get('jwt_token'))
                .then(response => response.json())
                .then(result => {
                    if (result.status === 1) {
                        getCurrentUser(cookies.get('jwt_token'));
                        closeModalRef.current.click()
                    }
                    else {
                        setError(result.message);
                        setisLoading(false)
                    }
                })
        }

    }

    const getCurrentUser = (token) => {
        api.getUser(token)
            .then(response => response.json())
            .then(result => {
                if (!result.user.status) {
                    setisLoading(false)
                    dispatch({ type: ActionTypes.SET_CURRENT_USER, payload: result.user })
                } else {

                    if (result.status === 1) {
                        dispatch({ type: ActionTypes.SET_CURRENT_USER, payload: result.user })
                        if (closeModalRef.current && result.user.status) {
                            closeModalRef.current.click()
                        }
                        toast.success("You're successfully Logged In")
                        setisLoading(false)
                    }
                }
            })
    }
    const {t} = useTranslation();
    return (
        <>
        
            <Modal
                show={user.user && user.user.status == 2}
                backdrop="static"
                keyboard={true}
                className='user_data_modal'>


                <Modal.Header className='web_logo'>

                    <img src={setting.setting && setting.setting.web_settings.web_logo} alt="" />

                </Modal.Header>
                <Modal.Body
                    className='user_data_modal_body'>
                    <span className='note'>{t("profile_note")}</span>
                    <form onSubmit={handleUpdateUser} className='userData-Form'>
                        <div className='inputs-container'>
                            <input type='text' placeholder='user name' value={username} onChange={(e) => {
                                setError("")
                                setusername(e.target.value)
                            }} required />
                            <input type='email' placeholder='email address' value={useremail} onChange={(e) => {
                                setError("")
                                setuseremail(e.target.value)
                            }} required />
                            <input type='tel' placeholder='mobile number' value={user.user && user.user.mobile} readOnly style={{ color: "var(--sub-text-color)" }} />
                        </div>
                        <button whileTap={{ scale: 0.8 }} type='submit' disabled={isLoading} >{t("update")} {t("profile")}</button>
                    </form>
                    {error ? <p className='user_data_form_error'>{error}</p> : ""}
                </Modal.Body>
            </Modal>
        </>
    )
}

export default NewUserModal
