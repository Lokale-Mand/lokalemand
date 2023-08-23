const access_key_param = 'x-access-key';
const access_key = "903361";
const token_prefix = "Bearer "
const appUrl = process.env.REACT_APP_API_URL;
const appSubUrl = process.env.REACT_APP_API_SUBURL;


const api = {
    getAppUrl(){
        return appUrl.endsWith('/') ?
            appUrl.slice(0, -1) :
            appUrl;
    },
    login(num, Uid, countrycode) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);

        var formdata = new FormData();
        formdata.append("mobile", num);
        formdata.append("auth_uid", Uid);
        formdata.append("fcm_token", "murarisingh");
        formdata.append("country_code", countrycode);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/login", requestOptions)
    },
    logout(token) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);
        // myHeaders.append("Cookie", "egrocer_session=OqYqjWnvp7vS6R80R2Kv9UdF2uG8kB6wii1myWmu");

        var formdata = new FormData();
        formdata.append("fcm_token", "murarisingh");

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/logout", requestOptions)
    },
    deleteAccount(token, uid) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("auth_uid", uid);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/delete_account", requestOptions)
    },
    getSettings() {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };
        var params = {
            is_web_setting: 1
        }
        var url = new URL(appUrl + appSubUrl + "/settings");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };

        return fetch(url, requestOptions)
    },
    getCity( latitude, longitude) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        var params = {
            latitude: latitude,
            longitude: longitude,
        }
        var url = new URL(appUrl + appSubUrl + "/city");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };

        return fetch(url, requestOptions)

    },
    getShop(city_id, latitiude, longitude, token = "") {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);
        // myHeaders.append("Cookie", "egrocer_session=BTDzyPAhuCjTcpOo4I7qTgW9ZM5PzUtUey4rnmlC");

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };
        var params = { city_id: city_id, latitude: latitiude, longitude: longitude };
        var url = new URL(appUrl + appSubUrl + "/shop");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };
        return fetch(url, requestOptions)
    },
    getBrands() {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        // myHeaders.append("Cookie", "egrocer_session=e0DnVi9p5AhGSWDtiOqPIGqIX85hg2BhsnTK7ICf");

        // var formdata = new FormData();

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            // body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/brands", requestOptions)

    },
    getCategory(id = 0) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        // myHeaders.append("Cookie", "egrocer_session=t6OYQynGEbA5Yq8lDU3QJdkcoOFLTKaX1UcPTRCN");

        var formdata = new FormData();
        formdata.append('category_id', id)

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            // body: formdata,
            redirect: 'follow'
        };
        var params = { category_id: id };
        var url = new URL(appUrl + appSubUrl + "/categories");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };
        return fetch(url, requestOptions)
    },
    getSlider() {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        // myHeaders.append("Cookie", "egrocer_session=GvRG0oXt9MI5fZds6A8PqCjO4ki9YK1Y7HhsNYpZ");

        //var formdata = new FormData();

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            //body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/sliders", requestOptions)
    },
    getOffer() {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        // myHeaders.append("Cookie", "egrocer_session=VWx2trOpEJrXgOcGu1TF0SyN4lfQVRdieHDj5HND");

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/offers", requestOptions)
    },
    getSection(city_id, latitiude, longitude) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        var params = { city_id: city_id, latitude: latitiude, longitude: longitude };
        var url = new URL(appUrl + appSubUrl + "/sections");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };

        return fetch(url, requestOptions)
    },
    getUser(token) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);
        // myHeaders.append("Cookie", "egrocer_session=ZGyZlEheLKDTFHnAsVnSpethgG5vROAwF2PeSUBz");

        //var formdata = new FormData();

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            //body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/user_details", requestOptions)
    },
    edit_profile(uname, email, selectedFile = "", token) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);
        // myHeaders.append("Cookie", "egrocer_session=ZGyZlEheLKDTFHnAsVnSpethgG5vROAwF2PeSUBz");

        var formdata = new FormData();
        formdata.append("name", uname);
        formdata.append("email", email);
        if (selectedFile !== null) {
            formdata.append("profile", selectedFile);
        }

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/edit_profile", requestOptions)
    },
    getProductbyFilter(city_id, latitude, longitude, filters, token) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);
        var formdata = new FormData();
        formdata.append("city_id", city_id);
        formdata.append("latitude", latitude);
        formdata.append("longitude", longitude);

        if (filters !== undefined) {
            for (const filter in filters) {
                if (filter !== null || filter !== undefined && !filter.section_id)
                    formdata.append(filter, filters[filter])
            }
        }

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/products", requestOptions)
    },
    getProductbyId(city_id, latitude, longitude, id, token) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("id", id);
        formdata.append("city_id", city_id);
        formdata.append("latitude", latitude);
        formdata.append("longitude", longitude);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/product_by_id", requestOptions)

    },
    getCart(token, latitude, longitude, checkout = 0) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        var params = { latitude: latitude, longitude: longitude, is_checkout: checkout };
        var url = new URL(appUrl + appSubUrl + "/cart");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };
        return fetch(url, requestOptions)

    },
    removeCart(token) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("is_remove_all", 1);
        // formdata.append("is_remove_all", is_all_remove);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/cart/remove", requestOptions)
    },
    addToCart(token, product_id, product_variant_id, qty) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("product_id", product_id);
        formdata.append("product_variant_id", product_variant_id);
        formdata.append("qty", qty);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/cart/add", requestOptions)
    },
    removeFromCart(token, product_id, product_variant_id) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("product_id", product_id);
        formdata.append("product_variant_id", product_variant_id);
        formdata.append("is_remove_all", 0);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/cart/remove", requestOptions)
    },
    getFavorite(token, latitude, longitude) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        var params = { latitude: latitude, longitude: longitude };
        var url = new URL(appUrl + appSubUrl + "/favorites");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };
        return fetch(url, requestOptions)

    },
    addToFavotite(token, product_id) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("product_id", product_id);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/favorites/add", requestOptions)
    },
    removeFromFavorite(token, product_id) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("product_id", product_id);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/favorites/remove", requestOptions)
    },
    getAddress(token) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/address", requestOptions)
    },
    addAddress(token, name, mobile, type, address, landmark, area, pincode, city, state, country, alternate_mobile, latitiude, longitude, is_default) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("name", name);
        formdata.append("mobile", mobile);
        formdata.append("type", type);
        formdata.append("address", address);
        formdata.append("landmark", landmark);
        formdata.append("area", area);
        formdata.append("pincode", pincode);
        formdata.append("city", city);
        formdata.append("state", state);
        formdata.append("country", country);
        formdata.append("alternate_mobile", alternate_mobile ? alternate_mobile : mobile);
        formdata.append("latitude", latitiude);
        formdata.append("longitude", longitude);
        formdata.append("is_default", is_default ? 1 : 0);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/address/add", requestOptions)
    },
    deleteAddress(token, address_id) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("id", address_id);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/address/delete", requestOptions)

    },
    updateAddress(token, address_id, name, mobile, type, address, landmark, area, pincode, city, state, country, alternate_mobile, latitiude, longitude, is_default) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("id", address_id);
        formdata.append("name", name);
        formdata.append("mobile", mobile);
        formdata.append("type", type);
        formdata.append("address", address);
        formdata.append("landmark", landmark);
        formdata.append("area", area);
        formdata.append("pincode", pincode);
        formdata.append("city", city);
        formdata.append("state", state);
        formdata.append("country", country);
        formdata.append("alternate_mobile", alternate_mobile);
        formdata.append("latitude", latitiude);
        formdata.append("longitude", longitude);
        formdata.append("is_default", is_default ? 1 : 0);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/address/update", requestOptions)
    },
    fetchTimeSlot() {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/settings/time_slots", requestOptions)
    },
    placeOrder(token, product_variant_id, quantity, total, delivery_charge, final_total, payment_method, address_id, deliveryTime, status = 2) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var formdata = new FormData();
        formdata.append("product_variant_id", product_variant_id);
        formdata.append("quantity", quantity);
        formdata.append("total", total);
        formdata.append("delivery_charge", delivery_charge);
        formdata.append("final_total", final_total);
        formdata.append("payment_method", payment_method);
        formdata.append("address_id", address_id);
        formdata.append("delivery_time", deliveryTime);
        if (payment_method === "COD") {

            formdata.append("status", 2);
        }
        else {
            formdata.append("status", 1);
        }

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formdata,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/place_order", requestOptions)
    },
    getOrders(token, limit = 10, offset = 0) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        var params = { limit: limit, offset: offset };
        var url = new URL(appUrl + appSubUrl + "/orders");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };

        return fetch(url, requestOptions)
    },
    getPaymentSettings(token) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        return fetch(appUrl + appSubUrl + "/settings/payment_methods", requestOptions)
    },
    getTransactions(token, limit = 10, offset = 0) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        var params = { limit: limit, offset: offset };
        var url = new URL(appUrl + appSubUrl + "/get_user_transactions");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };

        return fetch(url, requestOptions)

    },
    getInvoices(token, order_id) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);
        var formData = new FormData();
        formData.append('order_id', order_id)

        var requestOptions = {
            method: 'POST',
            responseType: 'blob',
            headers: myHeaders,
            body: formData,
        };


        return fetch(appUrl + appSubUrl + "/invoice_download", requestOptions)
    },
    addTransaction(token, order_id, transaction_id, transaction_method) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append('Authorization', token_prefix + token);
        var formData = new FormData();
        formData.append('order_id', order_id);
        formData.append('transaction_id', transaction_id);
        formData.append('payment_method', transaction_method);
        formData.append('device_type', 'web');
        formData.append('app_version', '1.0');

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formData,
        };

        return fetch(appUrl + appSubUrl + "/add_transaction", requestOptions)

    },
    initiate_transaction(token, order_id, payment_method) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append('Authorization', token_prefix + token);
        var formData = new FormData();
        formData.append('order_id', order_id);
        if (payment_method.toLocaleLowerCase() === 'razorpay') {
            formData.append("payment_method", "Razorpay");
        }
        else if (payment_method.toLocaleLowerCase() === 'stripe') {
            formData.append("payment_method", "Stripe");
        }
        else if (payment_method.toLocaleLowerCase() === 'paypal') {
            formData.append("payment_method", "Paypal");
        }

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formData,
        };

        return fetch(appUrl + appSubUrl + "/initiate_transaction", requestOptions)
    },
    addRazorpayTransaction(token, order_id, transaction_id, razorpay_order_id, razorpay_payment_id, razorpay_signature) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append('Authorization', token_prefix + token);
        var formData = new FormData();
        formData.append('order_id', order_id);
        formData.append('transaction_id', transaction_id);
        // formData.append("razorpay_order_id", razorpay_order_id);
        // formData.append("razorpay_payment_id", razorpay_payment_id);
        // formData.append("razorpay_signature", razorpay_signature);
        formData.append('payment_method', 'Razorpay');
        formData.append('device_type', 'web');
        formData.append('app_version', '1.0');

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: formData,
        };

        return fetch(appUrl + appSubUrl + "/add_transaction", requestOptions)
    },
    getNotification(token, limit = 5, offset = (1 * 5 - 5)) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        var params = { limit: limit, offset: offset };
        var url = new URL(appUrl + appSubUrl + "/notifications");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };

        return fetch(url, requestOptions)
    },
    getFaq(limit, offset) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };

        var params = { limit: limit, offset: offset };
        var url = new URL(appUrl + appSubUrl + "/faqs");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };

        return fetch(url, requestOptions)
    },
    getPromo(token, amount=0) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token)

        var requestOptions ={
            method: 'GET',
            headers: myHeaders,
            redirect:'follow'
        };

        var params = {amount:amount};
        var url = new URL(appUrl + appSubUrl + "/promo_code")
        for(let k in params){
            url.searchParams.append(k, params[k])
        }

        return fetch(url, requestOptions)
    },
    setPromo(token, promo_code, amount = 0) {
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);
        myHeaders.append("Authorization", token_prefix + token);

        var requestOptions = {
            method: 'POST',
            headers: myHeaders,
            redirect: 'follow'
        };

        var params = {  promo_code:promo_code , total:amount};
        var url = new URL(appUrl + appSubUrl + "/promo_code/validate");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };
        return fetch(url, requestOptions)

    },
    getSystemLanguage( id , is_default){
        var myHeaders = new Headers();
        myHeaders.append(access_key_param, access_key);

        var requestOptions = {
            method: 'GET',
            headers: myHeaders,
            redirect: 'follow'
        };
        var params = {
            system_type: 3,
            id: id,
            is_default:is_default
        }
        var url = new URL(appUrl + appSubUrl + "/system_languages");
        for (let k in params) {
            url.searchParams.append(k, params[k])
        };

        return fetch(url, requestOptions)
    }

}
export default api;