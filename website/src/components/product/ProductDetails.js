import React, { useCallback, useEffect, useRef, useState } from 'react'
import './product.css'

// import { FaRupeeSign } from "react-icons/fa";
import { BsHeart, BsShare, BsPlus, BsHeartFill } from "react-icons/bs";
import { BiMinus, BiLink } from 'react-icons/bi'
import { toast } from 'react-toastify'
import api from '../../api/api';
import { useDispatch, useSelector } from 'react-redux';
import { ActionTypes } from '../../model/action-type';
import { useNavigate, Link, useParams } from 'react-router-dom';
import Cookies from 'universal-cookie'
import Slider from 'react-slick'
import { AiOutlineEye } from 'react-icons/ai'
import { FaChevronLeft, FaChevronRight, FaRupeeSign } from "react-icons/fa";
import { getSelectedProductId, removeSelectedProductId, setSelectedProductId } from '../../utils/manageLocalStorage';
import { FacebookIcon, FacebookShareButton, TelegramIcon, TelegramShareButton, WhatsappIcon, WhatsappShareButton } from 'react-share';
import QuickViewModal from './QuickViewModal';
import { Dropdown } from 'react-bootstrap';
import { IoIosArrowDown } from 'react-icons/io';
import { useTranslation } from 'react-i18next';
import Loader from '../loader/Loader';

function SamplePrevArrow(props) {
    const { className, style, onClick } = props;
    return (
        <div
            className={className}
            style={window.innerWidth > 450 ? { ...style, display: "flex", alignItems: "center", justifyContent: "center", background: "var(--secondary-color)", borderRadius: "50%", width: "30px", height: "30px" } : { display: "none" }}
            onClick={onClick}
        />
    );
}

function SampleNextArrow(props) {
    const { className, style, onClick } = props;
    return (
        <div
            className={className}
            style={window.innerWidth > 450 ? { ...style, display: "flex", alignItems: "center", justifyContent: "center", margin: "0 -10px", background: "var(--secondary-color)", borderRadius: "50%", width: "30px", height: "30px" } : { display: "none" }}
            onClick={onClick}
        />
    );
}

const ProductDetails = () => {

    const dispatch = useDispatch();
    const navigate = useNavigate();
    const cookies = new Cookies()
    const { slug } = useParams()

    const product = useSelector(state => state.selectedProduct);
    const cart = useSelector(state => state.cart);
    const city = useSelector(state => state.city);
    const setting = useSelector(state => state.setting);

    useEffect(() => {
        return () => {
            dispatch({ type: ActionTypes.CLEAR_SELECTED_PRODUCT, payload: null })
            setproductcategory({})
            setproductbrand({})
        };
    }, [])


    const [mainimage, setmainimage] = useState("")
    const [images, setimages] = useState([])
    const [productdata, setproductdata] = useState({})
    const [productSize, setproductSize] = useState({})
    const [productcategory, setproductcategory] = useState({})
    const [productbrand, setproductbrand] = useState({})
    const [relatedProducts, setrelatedProducts] = useState(null)
    const [loading, setisLoading] = useState(false);

    const [quantity, setQuantity] = useState([])
    const [selectedVariant, setSelectedVariant] = useState(null);

    const getCategoryDetails = (id) => {

        api.getCategory()
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {

                    result.data.forEach(ctg => {
                        if (ctg.id === id) {
                            setproductcategory(ctg);
                        }
                    });
                }
            })
            .catch((error) => console.log(error))
    }

    const getBrandDetails = (id) => {

        api.getBrands()
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {

                    result.data.forEach(brnd => {
                        if (brnd.id === id) {
                            setproductbrand(brnd);
                        }
                    });
                }
            })
            .catch((error) => console.log(error))
    }

    const getProductDatafromApi = () => {

        api.getProductbyId(city.city && city.city.id, city.city.latitude, city.city.longitude, product.selectedProduct_id, cookies.get('jwt_token'))
            .then(response => response.json())
            .then(result => {
                if (result.status === 1) {
                    setproductdata(result.data);
                    // setSelectedVariant(result.data.variants[0])

                    setmainimage(result.data.image_url)
                    setimages(result.data.images)
                    getCategoryDetails(result.data.category_id)
                    getBrandDetails(result.data.brand_id)
                    setSelectedVariant(result.data.variants.find(element => element.id === selectedVariant.id));

                }
            })
            .catch(error => console.log(error))


    }


    useEffect(() => {
        const selected_prod_id = getSelectedProductId()
        if (selected_prod_id !== null && selected_prod_id !== undefined) {
            dispatch({ type: ActionTypes.SET_SELECTED_PRODUCT, payload: selected_prod_id })
        }
    }, [quantity, cart])

    useEffect(() => {
        const findProductBySlug = async () => {

            await api.getProductbyFilter(city.city.id, city.city.latitude, city.city.longitude, { slug: slug }, cookies.get('jwt_token'))
                .then(response => response.json())
                .then(result => {
                    if (result.status === 1) {

                        dispatch({ type: ActionTypes.SET_SELECTED_PRODUCT, payload: result.data[0].id })
                        // setSelectedProductId(result.data[0].id)
                    }
                    else {
                    }
                })
                .catch(error => console.log(error))
        }
        if (city.city !== null && slug !== undefined) {
            findProductBySlug()
        }
    }, [city, cart])

    useEffect(() => {
        if (Object.keys(productdata).length !== 0) {

            api.getProductbyFilter(city.city.id, city.city.latitude, city.city.longitude, {
                category_id: productdata.category_id,
            }, cookies.get('jwt_token'))
                .then(response => response.json())
                .then(result => {
                    if (result.status === 1) {
                        setproductSize(result.sizes)
                        setrelatedProducts(result.data)
                    }
                })
                .catch(error => console.log(error))
        }
    }, [productdata, cart])



    useEffect(() => {
        if (city.city !== null) {
            if (product.selectedProduct_id !== null && product.status !== "loading") {
                getProductDatafromApi()
            }

        }
    }, [city, product, cart])

    useEffect(() => {
        return () => {
            removeSelectedProductId()
        };
    }, [])
    const settings = {
        infinite: false,
        slidesToShow: 5,
        initialSlide: 0,
        prevArrow: (
            <button type="button" className="slick-prev">
                <FaChevronLeft size={30} className="prev-arrow" />
            </button>
        ),
        nextArrow: (
            <button type="button" className="slick-next">
                <FaChevronRight color='#f7f7f7' size={30} className='next-arrow' />
            </button>
        ),
        responsive: [
            {
                breakpoint: 1199,
                settings: {
                    slidesToShow: 4,
                }
            },
            {
                breakpoint: 1024,
                settings: {
                    slidesToShow: 3,
                }
            },
            {
                breakpoint: 768,
                settings: {
                    slidesToShow: 2,
                }
            },
            {
                breakpoint: 425,
                settings: {
                    slidesToShow: 1.5,
                    dots: true,
                    arrows: false,
                }
            }
        ]
    };
    const settings_subImage = {

        infinite: false,
        slidesToShow: 3,
        initialSlide: 0,
        // centerMargin: "10px",
        margin: "20px",
        prevArrow: (
            <button
                type="button"
                className="slick-prev"
                onClick={(e) => {
                    setmainimage(e.target.value);
                }}
            >
                <FaChevronLeft size={30} className="prev-arrow" />
            </button>
        ),
        nextArrow: (
            <button
                type="button"
                className="slick-next"
                onClick={(e) => {
                    setmainimage(e.target.value);
                }}
            >
                <FaChevronRight
                    color="#f7f7f7"
                    size={30}
                    className="next-arrow"
                />
            </button>
        ),
        responsive: [
            {
                breakpoint: 1024,
                settings: {
                    slidesToShow: 4,
                    slidesToScroll: 1,
                    infinite: true,
                },
            },
            {
                breakpoint: 768,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 1,
                },
            },
        ],
    }

    const [selectedProduct, setselectedProduct] = useState({})
    const [productSizes, setproductSizes] = useState(null)
    const [offerConatiner, setOfferContainer] = useState(0)
    const [variant_index, setVariantIndex] = useState(0)
    const [realted_variant_index, setRelatedVariantIndex] = useState(0)

    //for product variants dropdown in product card



    useEffect(() => {
        if (productdata && selectedVariant === null && productdata.variants) {
            setSelectedVariant(productdata.variants[0])
        }

    }, [productdata, cart]);

    //Add to Cart
    const addtoCart = async (product_id, product_variant_id, qty) => {
        setisLoading(true)
        await api.addToCart(cookies.get('jwt_token'), product_id, product_variant_id, qty)
            .then(response => response.json())
            .then(async (result) => {
                if (result.status === 1) {
                    toast.success(result.message)
                    await api.getCart(cookies.get('jwt_token'), city.city.latitude, city.city.longitude)
                        .then(resp => resp.json())
                        .then(res => {
                            if (res.status === 1)
                                dispatch({ type: ActionTypes.SET_CART, payload: res })
                        })
                    await api.getCart(cookies.get('jwt_token'), city.city.latitude, city.city.longitude, 1)
                        .then(resp => resp.json())
                        .then(res => {
                            if (res.status === 1)
                                dispatch({ type: ActionTypes.SET_CART_CHECKOUT, payload: res.data })


                        })
                        .catch(error => console.log(error))
                }
                else {
                    toast.error(result.message)
                }
                setisLoading(false)
            })
    }

    //remove from Cart
    const removefromCart = async (product_id, product_variant_id) => {
        setisLoading(true)
        await api.removeFromCart(cookies.get('jwt_token'), product_id, product_variant_id)
            .then(response => response.json())
            .then(async (result) => {
                if (result.status === 1) {
                    toast.success(result.message)
                    await api.getCart(cookies.get('jwt_token'), city.city.latitude, city.city.longitude)
                        .then(resp => resp.json())
                        .then(res => {
                            if (res.status === 1)
                                dispatch({ type: ActionTypes.SET_CART, payload: res })
                            else
                                dispatch({ type: ActionTypes.SET_CART, payload: null })
                        })
                    await api.getCart(cookies.get('jwt_token'), city.city.latitude, city.city.longitude, 1)
                        .then(resp => resp.json())
                        .then(res => {
                            if (res.status === 1)
                                dispatch({ type: ActionTypes.SET_CART_CHECKOUT, payload: res.data })


                        })
                        .catch(error => console.log(error))
                }
                else {
                    toast.error(result.message)
                }
                setisLoading(false)
            })
    }

    //Add to favorite
    const addToFavorite = async (product_id) => {
        setisLoading(true)
        await api.addToFavotite(cookies.get('jwt_token'), product_id)
            .then(response => response.json())
            .then(async (result) => {
                if (result.status === 1) {
                    toast.success(result.message)
                    await api.getFavorite(cookies.get('jwt_token'), city.city.latitude, city.city.longitude)
                        .then(resp => resp.json())
                        .then(res => {
                            if (res.status === 1)
                                dispatch({ type: ActionTypes.SET_FAVORITE, payload: res })
                        })
                }
                else {
                    toast.error(result.message)
                }
                setisLoading(false)
            })
    }
    const favorite = useSelector(state => (state.favorite))
    const removefromFavorite = async (product_id) => {
        setisLoading(true)
        await api.removeFromFavorite(cookies.get('jwt_token'), product_id)
            .then(response => response.json())
            .then(async (result) => {
                if (result.status === 1) {
                    toast.success(result.message)
                    await api.getFavorite(cookies.get('jwt_token'), city.city.latitude, city.city.longitude)
                        .then(resp => resp.json())
                        .then(res => {
                            if (res.status === 1)
                                dispatch({ type: ActionTypes.SET_FAVORITE, payload: res })
                            else
                                dispatch({ type: ActionTypes.SET_FAVORITE, payload: null })
                        })
                }
                else {
                    toast.error(result.message)
                }
                setisLoading(false)
            })
    }

    useEffect(() => {

        if (productdata.length > 0) {
            setSelectedVariant(productdata.varaints[0])
        }
    }, [productdata, cart])

    useEffect(() => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }, [productdata])

    const handleVariantChange = (variant, index) => {
        setSelectedVariant(variant);
        setVariantIndex(index)
    };

    const { t } = useTranslation()
    return (
        <>
            {loading && <Loader screen='full' />}
            <div className='product-details-view'>

                <div className='container' style={{ gap: "20px" }}>
                    <div className='top-wrapper'>

                        {product.selectedProduct_id === null || Object.keys(productdata).length === 0 || Object.keys(productSize).length === 0 ? (
                            <div className="d-flex justify-content-center">
                                <div className="spinner-border" role="status">
                                    <span className="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        )
                            : (

                                <div className='row body-wrapper '>
                                    <div className="col-xl-4 col-lg-6 col-md-12 col-12">

                                        <div className='image-wrapper '>
                                            <div className='main-image col-12 border'>
                                                <img src={mainimage} alt='main-product' className='col-12' style={{ width: '85%' }} />
                                            </div>


                                            <div className='sub-images-container'>
                                                {images.length >= 4 ?
                                                    <>
                                                        <Slider {...settings_subImage}>
                                                            <>
                                                                <div >
                                                                    <div className={`sub-image border `}>

                                                                        <img src={mainimage} className='col-12' alt="product" onClick={() => {
                                                                            setmainimage(mainimage)
                                                                        }}></img>
                                                                    </div>
                                                                </div>
                                                                {images.map((image, index) => (
                                                                    <div key={index} >
                                                                        <div className={`sub-image border ${mainimage === image ? 'active' : ''}`}>

                                                                            <img src={image} className='col-12' alt="product" onClick={() => {
                                                                                setmainimage(image)
                                                                            }}></img>
                                                                        </div>
                                                                    </div>
                                                                ))}
                                                            </>
                                                        </Slider>


                                                    </> :
                                                    <>
                                                        {images.map((image, index) => (
                                                            <div key={index} className={`sub-image border ${mainimage === image ? 'active' : ''}`}>
                                                                <img src={image} className='col-12 ' alt="product" onClick={() => {
                                                                    setmainimage(image)
                                                                }}></img>
                                                            </div>
                                                        ))}
                                                    </>
                                                }
                                            </div>
                                        </div>
                                    </div>
                                    <div className="col-xl-8 col-lg-6 col-md-12 col-12">
                                        <div className='detail-wrapper'>
                                            <div className='top-section'>
                                                <p className='product_name'>{productdata.name}</p>
                                                {Object.keys(productbrand).length === 0
                                                    ? null
                                                    : (
                                                        <div className='product-brand'>
                                                            <span className='brand-title'>{t("brand")}:</span>
                                                            <span className='brand-name'>
                                                                {productbrand.name}
                                                            </span>
                                                        </div>
                                                    )}
                                                <div className='d-flex flex-row gap-2 align-items-center my-1'>
                                                    {/* <span id={`price-section`} className="d-flex align-items-center">
                                                    <p id='fa-rupee' className='m-0'><FaRupeeSign fill='var(--secondary-color)' /></p> {productdata.variants[0].discounted_price}
                                                </span> */}
                                                    <div id="price-section" className='d-flex flex-row gap-2 align-items-center my-1'>
                                                        {setting.setting && setting.setting.currency}<p id='fa-rupee' className='m-0'>{selectedVariant ? (selectedVariant.discounted_price == 0 ? selectedVariant.price.toFixed(setting.setting && setting.setting.decimal_point) : selectedVariant.discounted_price.toFixed(setting.setting && setting.setting.decimal_point)) : (productdata.variants[0].discounted_price === 0 ? productdata.variants[0].price.toFixed(setting.setting && setting.setting.decimal_point) : productdata.variants[0].discounted_price.toFixed(setting.setting && setting.setting.decimal_point))}</p>
                                                    </div>
                                                    <input type="hidden" id="productdetail-selected-variant-id" name="variant" value={selectedVariant ? selectedVariant.id : productdata.variants[0].id} />
                                                </div>

                                            </div>
                                            <div className='bottom-section'>
                                                <p>{t("product_variants")}</p>

                                                <div className='d-flex gap-3 bottom-section-content'>
                                                    <div className='variants'>

                                                        <div className="row">
                                                            {productdata.variants.map((variant, index) => {
                                                                return (
                                                                    <>
                                                                        <div className="variant-section ">
                                                                            <div className={`variant-element ${variant_index === index ? 'active' : ''}  ${productdata.is_unlimited_stock ? "" : (variant.cart_count >= variant.stock ? "out_of_stock" : "")} `} key={index}>
                                                                                <label className="element_container " htmlFor={`variant${index}`}>
                                                                                    <div className="top-section">

                                                                                        <input type="radio" name="variant" id={`variant${index}`} checked={variant_index === index} disabled={productdata.is_unlimited_stock ? false : (variant.cart_count >= variant.stock ? true : false)} onChange={() => handleVariantChange(variant, index)} />
                                                                                    </div>
                                                                                    <div className="h-100">
                                                                                        <span className="d-flex align-items-center flex-column">{variant.measurement} {variant.stock_unit_name} </span>
                                                                                    </div>
                                                                                </label>

                                                                            </div>
                                                                        </div>
                                                                    </>

                                                                );
                                                            })}
                                                        </div>
                                                    </div>
                                                    <div className="cart_option">

                                                        {selectedVariant ? (selectedVariant.cart_count >= 1 ? <>
                                                            <div id={`input-cart-quickview`} className="input-to-cart">
                                                                <button type='button' onClick={() => {

                                                                    if (selectedVariant.cart_count === 1) {

                                                                        removefromCart(productdata.id, selectedVariant.id)
                                                                    }
                                                                    else {
                                                                        addtoCart(productdata.id, selectedVariant.id, selectedVariant.cart_count - 1)

                                                                    }

                                                                }} className="wishlist-button"><BiMinus fill='#fff' /></button>
                                                                <span id={`input-quickview`} >{selectedVariant.cart_count}</span>
                                                                <button type='button' onClick={() => {

                                                                    if (productdata.is_unlimited_stock) {
                                                                        if (selectedVariant.cart_count >= Number(setting.setting.max_cart_items_count)) {
                                                                            toast.error('Apologies, maximum product quantity limit reached')
                                                                        }
                                                                        else {
                                                                            addtoCart(productdata.id, selectedVariant.id, selectedVariant.cart_count + 1)

                                                                        }
                                                                    }
                                                                    else {

                                                                        if (selectedVariant.cart_count >= Number(selectedVariant.stock)) {
                                                                            toast.error('OOps, Limited Stock Available')
                                                                        }
                                                                        else if (selectedVariant.cart_count >= Number(setting.setting.max_cart_items_count)) {
                                                                            toast.error('Apologies, maximum cart quantity limit reached')
                                                                        }
                                                                        else {
                                                                            addtoCart(productdata.id, selectedVariant.id, selectedVariant.cart_count + 1)

                                                                        }
                                                                    }

                                                                }} className="wishlist-button"><BsPlus fill='#fff' /> </button>


                                                            </div>
                                                        </> : <>
                                                            <button type='button' id={`Add-to-cart-quickview`} className='add-to-cart'
                                                                onClick={() => {
                                                                    if (cookies.get('jwt_token') !== undefined) {
                                                                        if (productdata.is_unlimited_stock) {
                                                                            addtoCart(productdata.id, selectedVariant.id, 1)

                                                                        } else {

                                                                            if (selectedVariant.status) {
                                                                                addtoCart(productdata.id, selectedVariant.id, 1)
                                                                            } else {
                                                                                toast.error('OOps, Limited Stock Available')
                                                                            }
                                                                        }
                                                                    }
                                                                    else {
                                                                        toast.error(t("required_login_message_for_cartRedirect"))
                                                                    }
                                                                }}>{t("add_to_cart")}</button>
                                                        </>)
                                                            : productdata.variants[0].cart_count >= 1 ?
                                                                <>
                                                                    <div id={`input-cart-quickview`} className="input-to-cart">
                                                                        <button type='button' onClick={() => {

                                                                            if (productdata.variants[0].cart_count === 1) {

                                                                                removefromCart(productdata.id, productdata.variants[0].id)
                                                                            }
                                                                            else {
                                                                                addtoCart(productdata.id, productdata.variants[0].id, productdata.variants[0].cart_count - 1)
                                                                                setQuantity(quantity - 1);
                                                                            }

                                                                        }} className="wishlist-button"><BiMinus fill='#fff' /></button>
                                                                        <span id={`input-quickview`} >{productdata.variants[0].cart_count}</span>
                                                                        <button type='button' onClick={() => {

                                                                            if (productdata.is_unlimited_stock) {
                                                                                if (productdata.variants[0].cart_count >= Number(setting.setting.max_cart_items_count)) {
                                                                                    toast.error('Apologies, maximum product quantity limit reached')
                                                                                }

                                                                                else {
                                                                                    addtoCart(productdata.id, productdata.variants[0].id, productdata.variants[0].cart_count + 1)

                                                                                }
                                                                            }
                                                                            else {

                                                                                if (productdata.variants[0].cart_count >= Number(setting.setting.max_cart_items_count)) {
                                                                                    toast.error('Apologies, maximum product quantity limit reached')
                                                                                }
                                                                                else if (productdata.variants[0].cart_count >= Number(productdata.variants[0].stock)) {
                                                                                    toast.error('OOps, Limited Stock Available')
                                                                                }
                                                                                else {
                                                                                    addtoCart(productdata.id, productdata.variants[0].id, productdata.variants[0].cart_count + 1)

                                                                                }
                                                                            }

                                                                        }} className="wishlist-button"><BsPlus fill='#fff' /> </button>


                                                                    </div>
                                                                </> : <>


                                                                    <button type='button' id={`Add-to-cart-quickview`} className='add-to-cart'
                                                                        onClick={() => {
                                                                            if (cookies.get('jwt_token') !== undefined) {
                                                                                if (productdata.is_unlimited_stock) {
                                                                                    addtoCart(productdata.id, productdata.varinats[0].id, 1)

                                                                                } else {

                                                                                    if (selectedVariant.status) {
                                                                                        addtoCart(productdata.id, productdata.varinats[0].id, 1)
                                                                                    } else {
                                                                                        toast.error('OOps, Limited Stock Available')
                                                                                    }
                                                                                }
                                                                            }
                                                                            else {
                                                                                toast.error(t("required_login_message_for_cartRedirect"))
                                                                            }
                                                                        }}>{t("add_to_cart")}</button>

                                                                </>}

                                                        {/* <button type='button' className='wishlist-product' onClick={() => addToFavorite(productdata.id)}><BsHeart /></button> */}
                                                        {

                                                            favorite.favorite && favorite.favorite.data.some(element => element.id === productdata.id) ? (
                                                                <button type="button" className='wishlist-product' onClick={() => {
                                                                    if (cookies.get('jwt_token') !== undefined) {
                                                                        removefromFavorite(productdata.id)
                                                                    } else {
                                                                        toast.error(t('required_login_message_for_cart'))
                                                                    }
                                                                }}
                                                                >
                                                                    <BsHeartFill fill='green' />
                                                                </button>
                                                            ) : (
                                                                <button key={productdata.id} type="button" className='wishlist-product' onClick={() => {
                                                                    if (cookies.get('jwt_token') !== undefined) {
                                                                        addToFavorite(productdata.id)
                                                                    } else {
                                                                        toast.error(t("required_login_message_for_cart"))
                                                                    }
                                                                }}>
                                                                    <BsHeart /></button>
                                                            )}
                                                    </div>
                                                </div>

                                                <div className='product-overview'>
                                                    <div className='product-seller'>
                                                        <span className='seller-title'>{t("brand")}:</span>
                                                        <span className='seller-name'>{productdata.seller_name} </span>
                                                    </div>
                                                    {productdata.tags !== "" ? (

                                                        <div className='product-tags'>
                                                            <span className='tag-title'>{t("product_tags")}:</span>
                                                            <span className='tag-name'>{productdata.tags} </span>
                                                        </div>
                                                    ) : ""}
                                                </div>
                                                <div className="share-product-container">
                                                    <span>{t("share_product")}:</span>

                                                    <ul className='share-product'>
                                                        <li className='share-product-icon'><WhatsappShareButton url={`${setting.setting && setting.setting.web_settings.website_url}product/${productdata.slug}`}><WhatsappIcon size={32} round={true} /> </WhatsappShareButton></li>
                                                        <li className='share-product-icon'><TelegramShareButton url={`${setting.setting && setting.setting.web_settings.website_url}product/${productdata.slug}`}><TelegramIcon size={32} round={true} /> </TelegramShareButton></li>
                                                        <li className='share-product-icon'><FacebookShareButton url={`${setting.setting && setting.setting.web_settings.website_url}product/${productdata.slug}`}><FacebookIcon size={32} round={true} /> </FacebookShareButton></li>
                                                        <li className='share-product-icon'>
                                                            <button type='button' onClick={() => {
                                                                navigator.clipboard.writeText(`${setting.setting && setting.setting.web_settings.website_url}product/${productdata.slug}`)
                                                                toast.success("Copied Succesfully!!")
                                                            }} > <BiLink size={30} /></button>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            )}

                    </div>

                    <div className='description-wrapper'>
                        <h5 className='title'>{t("product_desc_title")}</h5>

                        <div className='description' dangerouslySetInnerHTML={{ __html: productdata.description }}>
                        </div>
                    </div>

                    <div className='related-product-wrapper'>
                        <h5>{t("related_product")}</h5>
                        <div className='related-product-container'>
                            {relatedProducts === null
                                ? <div className="d-flex justify-content-center">
                                    <div className="spinner-border" role="status">
                                        <span className="visually-hidden">Loading...</span>
                                    </div>
                                </div>
                                :
                                <div className="row">

                                    <Slider {...settings}>
                                        {relatedProducts.map((related_product, index) => (
                                            <div className="col-md-3 col-lg-4">

                                                <div className='product-card'>

                                                    <div className='image-container' >

                                                        <span className='border border-light rounded-circle p-2 px-3' id='aiEye' onClick={() => { setselectedProduct(related_product) }} data-bs-toggle="modal" data-bs-target="#quickviewModal">
                                                            <AiOutlineEye
                                                            />
                                                        </span>
                                                        <img src={related_product.image_url} alt={related_product.slug} className='card-img-top' onClick={() => {
                                                            dispatch({ type: ActionTypes.SET_SELECTED_PRODUCT, payload: related_product.id })
                                                            setSelectedProductId(related_product.id)
                                                            setSelectedVariant(null)
                                                            getProductDatafromApi()
                                                            setQuantity(0)

                                                        }} />
                                                        {!related_product.is_unlimited_stock && related_product.variants[0].status === 0 &&
                                                            <div className="out_of_stockOverlay">
                                                                <p className="out_of_stockText">{t("out_of_stock")}</p>
                                                            </div>
                                                        }
                                                    </div>

                                                    <div className="card-body product-card-body p-3" onClick={() => {
                                                        dispatch({ type: ActionTypes.SET_SELECTED_PRODUCT, payload: related_product.id })
                                                        setSelectedProductId(related_product.id)
                                                        setSelectedVariant(null)
                                                        setQuantity(0);
                                                        getProductDatafromApi()
                                                        window.scrollTo({ top: 0, behavior: 'smooth' })

                                                    }} >
                                                        <h3>{product.name}</h3>
                                                        <div className='price'>

                                                            <span id={`price${index}-section`} className="d-flex align-items-center"><p id='relatedproduct-fa-rupee' className='m-0'><FaRupeeSign fill='var(--secondary-color)' /></p>{related_product.variants[0].discounted_price === 0 ? related_product.variants[0].price.toFixed(setting.setting && setting.setting.decimal_point) : related_product.variants[0].discounted_price.toFixed(setting.setting && setting.setting.decimal_point)} </span>

                                                        </div>
                                                        <div className='product_varients_drop'>
                                                            {related_product.variants.length > 1 ?
                                                                <>
                                                                    <div className='variant_selection' onClick={() => { setselectedProduct(related_product) }} data-bs-toggle="modal" data-bs-target="#quickviewModal">
                                                                        <span>{<>{related_product.variants[0].measurement} {related_product.variants[0].stock_unit_name}    </>}</span>
                                                                        <IoIosArrowDown />
                                                                    </div>
                                                                </>
                                                                :

                                                                <>
                                                                    <span className={`variant_value select-arrow ${related_product.variants[0].stock > 0 ? '' : 'text-decoration-line-through'}`}>{related_product.variants[0].measurement + " " + related_product.variants[0].stock_unit_name}
                                                                    </span>
                                                                </>}



                                                        </div>
                                                    </div>

                                                    <div className='d-flex flex-row border-top product-card-footer'>
                                                        <div className='border-end '>
                                                            {

                                                                favorite.favorite && favorite.favorite.data.some(element => element.id === related_product.id) ? (
                                                                    <button type="button" className='wishlist-product' onClick={() => {
                                                                        if (cookies.get('jwt_token') !== undefined) {
                                                                            removefromFavorite(related_product.id)
                                                                        } else {
                                                                            toast.error(t('required_login_message_for_cart'))
                                                                        }
                                                                    }}
                                                                    >
                                                                        <BsHeartFill fill='green' />
                                                                    </button>
                                                                ) : (
                                                                    <button key={related_product.id} type="button" className='wishlist-product' onClick={() => {
                                                                        if (cookies.get('jwt_token') !== undefined) {
                                                                            addToFavorite(related_product.id)
                                                                        } else {
                                                                            toast.error(t("required_login_message_for_cart"))
                                                                        }
                                                                    }}>
                                                                        <BsHeart /></button>
                                                                )}
                                                        </div>

                                                        <div className='border-end' style={{ flexGrow: "1" }} >
                                                            {related_product.variants[0].cart_count > 0 ? <>
                                                                <div id={`input-cart-productdetail`} className="input-to-cart">
                                                                    <button type='button' className="wishlist-button" onClick={() => {

                                                                        if (related_product.variants[0].cart_count === 1) {
                                                                            removefromCart(related_product.id, related_product.variants[0].id)

                                                                        }
                                                                        else {
                                                                            addtoCart(related_product.id, related_product.variants[0].id, related_product.variants[0].cart_count - 1)


                                                                        }

                                                                    }}><BiMinus size={20} fill='#fff' /></button>
                                                                    {/* <span id={`input-productdetail`} >{quantity}</span> */}
                                                                    <div className="quantity-container text-center">
                                                                        <input
                                                                            type="number"
                                                                            min="1"
                                                                            max={related_product.variants[0].stock}
                                                                            className="quantity-input bg-transparent text-center"
                                                                            value={related_product.variants[0].cart_count}
                                                                            // value={cart.cart && cart.cart.data.cart.some(element => element.id === product.variants[0].id ? element.qty : 0)}
                                                                            onChange={(e) => {
                                                                                setQuantity(parseInt(e.target.value));
                                                                            }}
                                                                            disabled
                                                                        />
                                                                    </div>
                                                                    <button type='button' className="wishlist-button" onClick={() => {

                                                                        if (related_product.is_unlimited_stock) {

                                                                            if (related_product.variants[0].cart_count < Number(setting.setting.max_cart_items_count)) {
                                                                                addtoCart(related_product.id, related_product.variants[0].id, related_product.variants[0].cart_count + 1)


                                                                            } else {
                                                                                toast.error('Apologies, maximum product quantity limit reached!')
                                                                            }
                                                                        } else {

                                                                            if (related_product.variants[0].cart_count >= Number(related_product.variants[0].stock)) {
                                                                                toast.error(t("out_of_stock_message"))
                                                                            }
                                                                            else if (related_product.variants[0].cart_count >= Number(related_product.total_allowed_quantity)) {
                                                                                toast.error('Apologies, maximum product quantity limit reached')
                                                                            } else {
                                                                                addtoCart(related_product.id, related_product.variants[0].id, related_product.variants[0].cart_count + 1)


                                                                            }
                                                                        }

                                                                    }}><BsPlus size={20} fill='#fff' /> </button>
                                                                </div>
                                                            </> : <>
                                                                <button type="button" id={`Add-to-cart-section${index}`} className='w-100 h-100 add-to-cart active' onClick={() => {
                                                                    if (cookies.get('jwt_token') !== undefined) {

                                                                        if (cart.cart && cart.cart.data.cart.some(element => element.product_id === related_product.id) && cart.cart.data.cart.some(element => element.product_variant_id === related_product.variants[0].id)) {
                                                                            toast.info('Product already in Cart')
                                                                        } else {
                                                                            if (Number(related_product.variants[0].stock) > 1) {

                                                                                addtoCart(related_product.id, related_product.variants[0].id, 1)
                                                                            } else {
                                                                                toast.error(t("out_of_stock_message"))
                                                                            }
                                                                        }
                                                                    }
                                                                    else {
                                                                        toast.error("OOps! You need to login first to access the cart!")
                                                                    }

                                                                }} disabled={!related_product.is_unlimited_stock && related_product.variants[0].stock <= 0}>{t("add_to_cart")}</button>
                                                            </>}
                                                        </div>

                                                        <div className='dropup share'>
                                                            <button type="button" className='w-100 h-100 ' data-bs-toggle="dropdown" aria-expanded="false"><BsShare /></button>

                                                            <ul className='dropdown-menu'>
                                                                <li className='dropDownLi'><WhatsappShareButton url={`${setting.setting && setting.setting.web_settings.website_url}product/${related_product.slug}`}><WhatsappIcon size={32} round={true} /> <span>WhatsApp</span></WhatsappShareButton></li>
                                                                <li className='dropDownLi'><TelegramShareButton url={`${setting.setting && setting.setting.web_settings.website_url}product/${related_product.slug}`}><TelegramIcon size={32} round={true} /> <span>Telegram</span></TelegramShareButton></li>
                                                                <li className='dropDownLi'><FacebookShareButton url={`${setting.setting && setting.setting.web_settings.website_url}product/${related_product.slug}`}><FacebookIcon size={32} round={true} /> <span>Facebook</span></FacebookShareButton></li>
                                                                <li>
                                                                    <button type='button' onClick={() => {
                                                                        navigator.clipboard.writeText(`${setting.setting && setting.setting.web_settings.website_url}product/${related_product.slug}`)
                                                                        toast.success("Copied Succesfully!!")
                                                                    }} className="react-share__ShareButton"> <BiLink size={30} /> <span>{("TapToCopy")}</span></button>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        ))}
                                    </Slider>
                                </div>

                            }

                        </div>
                    </div>
                    <QuickViewModal selectedProduct={selectedProduct} setselectedProduct={setselectedProduct} />
                </div >

            </div >
        </>

    )
}

export default ProductDetails
