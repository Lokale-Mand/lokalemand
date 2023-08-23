import { ActionTypes } from "../action-type";


const initialState = {
    status:'loading', //fulfill
    cart:null,
    checkout:null,
    promo_code:null,
}

export const cartReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_CART:
            return{
                ...state,
                status:"fulfill",
                cart:payload,
            }
        case ActionTypes.SET_CART_CHECKOUT:
            return {
                ...state,
                status:"fulfill",
                checkout:payload,
            }
        case ActionTypes.SET_CART_PROMO:
            return {
                ...state,
                status:"fulfill",
                promo_code:payload,
            }
        default:
            return state;
    }
}