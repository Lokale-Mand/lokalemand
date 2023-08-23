import { ActionTypes } from "../action-type";


const initialState = {
    status:'loading', //fulfill
    setting:null,
    payment_setting:null
}

export const settingReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_SETTING:
            return{
                ...state,
                status:"fulfill",
                setting:payload,
            }

        case ActionTypes.SET_PAYMENT_SETTING:
            return{
                ...state,
                status:"fulfill",
                payment_setting:payload,
            }

        default:
            return state;
    }
}