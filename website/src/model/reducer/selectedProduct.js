import { ActionTypes } from "../action-type";


const initialState = {
    status:'loading', //fulfill
    selectedProduct_id:null
}

export const selectedProductReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_SELECTED_PRODUCT:
            return{
                ...state,
                status:"fulfill",
                selectedProduct_id:payload,
            }
        case ActionTypes.CLEAR_SELECTED_PRODUCT:
            return{
                ...state,
                status:"loading",
                selectedProduct_id:null,
            }
        default:
            return state;
    }
}