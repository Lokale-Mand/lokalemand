import { ActionTypes } from "../action-type";


const initialState = {
    status:'loading', //fulfill
    favorite:null,
}

export const favotiteReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_FAVORITE:
            return{
                ...state,
                status:"fulfill",
                favorite:payload,
            }
    
        default:
            return state;
    }
}