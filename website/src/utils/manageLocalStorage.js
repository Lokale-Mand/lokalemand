export const getLocation = () => {
    if (localStorage.getItem('location') === null) {
        return null;
    }
    return JSON.parse(localStorage.getItem('location'));
}


export const setLocation = (location) => {
    localStorage.setItem('location', JSON.stringify(location))
}

export const setToken = (token) => {
    localStorage.setItem('token', token);
}

export const getToken = () => {
    return localStorage.getItem('token');
}

export const setSelectedProductId = (product_id) => {
    localStorage.setItem('selected-product-id',product_id)
}

export const getSelectedProductId = () => {
    return localStorage.getItem('selected-product-id')
}

export const removeSelectedProductId = () =>{
    localStorage.removeItem('selected-product-id')
}
export const setlocalstorageOTP = (OTP) => {
    localStorage.setItem('OTP',OTP)
}
export const gelocalstoragetOTP = () => {
    return localStorage.getItem('OTP')
}

export const removelocalstorageOTP = () => {
    localStorage.removeItem('OTP')
}