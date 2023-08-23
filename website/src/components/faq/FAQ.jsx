
import React, { useEffect, useState } from 'react'
import api from '../../api/api'
import coverImg from '../../utils/cover-img.jpg'
import './faq.css'
import { AiOutlinePlus, AiOutlineMinus } from 'react-icons/ai'
import Loader from '../loader/Loader'
import No_Notification from '../../utils/zero-state-screens/No_Notification.svg'
import Pagination from 'react-js-pagination';
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'


const FAQ = () => {

    const [faqs, setfaqs] = useState(null)

    const total_faqs_per_page = 10

    const [totalFaq, settotalFaq] = useState(null)
    const [currPage, setcurrPage] = useState(1)
    const [offset, setoffset] = useState(0)


    useEffect(() => {

        const getFAQs = async () => {
            await api.getFaq(total_faqs_per_page, offset)
                .then(response => response.json())
                .then(result => {
                    setfaqs(result)
                    settotalFaq(result.total)
                })
                .catch(error => console.error(error))

        }
        getFAQs()
    }, [offset])

    //page change
    const handlePageChange = (pageNum) => {
        setcurrPage(pageNum);
        setoffset(pageNum * total_faqs_per_page - total_faqs_per_page)
    }
    const {t} = useTranslation()
    return (
        <section id='faq' className='faq'>
            <>
                <div className='cover'>
                    <img src={coverImg} className='img-fluid' alt="cover"></img>
                    <div className='title'>
                        <h3>{t("faq")}</h3>
                        <span> <Link to="/" className='text-light text-decoration-none'>{t("home")} /</Link> </span><span className='active'>{t("faq")}</span>
                    </div>
                </div>

                {faqs === null ? 
                <Loader />
                    : (

                        <div className='container'>
                            <div className='faq-container'>
                                {faqs.status === 0
                                    ? <div className='no-faq'>
                                        <img src={No_Notification} alt='no-notification'></img>
                                        <p>{faqs.message}</p>
                                    </div>
                                    : (
                                        <>
                                            {faqs.data.map((faq, index) => (
                                                <div key={index} className='faq-card'>
                                                    <button type='button' data-bs-toggle="collapse" data-bs-target={"#collapseExample" + index} aria-expanded="false" aria-controls="collapseExample" onClick={() => {
                                                        if (document.getElementById(`faq-icon1${index}`).classList.contains('active')) {
                                                            document.getElementById(`faq-icon1${index}`).classList.remove('active')
                                                            document.getElementById(`faq-icon2${index}`).classList.add('active')
                                                        }
                                                        else {
                                                            document.getElementById(`faq-icon2${index}`).classList.remove('active')
                                                            document.getElementById(`faq-icon1${index}`).classList.add('active')
                                                        }

                                                        document.getElementById(`faq-icon${index}`)
                                                    }}>
                                                        <span>{faq.question}</span>
                                                        <span id={`faq-icon1${index}`} className='icon active'><AiOutlinePlus fontSize={"3rem"} fill="#fff" /></span>
                                                        <span id={`faq-icon2${index}`} className='icon'><AiOutlineMinus fontSize={"3rem"} fill="#fff" /></span>
                                                    </button>
                                                    <div className="collapse border-top" id={"collapseExample" + index}>
                                                        <div className="answer">
                                                            {faq.answer}e
                                                        </div>
                                                    </div>
                                                </div>
                                            ))}
                                            {faqs.length !== 0 ?
                                                <Pagination
                                                    activePage={currPage}
                                                    itemsCountPerPage={total_faqs_per_page}
                                                    totalItemsCount={totalFaq}
                                                    pageRangeDisplayed={5}
                                                    onChange={handlePageChange.bind(this)}
                                                />
                                                : null}

                                        </>

                                    )}
                            </div>
                        </div>

                    )}
            </>

        </section>
    )
}

export default FAQ
