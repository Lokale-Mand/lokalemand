import React, { useRef, useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import HomeContainer from './homecontainer/HomeContainer'
import Loader from './loader/Loader'
import ProductContainer from './product/ProductContainer'
import api from '../api/api'
import { ActionTypes } from '../model/action-type'
import { AiOutlineClose, AiOutlineCloseCircle } from 'react-icons/ai'
import { Modal } from 'react-bootstrap'

const MainContainer = () => {

    const dispatch = useDispatch()

    const modalRef = useRef()

    const city = useSelector(state => (state.city))
    const shop = useSelector(state => (state.shop))
    const setting = useSelector(state => state.setting)

    const fetchShop = (city_id, latitude, longitude) => {
        api.getShop(city_id, latitude, longitude)
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {
                    dispatch({ type: ActionTypes.SET_SHOP, payload: result.data })
                }
            })

    }
    useEffect(() => {
        if (city.city !== null && shop.shop === null) {
            fetchShop(city.city.id, city.city.latitude, city.city.longitude);
        }
    }, [city])

    useEffect(() => {

        if (modalRef.current && setting.setting !== null) {
            modalRef.current.click()
        }
    }, [setting])

    const [showPop, setShowPop] = useState(true);

    // setTimeout(() => {
    //     modalRef.current.click()
    // }, 6000);
    const placeHolderImage = (e) =>{
        e.target.src = setting.setting?.web_logo
    }
    return (
        <>

            {setting.setting === null
                ? <Loader screen='full' />
                : (
                    <>
                        <div className='home-page content' style={{ paddingBottom: "5px", minHeight: "75vh" }}>
                            <HomeContainer />
                            <ProductContainer />
                        </div>

                        {parseInt(setting.setting.popup_enabled) === 1 ?
                            (
                                <>
                                    <Modal  className='popup'
                                    centered
                                    show={showPop}
                                    onBackdropClick={()=>setShowPop(false)}
                                    backdrop={"static"}
                                    >
                                        <Modal.Header onClick={()=>{setShowPop(false)}}>
                                            <AiOutlineClose size={32} fill='#fff' />
                                        </Modal.Header>
                                        <Modal.Body>
                                            <img src={setting.setting.popup_image} alt='image' onClick={() => {
                                                window.location = setting.setting.popup_url
                                            }} style={{ width: "100%", height: "100%" }} onError={placeHolderImage}></img>
                                        </Modal.Body>
                                    </Modal>
                                    
                                </>
                            ) : null}
                    </>)}
        </>

    )
}

export default MainContainer
