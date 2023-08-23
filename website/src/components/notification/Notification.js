import React, { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import './notification.css'
import { IoNotifications } from 'react-icons/io5'
import Pagination from 'react-js-pagination';
import api from '../../api/api';
import Cookies from 'universal-cookie'
import Loader from '../loader/Loader';
import coverImg from '../../utils/cover-img.jpg'
import No_Notification from '../../utils/zero-state-screens/No_Notification.svg'
import { ActionTypes } from '../../model/action-type';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

const Notification = () => {
  const user = useSelector(state => (state.user))

  const dispatch = useDispatch();

  const total_notification_per_page = 10;

  //initialize cookies
  const cookies = new Cookies();

  const [totalNotification, settotalNotification] = useState(null)
  const [currPage, setcurrPage] = useState(1)
  const [notification, setnotifications] = useState(null)
  const [offset, setoffset] = useState(0)
  const [isLoader, setisLoader] = useState(false)

  const fetchNotification = () => {
    api.getNotification(cookies.get('jwt_token'), total_notification_per_page, offset)
      .then(response => response.json())
      .then(result => {
        if (result.status === 1) {
          setisLoader(false)
          dispatch({ type: ActionTypes.SET_NOTIFICATION, payload: result.data });
          setnotifications(result.data)
          settotalNotification(result.total)
        }
      })
      .catch(error => console.log(error))
  }

  useEffect(() => {
    if (cookies.get('jwt_token') !== undefined && user.user !== null) {
      fetchNotification()
    }
  }, [user])

  useEffect(() => {
    setisLoader(true)
    fetchNotification()
  }, [offset])


  //page change
  const handlePageChange = (pageNum) => {
    setcurrPage(pageNum);
    setoffset(pageNum * total_notification_per_page - total_notification_per_page)
  }
  const {t} = useTranslation();
  return (
    <div className='notification'>
      <div className='cover'>
        <img src={coverImg} className='img-fluid' alt="cover"></img>
        <div className='title'>
          <h3>{t("notification")}</h3>
          <span><Link to="/" className='text-light text-decoration-none'>{t("home")} / </Link></span><span className='active'>{t("notification")}</span>
        </div>
      </div>
      {notification === null
        ? (
          <Loader />
        )
        : (
          <div className="container">

            <div className='notification-container'>
              <div className="notifications">
                <div className='heading'> {t("all_notification")}</div>
                {notification.length === 0
                  ? (<div className='notification-body no-notification'>
                    <img src={No_Notification} alt='no-notification'></img>
                    <p>{t("empty_notification_list_message")}</p>
                  </div>)
                  : (
                    <>
                      {isLoader ? <Loader width='100%' height='300px' /> : (
                        <div className='notification-body'>
                          {notification.map((ntf, index) => (
                            <div key={index} className='wrapper'>
                              {ntf.image_url === "" ? <div className='logo' style={{ background: "var(--secondary-color)" }}><IoNotifications fill='#fff' fontSize='5rem' /></div> : <img src={ntf.image_url} alt='notification'></img>}
                              <div className='content'>
                                <p className='title'>{ntf.title}</p>
                                <p>{ntf.message}</p>
                              </div>
                            </div>
                          ))}
                        </div>
                      )}

                      {notification.length !== 0 ?
                        <Pagination
                          activePage={currPage}
                          itemsCountPerPage={total_notification_per_page}
                          totalItemsCount={totalNotification}
                          pageRangeDisplayed={5}
                          onChange={handlePageChange.bind(this)}
                        />
                        : null}
                    </>
                  )}
              </div>
            </div>
          </div>)}
    </div>
  )
}

export default Notification
