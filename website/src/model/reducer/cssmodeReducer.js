import { ActionTypes } from "../action-type";


const initialState = {
    status : "loading", //fulfill
    cssmode : "light",
}

export const cssmodeReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_CSSMODE:
            return {
                status : "fulfill",
                cssmode: payload,
            }
    
        default:
            return state;
    }
}