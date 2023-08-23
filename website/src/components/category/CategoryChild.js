import React, { useEffect, useState } from 'react'
import api from '../../api/api'
import { motion } from 'framer-motion'

const CategoryChild = (props) => {

    const fetchCategory = () => {
        const id = props.ctg_id;
        api.getCategory(id)
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {
                    setcategory(result.data)
                }
            })
            .catch(error => console.log("error ", error))
    }

    useEffect(() => {
        fetchCategory();
    }, [])

    const [category, setcategory] = useState(null)

    return (
        <div id={props.id} className='collapse'>
            {/* <button type='button'>xyz</button>
            <button type='button'>abc</button> */}
            {category === null
                ? (
                    <div className="d-flex justify-content-center">
                        <div className="spinner-border" role="status">
                            <span className="visually-hidden">Loading...</span>
                        </div>
                    </div>
                )
                : (
                    <div className='sub-categories'>
                        {category.map((ctg, index) => (

                            <button type='button' className='p-3 border-bottom' key={index}>
                                <img src={ctg.image_url} alt={ctg.subtitle} className='me-3' style={{marginLeft:"40px"}}/>
                                {ctg.name}
                            </button>

                        ))}
                    </div>
                )}
        </div>
    )
}

export default CategoryChild
