import React, { useEffect, useRef, useState } from 'react'
import './order.css'
import api from '../../api/api'
import Cookies from 'universal-cookie';
import { FaRupeeSign } from "react-icons/fa";
import { AiOutlineCloseCircle } from 'react-icons/ai';
import Loader from '../loader/Loader';
import Pagination from 'react-js-pagination';
import No_Orders from '../../utils/zero-state-screens/No_Orders.svg'
import ReactToPrint from 'react-to-print';
import { toast } from 'react-toastify';
import { useTranslation } from 'react-i18next';
import axios from 'axios';
import { ProgressBar } from 'react-bootstrap';
import { useSelector } from 'react-redux';


const Order = () => {


    const [NoOrders, setNoOrders] = useState(false);
    const [totalOrders, settotalOrders] = useState(null)
    const [offset, setoffset] = useState(0)
    const [currPage, setcurrPage] = useState(1)
    const [isLoader, setisLoader] = useState(false)
    //initialize Cookies
    const cookies = new Cookies();
    const componentRef = useRef();
    const total_orders_per_page = 10;
    const [orderInvoiceId, setOrderinvoiceId] = useState(null)

    const setting = useSelector((state)=> state.setting)

    const fetchOrders = () => {
        api.getOrders(cookies.get('jwt_token'), total_orders_per_page, offset)
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {
                    setisLoader(false)
                    setorders(result.data);
                    settotalOrders(result.total)
                }
                else if (result.message === "No orders found") {
                    setisLoader(false)
                    setNoOrders(true)
                }
            })
    }

    useEffect(() => {
        setisLoader(true)
        fetchOrders()
    }, [offset])

    //page change
    const handlePageChange = (pageNum) => {
        setcurrPage(pageNum);
        setoffset(pageNum * total_orders_per_page - total_orders_per_page)
    }


    const getInvoice = async (Oid) => {
        setisLoader(true)
        let postData = {
            order_id: Oid,
        }
        axios({
            url: `${process.env.REACT_APP_API_URL}${process.env.REACT_APP_API_SUBURL}/invoice_download`,
            method: 'post',
            responseType: 'blob',
            /*responseType: 'application/pdf',*/
            data: postData,
            headers: {
                Authorization: `Bearer ${cookies.get('jwt_token')}`
            }
        }).then(response => {


            var fileURL = window.URL.createObjectURL(new Blob([response.data]));
            var fileLink = document.createElement('a');
            fileLink.href = fileURL;
            fileLink.setAttribute('download', 'Invoice-No:' + Oid + '.pdf');
            document.body.appendChild(fileLink);
            fileLink.click();
            setisLoader(false)


        }).catch(error => {
            if (error.request.statusText) {
                toast.error(error.request.statusText);
            } else if (error.message) {
                toast.error(error.message);
            } else {
                toast.error("Something went wrong!");
            }
        });
    }

    const closeModalRef = useRef();
    const getOrderStatus = (pid) => {
        for (let i = 0; i < orders.length; i++) {
            const element = orders[i];
            // if (element.id === pid) {
            //     let html = `

            //                         `;
            //     document.getElementById('mainContentTrack').innerHTML = html;

            // }
            closeModalRef.current.click()
        }
    }
    const [orders, setorders] = useState([])
    const [element, setElement] = useState({});
    const setHtml = (ID) => {

        orders.map((obj, index) => {
            if (obj.id === Number(ID)) {

                setElement(obj)

            }
        })
    }
    const handlePrint = () => {
        if (closeModalRef.current) {
            closeModalRef.current.click();
            toast.success('Invoice Downloaded Successfully')
        }
    };
    const { t } = useTranslation();
    return (
        <div className='order-list'>
            <div className='heading'>
                {t("all_orders")}
            </div>

            {isLoader ?
                <div className='my-5'><Loader width='100%' height='350px' /></div>
                : <>
                    {orders && orders.length === 0
                        ? <div className='d-flex align-items-center p-4 no-orders'>
                            <img src={No_Orders} alt='no-orders'></img>
                            <p>{t("no_order")}</p>
                        </div>
                        :
                        <>
                            <table className='order-list-table'>
                                <thead>
                                    <tr>
                                        <th>{t("order")}</th>
                                        <th>{t("products") + " " + t("name")}</th>
                                        <th>{t("date")}</th>
                                        <th>{t("total")}</th>
                                        <th>{t("action")}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {orders && orders.map((order, index) => (
                                        <tr key={index} className={index === orders.length - 1 ? 'last-column' : ''}>
                                            <th>{`#${order.order_id} `}</th>
                                            <th className='product-name d-table-cell verticall-center flex-column justify-content-center'>{order.items.map((item, ind) => (
                                                <div className="column-container">
                                                    <span key={ind}>{item.product_name},</span>
                                                </div>
                                            ))}
                                            </th>
                                            <th>
                                                {order.created_at.substring(0, 10)}
                                            </th>
                                            <th className='total'>
                                                <FaRupeeSign fontSize={'1.7rem'} /> {order.final_total}
                                            </th>
                                            <th className='button-container'>
                                                <button type='button' id={`track - ${order.order_id} `} data-bs-toggle="modal" data-bs-target="#trackModal" className='track' value={order.order_id} onClick={(e) => { setHtml(e.target.value); getOrderStatus(e.target.value) }}>{t("track_order")}</button>
                                                <button type='button' id={`invoice - ${order.order_id} `} className='Invoice' value={order.order_id} onClick={(e) => { setHtml(e.target.value); getInvoice(e.target.value) }}>{t("get_invoice")}</button>
                                            </th>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </>
                    }
                </>
            }

            {orders && orders.length !== 0 ?
                <Pagination
                    activePage={currPage}
                    itemsCountPerPage={total_orders_per_page}
                    totalItemsCount={totalOrders}
                    pageRangeDisplayed={5}
                    onChange={handlePageChange.bind(this)}
                />
                : null}





            <div id="track">
                <div className="modal fade new-track" id="trackModal" aria-labelledby="TrackModalLabel" aria-hidden="true">
                    <div className='modal-dialog'>
                        <div className="modal-content" style={{ borderRadius: "10px", maxWidth: "100%", padding: "30px 15px", zIndex: -2 }}>
                            <div id="mainContentTrack">

                                <section class="track" id="printMe">
                                    <div class="d-flex justify-content-between align-items-center mx-5">
                                        <h5 class="page-header">{setting.setting?.app_name}</h5>
                                        <h5 class="page-header">{t("mobile")}{element && element.mobile}</h5>
                                        <button type="button" class="bg-white" data-bs-dismiss="modal" aria-label="Close" ref={closeModalRef} style={{ width: '30px' }}><AiOutlineCloseCircle size={26} /></button>
                                    </div>
                                    <div class="d-flex flex-column">
                                        <div class="d-flex flex-column mx-5 justify-content-around position-relative">
                                            <div class="d-flex my-4 align-items-center">
                                                <div class="col-sm-4 bg-white track-col"> <span class="rounded-circle px-3 pt-2 fs-2 track-order-icon btn " style={{ background: `${element && element.active_status >= "2" ? 'var(--secondary-color-light)' : ''}` }}><i class="bi bi-cart "></i></span></div>
                                                <span class=""> {t("order_status_display_name_recieved")}</span>
                                                <ProgressBar now={element && element.active_status >= "6" ? 100 : element.active_status >= "5" ? 75 : element.active_status >= "3" ? 47 : element.active_status === "2" ? 15 : 0} />
                                            </div>
                                            
                                            <div class="d-flex my-4 align-items-center">
                                                <div class="col-sm-4 bg-white track-col"> <span class="rounded-circle px-3 pt-2 fs-2 track-order-icon btn " style={{ background: `${element && element.active_status >= "3" ? 'var(--secondary-color-light)' : ''}` }}><i class="bi bi-truck "></i></span></div>
                                                <span> {t("order_status_display_name_shipped")}</span>
                                            </div>
                                            <div class="d-flex my-4 align-items-center">
                                                <div class="col-sm-4 bg-white track-col"> <span class="rounded-circle px-3 pt-2 fs-2 btn track-order-icon " style={{ background: `${element && element.active_status >= "5" ? 'var(--secondary-color-light)' : ''}` }}><i class="bi bi-bus-front "></i></span></div>
                                                <span> {t("order_status_display_name_out_for_delivery")}</span>
                                            </div>
                                            <div class="d-flex my-4 align-items-center">
                                                <div class="col-sm-4 bg-white track-col"> <span class="rounded-circle px-3 pt-2 fs-2 btn track-order-icon " style={{ background: `${element && element.active_status >= "6" ? 'var(--secondary-color-light)' : ''}` }}><i class="bi bi-check "></i></span></div>
                                                <span> {t("order_status_display_name_delivered")}</span>
                                            </div>
                                        </div>
                                    </div>



                                </section>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Order
