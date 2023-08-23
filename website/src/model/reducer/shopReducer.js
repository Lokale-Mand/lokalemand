import { ActionTypes } from "../action-type";


const initialState = {
    status : "loading", //fulfill
    shop : null,
}

export const shopReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_SHOP:
            return {
                status : "fulfill",
                shop: payload,
            }
    
        default:
            return state;
    }
}