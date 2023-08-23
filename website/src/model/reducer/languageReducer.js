import { ActionTypes } from "../action-type";


const initialState = {
    status : "loading", //fulfill
    current_language : null,
    available_languages:null
}

export const languageReducer = (state = initialState, { type, payload }) => {
    switch (type) {
        case ActionTypes.SET_LANGUAGE:
            return {
                ...state,
                status : "fulfill",
                current_language: payload,
            }
        case ActionTypes.SET_LANGUAGE_LIST:
            return {
                ...state,
                status : "fulfill",
                available_languages: payload,
            }
    
        default:
            return state;
    }
}