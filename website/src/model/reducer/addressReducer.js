import { ActionTypes } from "../action-type";


const initialState = {
    status:'loading', //fulfill
    address:null,
    selected_address:null
}

export const addressReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_ADDRESS:
            return{
                ...state,
                status:"fulfill",
                address:payload,
            }

        case ActionTypes.SET_SELECTED_ADDRESS:
            return{
                ...state,
                status:"fulfill",
                selected_address:payload,
            }

        default:
            return state;
    }
}