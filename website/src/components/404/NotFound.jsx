import React from 'react'
import { useNavigate } from 'react-router-dom'
import Not_Found from '../../utils/zero-state-screens/404.svg'
import './notfound.css'
import { motion } from 'framer-motion'
import { useTranslation } from 'react-i18next'
import { useSelector } from 'react-redux'


const NotFound = (props) => {
  const {t} = useTranslation()
  const navigate = useNavigate()
  const setting = useSelector(state => state.setting)
  const placeHolderImage = (e) =>{
    e.target.src = setting.setting?.web_logo
}
  return (
    <section id='not-found' className='not-found'>
      <div className='container'>
        <div className='not-found-container'>

          <img src={Not_Found} alt='not-found' onError={placeHolderImage}></img>
          <p >{props.text ? props.text : t("page_not_found")}</p>
          <button whileTap={{ scale: 0.8 }} type='button' onClick={() => {
            navigate('/')
          }}>{t("go_to_home")}</button>
        </div>
      </div>
    </section>
  )
}

export default NotFound
