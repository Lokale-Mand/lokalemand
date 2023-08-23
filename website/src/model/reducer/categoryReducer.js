import { ActionTypes } from "../action-type";


const initialState = {
    status : "loading", //fulfill
    category : null,
}

export const categoryReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_CATEGORY:
            return {
                status : "fulfill",
                category: payload,
            }
    
        default:
            return state;
    }
}