import { ActionTypes } from "../action-type";


const initialState = {
    status:'loading', //fulfill
    notification:null,
}

export const notificationReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_NOTIFICATION:
            return{
                ...state,
                status:"fulfill",
                notification:payload,
            }
    
        default:
            return state;
    }
}