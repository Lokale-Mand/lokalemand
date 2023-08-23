import { ActionTypes } from "../action-type";



const initialState = {
    status:'loading', //fulfill
    sizes:null,
}

export const productSizesReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_PRODUCT_SIZES:
            return{
                ...state,
                status:"fulfill",
                sizes:payload,
            }
        
        default:
            return state;
    }
}