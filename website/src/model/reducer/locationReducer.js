import { ActionTypes } from "../action-type";


const initialState = {
    status : "loading", //fulfill
    city : null,
}

export const locationReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_CITY:
            return {
                status : "fulfill",
                city: payload,
            }
    
        default:
            return state;
    }
}