import { ActionTypes } from "../action-type";


const initialState = {
    search:null,
    section_id:null,
    brand_ids :[],
    category_id:null,
    grid_view:true,
    price_filter:null,   
    sort_filter:'new',  //new,old,high,low,discount,popular
    section_products:null,
}

export const productFilterReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_FILTER_SEARCH:
            return{
                ...state,
                search:payload,
            }
        case ActionTypes.SET_FILTER_SECTION:
            return{
                ...state,
                section_id:payload,
            }
        case ActionTypes.SET_FILTER_BRANDS:
            return {
                ...state,
                brand_ids:payload,
            }

        case ActionTypes.SET_FILTER_CATEGORY:
            return {
                ...state,
                category_id:payload,
            }
        case ActionTypes.SET_FILTER_VIEW:
            return {
                ...state,
                grid_view:payload,
            }
        case ActionTypes.SET_FILTER_MIN_MAX_PRICE:
            return {
                ...state,
                price_filter:payload,
            }
        case ActionTypes.SET_FILTER_SORT:
            return {
                ...state,
                sort_filter:payload,
            }
        case ActionTypes.SET_FILTER_PRODUCTS:
            return {
                ...state,
                section_products:payload,
            }
        default:
            return state;
    }
}