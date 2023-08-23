<template>
    <div>
        <div class="page-heading">
            <div class="page-title">
            <div class="row">
                <div class="col-12 col-md-6 order-md-1 order-last">
                    <h3>Payment Gateways & Methods Settings</h3>
                </div>
                <div class="col-12 col-md-6 order-md-2 order-first">
                    <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><router-link to="/dashboard">Dashboard</router-link></li>
                            <li class="breadcrumb-item active" aria-current="page">Payment Gateways & Methods Settings</li>
                        </ol>
                    </nav>
                </div>
            </div>
        </div>
            <section class="section">
                <form id="payment_method_settings_form" method="post" enctype="multipart/form-data" @submit.prevent="saveRecord">
                    <div class="row">
                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">COD Payments</h4>
                                </div>
                                <div class="card-body">
                                    <input type="hidden" id="payment_method_settings" v-model="payment_method.payment_method_settings" name="payment_method_settings" required="" value="1" aria-required="true">
                                    <div class="">
                                        <div class="form-group">
                                            <label for="cod_payment_method">COD Payments <small>[ Enable / Disable ] </small></label><br>
                                            <div class='form-check form-switch'>
                                                <input class='form-check-input' id="cod_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.cod_payment_method" :checked="payment_method.cod_payment_method">
                                            </div>
                                        </div>
                                        <div v-if="payment_method.cod_payment_method == 1" class="form-group">
                                            <label for="cod_mode">COD Mode</label><br>
                                            <p><small><b>Global :</b> Will be considered for all the products.</small></p>
                                            <p><small><b>Product wise :</b> Product wise COD wil be considered.</small></p>
                                            <select name="cod_mode" id="cod_mode" class="form-control form-select" v-model="payment_method.cod_mode">
                                                <option value="global" selected="">Global</option>
                                                <option value="product">Product wise</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">Paypal Payments</h4>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="paypal_payment_method">Paypal Payments <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="paypal_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.paypal_payment_method" :checked="payment_method.paypal_payment_method">
                                        </div>
                                    </div>
                                    <div v-if="payment_method.paypal_payment_method == 1" class="form-group">
                                        <label for="paypal_mode">Payment Mode <small>[ sandbox / live ]</small></label>
                                        <select name="paypal_mode" id="paypal_mode" required v-model="payment_method.paypal_mode" class="form-control form-select">
                                            <option value="">Select Mode </option>
                                            <option value="sandbox" selected="">Sandbox ( Testing )</option>
                                            <option value="production">Production ( Live )</option>
                                        </select>
                                    </div >
                                    <div v-if="payment_method.paypal_payment_method == 1" class="form-group">
                                        <label for="paypal_currency_code">Currency Code <small>[ PayPal supported ]</small> <a href="https://developer.paypal.com/docs/api/reference/currency-codes/" target="_BLANK"><i class="fa fa-link"></i></a></label>
                                        <select name="paypal_currency_code" id="paypal_currency_code" required v-model="payment_method.paypal_currency_code" class="form-control form-select">
                                            <option value="">Select Currency Code </option>
                                            <option value="INR">Indian rupee </option>
                                            <option value="AUD">Australian dollar </option>
                                            <option value="BRL">Brazilian real </option>
                                            <option value="CAD">Canadian dollar </option>
                                            <option value="CNY">Chinese Renmenbi </option>
                                            <option value="CZK">Czech koruna </option>
                                            <option value="DKK">Danish krone </option>
                                            <option value="EUR">Euro </option>
                                            <option value="HKD">Hong Kong dollar </option>
                                            <option value="HUF">Hungarian forint </option>
                                            <option value="ILS">Israeli new shekel </option>
                                            <option value="JPY">Japanese yen </option>
                                            <option value="MYR">Malaysian ringgit </option>
                                            <option value="MXN">Mexican peso </option>
                                            <option value="TWD">New Taiwan dollar </option>
                                            <option value="NZD">New Zealand dollar </option>
                                            <option value="NOK">Norwegian krone </option>
                                            <option value="PHP">Philippine peso </option>
                                            <option value="PLN">Polish złoty </option>
                                            <option value="GBP">Pound sterling </option>
                                            <option value="RUB">Russian ruble </option>
                                            <option value="SGD">Singapore dollar </option>
                                            <option value="SEK">Swedish krona </option>
                                            <option value="CHF">Swiss franc </option>
                                            <option value="THB">Thai baht </option>
                                            <option value="USD" selected="">United States dollar </option>
                                        </select>
                                    </div>
                                    <div v-if="payment_method.paypal_payment_method == 1" class="form-group">
                                        <label for="paypal_business_email">Paypal Business Email</label>
                                        <input type="text" class="form-control" name="paypal_business_email" id="paypal_business_email" v-model="payment_method.paypal_business_email" placeholder="Paypal Business Email">
                                    </div>
                                    <div v-if="payment_method.paypal_payment_method == 1" class="form-group">
                                        <label for="paypal_notification_url">Notification URL <small>(Set this as IPN notification URL in you PayPal account)</small></label>
                                        <input type="text" class="form-control" name="paypal_notification_url" id="paypal_notification_url" v-model="payment_method.paypal_notification_url"  placeholder="Paypal IPN notification URL" disabled="">
                                    </div>
                                </div>
                            </div>
                        </div>


<!--                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">PayUMoney Payments</h4>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="payumoney_payment_method">PayUMoney Payments <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="payumoney_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.payumoney_payment_method" :checked="payment_method.payumoney_payment_method">
                                        </div>
                                    </div>
                                    <div v-if="payment_method.payumoney_payment_method == 1" class="form-group">
                                        <label for="payumoney_mode">Payment Mode <small>[ sandbox / live ]</small></label>
                                        <select name="payumoney_mode" id="payumoney_mode" v-model="payment_method.payumoney_mode" class="form-control form-select">
                                            <option value="">Select Mode </option>
                                            <option value="sandbox" selected="">Sandbox ( Testing )</option>
                                            <option value="production">Production ( Live )</option>
                                        </select>
                                    </div>
                                    <div v-if="payment_method.payumoney_payment_method == 1" class="form-group">
                                        <label for="payumoney_merchant_key">Merchant key</label>
                                        <input type="text" class="form-control" name="payumoney_merchant_key" id="payumoney_merchant_key" v-model="payment_method.payumoney_merchant_key" placeholder="PayUMoney Merchant Key">
                                    </div>
                                    <div v-if="payment_method.payumoney_payment_method == 1" class="form-group">
                                        <label for="payumoney_merchant_id">Merchant ID</label>
                                        <input type="text" class="form-control" name="payumoney_merchant_id" id="payumoney_merchant_id" v-model="payment_method.payumoney_merchant_id" placeholder="PayUMoney Merchant ID">
                                    </div>
                                    <div v-if="payment_method.payumoney_payment_method == 1" class="form-group">
                                        <label for="payumoney_salt">Salt</label>
                                        <input type="text" class="form-control" name="payumoney_salt" id="payumoney_salt" v-model="payment_method.payumoney_salt" placeholder="PayUMoney Merchant ID">
                                    </div>
                                </div>
                            </div>
                        </div>-->
                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">Razorpay Payments</h4>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="razorpay_payment_method">Razorpay Payments <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="razorpay_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.razorpay_payment_method" :checked="payment_method.razorpay_payment_method">
                                        </div>
                                    </div>
                                    <div v-if="payment_method.razorpay_payment_method == 1" class="form-group">
                                        <label for="razorpay_key">Razorpay key ID</label>
                                        <input type="text" class="form-control" name="razorpay_key" id="razorpay_key" v-model="payment_method.razorpay_key" placeholder="Razor Key ID">
                                    </div>
                                    <div v-if="payment_method.razorpay_payment_method == 1" class="form-group">
                                        <label for="razorpay_secret_key">Secret Key</label>
                                        <input type="text" class="form-control" name="razorpay_secret_key" id="razorpay_secret_key" v-model="payment_method.razorpay_secret_key" placeholder="Razorpay Secret Key ">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">Paystack Payments</h4>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="paystack_payment_method">Paystack Payments <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="paystack_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.paystack_payment_method" :checked="payment_method.paystack_payment_method">
                                        </div>
                                    </div>
                                    <div v-if="payment_method.paystack_payment_method == 1" class="form-group">
                                        <label for="paystack_public_key">Paystack Public key</label>
                                        <input type="text" class="form-control" name="paystack_public_key" id="paystack_public_key" v-model="payment_method.paystack_public_key" placeholder="Paystack Public key">
                                    </div>
                                    <div v-if="payment_method.paystack_payment_method == 1" class="form-group">
                                        <label for="paystack_secret_key">Paystack Secret Key</label>
                                        <input type="text" class="form-control" name="paystack_secret_key" id="paystack_secret_key" v-model="payment_method.paystack_secret_key" placeholder="Paystack Secret Key ">
                                    </div>
                                    <div v-if="payment_method.paystack_payment_method == 1" class="form-group">
                                        <label for="paystack_currency_code">Currency Code <small>[ Paystack supported ]</small> <a href="https://support.paystack.com/hc/en-us/articles/360009973779-What-currency-is-available-to-my-business-" target="_BLANK"><i class="fa fa-link"></i></a></label>
                                        <select name="paystack_currency_code" id="paystack_currency_code" required v-model="payment_method.paystack_currency_code" class="form-control form-select">
                                            <option value="0">Select Currency Code </option>
                                            <option value="GHS">Ghana - GHS</option>
                                            <option value="NGN">Nigeria - NGN</option>
                                            <option value="USD">Nigeria - USD</option>
                                            <option value="ZAR">South Africa - ZAR</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
<!--                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">Flutterwave Payments</h4>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="flutterwave_payment_method">Flutterwave Payments <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="flutterwave_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.flutterwave_payment_method" :checked="payment_method.flutterwave_payment_method">
                                        </div>
                                    </div>
                                    <div v-if="payment_method.flutterwave_payment_method == 1" class="form-group">
                                        <label for="flutterwave_public_key">Flutterwave Public key</label>
                                        <input type="text" class="form-control" name="flutterwave_public_key" id="flutterwave_public_key" v-model="payment_method.flutterwave_public_key" placeholder="Flutterwave Public key">
                                    </div>
                                    <div v-if="payment_method.flutterwave_payment_method == 1" class="form-group">
                                        <label for="flutterwave_secret_key">Flutterwave Secret Key</label>
                                        <input type="text" class="form-control" name="flutterwave_secret_key" id="flutterwave_secret_key" v-model="payment_method.flutterwave_secret_key" placeholder="Flutterwave Secret Key ">
                                    </div>
                                    <div v-if="payment_method.flutterwave_payment_method == 1" class="form-group">
                                        <label for="flutterwave_encryption_key">Flutterwave Encryption key</label>
                                        <input type="text" class="form-control" name="flutterwave_encryption_key" id="flutterwave_encryption_key" v-model="payment_method.flutterwave_encryption_key" placeholder="Flutterwave Encryption key">
                                    </div>
                                    <div v-if="payment_method.flutterwave_payment_method == 1" class="form-group">
                                        <label for="flutterwave_currency_code">Currency Code <small>[ Flutterwave supported ]</small> </label>
                                        <select name="flutterwave_currency_code" id="flutterwave_currency_code" v-model="payment_method.flutterwave_currency_code" class="form-control form-select">
                                            <option value="">Select Currency Code</option>
                                            <option value="NGN">Nigerian Naira</option>
                                            <option value="USD">United States dollar</option>
                                            <option value="TZS">Tanzanian Shilling</option>
                                            <option value="SLL">Sierra Leonean Leone</option>
                                            <option value="MUR">Mauritian Rupee</option>
                                            <option value="MWK">Malawian Kwacha </option>
                                            <option value="GBP">UK Bank Accounts</option>
                                            <option value="GHS">Ghanaian Cedi</option>
                                            <option value="RWF">Rwandan franc</option>
                                            <option value="UGX">Ugandan Shilling</option>
                                            <option value="ZMW">Zambian Kwacha</option>
                                            <option value="KES" selected="">Mpesa</option>
                                            <option value="ZAR">South African Rand</option>
                                            <option value="XAF">Central African CFA franc</option>
                                            <option value="XOF">West African CFA franc</option>
                                            <option value="AUD">Australian Dollar</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>-->
<!--                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">Midtrans Payments</h4>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="midtrans_payment_method">Midtrans Payments <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="midtrans_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.midtrans_payment_method" :checked="payment_method.midtrans_payment_method">
                                        </div>
                                    </div>
                                    <div v-if="payment_method.midtrans_payment_method == 1" class="form-group">
                                        <label for="is_production">Payment Mode <small>[ sandbox / live ]</small></label>
                                        <select name="is_production" id="is_production" v-model="payment_method.is_production" class="form-control form-select">
                                            <option value="">Select Mode </option>
                                            <option value="1">Production ( Live )</option>
                                            <option value="0">Sandbox ( Testing )</option>
                                        </select>
                                    </div>
                                    <div v-if="payment_method.midtrans_payment_method == 1" class="form-group">
                                        <label for="midtrans_merchant_id">Midtrans Merchant ID</label>
                                        <input type="text" class="form-control" name="midtrans_merchant_id" id="midtrans_merchant_id" v-model="payment_method.midtrans_merchant_id" placeholder="Midtrans Merchant ID">
                                    </div>
                                    <div v-if="payment_method.midtrans_payment_method == 1" class="form-group">
                                        <label for="midtrans_client_key">Midtrans Client Key</label>
                                        <input type="text" class="form-control" name="midtrans_client_key" id="midtrans_client_key" v-model="payment_method.midtrans_client_key" placeholder="Midtrans Clients Key ">
                                    </div>
                                    <div v-if="payment_method.midtrans_payment_method == 1" class="form-group">
                                        <label for="midtrans_server_key">Midtrans Server Key</label>
                                        <input type="text" class="form-control" name="midtrans_server_key" id="midtrans_server_key" v-model="payment_method.midtrans_server_key" placeholder="Midtrans Server key">
                                    </div>
                                    <div v-if="payment_method.midtrans_payment_method == 1" class="form-group">
                                        <label for="paypal_notification_url">Notification URL <small>(Set this as Webhook URL in your Midtrans account)</small></label>
                                        <input type="text" class="form-control" name="midtrans_notification_url" value="http://localhost/client/ecart/ecart_php/midtrans/notification-handler.php" placeholder="Midtrans Webhook URL" disabled="">
                                    </div>
                                    <div v-if="payment_method.midtrans_payment_method == 1" class="form-group">
                                        <label for="paypal_notification_url">Payment Return URL <small>(Set this as Finish URL in your Midtrans account)</small></label>
                                        <input type="text" class="form-control" name="midtrans_return_url" value="http://localhost/client/ecart/ecart_php/midtrans/payment-process.php" placeholder="Midtrans return URL" disabled="">
                                    </div>
                                </div>
                            </div>
                        </div>-->
                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">Stripe Payments</h4>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="stripe_payment_method">Stripe Payments <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="stripe_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.stripe_payment_method" :checked="payment_method.stripe_payment_method">
                                        </div>
                                    </div>
                                    <div v-if="payment_method.stripe_payment_method == 1" class="form-group">
                                        <label for="stripe_publishable_key">Stripe Publishable Key</label>
                                        <input type="text" class="form-control" name="stripe_publishable_key" id="stripe_publishable_key" v-model="payment_method.stripe_publishable_key" placeholder="Stripe Publishable Key">
                                    </div>
                                    <div v-if="payment_method.stripe_payment_method == 1" class="form-group">
                                        <label for="stripe_secret_key">Stripe Secret Key</label>
                                        <input type="text" class="form-control" name="stripe_secret_key" id="stripe_secret_key" v-model="payment_method.stripe_secret_key" placeholder="Stripe Secret Key ">
                                    </div>
                                    <div v-if="payment_method.stripe_payment_method == 1" class="form-group">
                                        <label for="stripe_webhook_secret_key">Stripe Webhook Secret Key</label>
                                        <input type="text" class="form-control" name="stripe_webhook_secret_key" id="stripe_webhook_secret_key" v-model="payment_method.stripe_webhook_secret_key" placeholder="Stripe Webhook Secret Key">
                                    </div>
                                    <div v-if="payment_method.stripe_payment_method == 1" class="form-group">
                                        <label for="stripe_webhook_url">Payment Endpoint URL <small>(Set this as Endpoint URL in your Stripe account)</small></label>
                                        <input type="text" class="form-control" name="stripe_webhook_url" id="stripe_webhook_url" v-model="payment_method.stripe_webhook_url" readonly="">
                                    </div>
                                    <div v-if="payment_method.stripe_payment_method == 1" class="form-group">
                                        <label for="stripe_currency_code">Currency Code <small>[ Stripe supported ]</small> <a href="https://stripe.com/docs/currencies" target="_BLANK"><i class="fa fa-link"></i></a></label>
                                        <select name="stripe_currency_code" id="stripe_currency_code" required v-model="payment_method.stripe_currency_code" class="form-control form-select">
                                            <option value="">Select Currency Code </option>
                                            <option value="INR"> Indian rupee </option>
                                            <option value="USD"> United States dollar </option>
                                            <option value="AED"> United Arab Emirates Dirham </option>
                                            <option value="AFN"> Afghan Afghani </option>
                                            <option value="ALL"> Albanian Lek </option>
                                            <option value="AMD"> Armenian Dram </option>
                                            <option value="ANG"> Netherlands Antillean Guilder </option>
                                            <option value="AOA"> Angolan Kwanza </option>
                                            <option value="ARS"> Argentine Peso</option>
                                            <option value="AUD"> Australian Dollar</option>
                                            <option value="AWG"> Aruban Florin</option>
                                            <option value="AZN"> Azerbaijani Manat </option>
                                            <option value="BAM"> Bosnia-Herzegovina Convertible Mark </option>
                                            <option value="BBD"> Bajan dollar </option>
                                            <option value="BDT"> Bangladeshi Taka</option>
                                            <option value="BGN"> Bulgarian Lev </option>
                                            <option value="BIF"> Burundian Franc</option>
                                            <option value="BMD"> Bermudan Dollar</option>
                                            <option value="BND"> Brunei Dollar </option>
                                            <option value="BOB"> Bolivian Boliviano </option>
                                            <option value="BRL"> Brazilian Real </option>
                                            <option value="BSD"> Bahamian Dollar </option>
                                            <option value="BWP"> Botswanan Pula </option>
                                            <option value="BZD"> Belize Dollar </option>
                                            <option value="CAD"> Canadian Dollar </option>
                                            <option value="CDF"> Congolese Franc </option>
                                            <option value="CHF"> Swiss Franc </option>
                                            <option value="CLP"> Chilean Peso </option>
                                            <option value="CNY"> Chinese Yuan </option>
                                            <option value="COP"> Colombian Peso </option>
                                            <option value="CRC"> Costa Rican Colón </option>
                                            <option value="CVE"> Cape Verdean Escudo </option>
                                            <option value="CZK"> Czech Koruna </option>
                                            <option value="DJF"> Djiboutian Franc </option>
                                            <option value="DKK"> Danish Krone </option>
                                            <option value="DOP"> Dominican Peso </option>
                                            <option value="DZD"> Algerian Dinar </option>
                                            <option value="EGP"> Egyptian Pound </option>
                                            <option value="ETB"> Ethiopian Birr </option>
                                            <option value="EUR"> Euro </option>
                                            <option value="FJD"> Fijian Dollar </option>
                                            <option value="FKP"> Falkland Island Pound </option>
                                            <option value="GBP"> Pound sterling </option>
                                            <option value="GEL"> Georgian Lari </option>
                                            <option value="GIP"> Gibraltar Pound </option>
                                            <option value="GMD"> Gambian dalasi </option>
                                            <option value="GNF"> Guinean Franc </option>
                                            <option value="GTQ"> Guatemalan Quetzal </option>
                                            <option value="GYD"> Guyanaese Dollar </option>
                                            <option value="HKD"> Hong Kong Dollar </option>
                                            <option value="HNL"> Honduran Lempira </option>
                                            <option value="HRK"> Croatian Kuna </option>
                                            <option value="HTG"> Haitian Gourde </option>
                                            <option value="HUF"> Hungarian Forint </option>
                                            <option value="IDR"> Indonesian Rupiah </option>
                                            <option value="ILS"> Israeli New Shekel </option>
                                            <option value="ISK"> Icelandic Króna </option>
                                            <option value="JMD"> Jamaican Dollar </option>
                                            <option value="JPY"> Japanese Yen </option>
                                            <option value="KES"> Kenyan Shilling </option>
                                            <option value="KGS"> Kyrgystani Som </option>
                                            <option value="KHR"> Cambodian riel </option>
                                            <option value="KMF"> Comorian franc </option>
                                            <option value="KRW"> South Korean won </option>
                                            <option value="KYD"> Cayman Islands Dollar </option>
                                            <option value="KZT"> Kazakhstani Tenge </option>
                                            <option value="LAK"> Laotian Kip </option>
                                            <option value="LBP"> Lebanese pound </option>
                                            <option value="LKR"> Sri Lankan Rupee </option>
                                            <option value="LRD"> Liberian Dollar </option>
                                            <option value="LSL"> Lesotho loti </option>
                                            <option value="MAD"> Moroccan Dirham </option>
                                            <option value="MDL"> Moldovan Leu </option>
                                            <option value="MGA"> Malagasy Ariary </option>
                                            <option value="MKD"> Macedonian Denar </option>
                                            <option value="MMK"> Myanmar Kyat </option>
                                            <option value="MNT"> Mongolian Tugrik </option>
                                            <option value="MOP"> Macanese Pataca </option>
                                            <option value="MRO"> Mauritanian Ouguiya </option>
                                            <option value="MUR"> Mauritian Rupee</option>
                                            <option value="MVR"> Maldivian Rufiyaa </option>
                                            <option value="MWK"> Malawian Kwacha </option>
                                            <option value="MXN"> Mexican Peso </option>
                                            <option value="MYR"> Malaysian Ringgit </option>
                                            <option value="MZN"> Mozambican metical </option>
                                            <option value="NAD"> Namibian dollar </option>
                                            <option value="NGN"> Nigerian Naira </option>
                                            <option value="NIO"> Nicaraguan Córdoba </option>
                                            <option value="NOK"> Norwegian Krone </option>
                                            <option value="NPR"> Nepalese Rupee </option>
                                            <option value="NZD"> New Zealand Dollar </option>
                                            <option value="PAB"> Panamanian Balboa </option>
                                            <option value="PEN"> Sol </option>
                                            <option value="PGK"> Papua New Guinean Kina </option>
                                            <option value="PHP"> Philippine peso </option>
                                            <option value="PKR"> Pakistani Rupee </option>
                                            <option value="PLN"> Poland złoty </option>
                                            <option value="PYG"> Paraguayan Guarani </option>
                                            <option value="QAR"> Qatari Rial </option>
                                            <option value="RON"> Romanian Leu </option>
                                            <option value="RSD"> Serbian Dinar </option>
                                            <option value="RUB"> Russian Ruble </option>
                                            <option value="RWF"> Rwandan franc </option>
                                            <option value="SAR"> Saudi Riyal </option>
                                            <option value="SBD"> Solomon Islands Dollar </option>
                                            <option value="SCR"> Seychellois Rupee </option>
                                            <option value="SEK"> Swedish Krona </option>
                                            <option value="SGD"> Singapore Dollar </option>
                                            <option value="SHP"> Saint Helenian Pound </option>
                                            <option value="SLL"> Sierra Leonean Leone </option>
                                            <option value="SOS"> Somali Shilling </option>
                                            <option value="SRD"> Surinamese Dollar </option>
                                            <option value="STD"> Sao Tome Dobra </option>
                                            <option value="SZL"> Swazi Lilangeni </option>
                                            <option value="THB"> Thai Baht </option>
                                            <option value="TJS"> Tajikistani Somoni </option>
                                            <option value="TOP"> Tongan Paʻanga </option>
                                            <option value="TRY"> Turkish lira </option>
                                            <option value="TTD"> Trinidad &amp; Tobago Dollar </option>
                                            <option value="TWD"> New Taiwan dollar </option>
                                            <option value="TZS"> Tanzanian Shilling </option>
                                            <option value="UAH"> Ukrainian hryvnia </option>
                                            <option value="UGX"> Ugandan Shilling </option>
                                            <option value="UYU"> Uruguayan Peso </option>
                                            <option value="UZS"> Uzbekistani Som </option>
                                            <option value="VND"> Vietnamese dong </option>
                                            <option value="VUV"> Vanuatu Vatu </option>
                                            <option value="WST"> Samoa Tala</option>
                                            <option value="XAF"> Central African CFA franc </option>
                                            <option value="XCD"> East Caribbean Dollar </option>
                                            <option value="XOF"> West African CFA franc </option>
                                            <option value="XPF"> CFP Franc </option>
                                            <option value="YER"> Yemeni Rial </option>
                                            <option value="ZAR"> South African Rand </option>
                                            <option value="ZMW"> Zambian Kwacha </option>
                                        </select>
                                    </div>
                                    <div v-if="payment_method.stripe_payment_method == 1" class="form-group">
                                        <label for="stripe_mode"> Mode </label>
                                        <select name="stripe_mode" id="stripe_mode" class="form-control form-select" :required="payment_method.stripe_payment_method == 1" v-model="payment_method.stripe_mode">
                                            <option value="">Select Mode </option>
                                            <option value="sandbox">Sandbox ( Testing )</option>
                                            <option value="production">Production ( Live )</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">Paytm Payments</h4>
                                </div>
                                <div class="card-body">

                                    <div class="form-group">
                                        <label for="paytm_payment_method">Paytm Payments <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="paytm_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.paytm_payment_method" :checked="payment_method.paytm_payment_method">
                                        </div>
                                    </div>

                                    <div v-if="payment_method.paytm_payment_method == 1" class="form-group">
                                        <label for="paytm_mode">Paytm Payment Mode <small>[ sandbox / live ]</small></label>
                                        <select name="paytm_mode" id="paytm_mode" :required="payment_method.paytm_payment_method == 1" v-model="payment_method.paytm_mode" class="form-control form-select">
                                            <option value="">Select Paytm Payment Mode</option>
                                            <option value="sandbox">Sandbox ( Testing )</option>
                                            <option value="production">Production ( Live )</option>
                                        </select>
                                    </div>

                                    <div v-if="payment_method.paytm_payment_method == 1" class="form-group">
                                        <label for="paytm_merchant_key">Merchant key</label>
                                        <input type="text" class="form-control" name="paytm_merchant_key" id="paytm_merchant_key" v-model="payment_method.paytm_merchant_key" placeholder="Paytm Merchant Key">
                                    </div>

                                    <div v-if="payment_method.paytm_payment_method == 1" class="form-group">
                                        <label for="paytm_merchant_id">Merchant ID</label>
                                        <input type="text" class="form-control" name="paytm_merchant_id" id="paytm_merchant_id" v-model="payment_method.paytm_merchant_id" placeholder="Paytm Merchant ID">
                                    </div>

                                </div>
                            </div>
                        </div>
<!--                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">SSLCommerz Payments</h4>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="ssl_commerce_payment_method">SSLCommerz Payments <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="ssl_commerce_payment_method" type='checkbox' true-value="1" false-value="0" v-model="payment_method.ssl_commerce_payment_method" :checked="payment_method.ssl_commerce_payment_method">
                                        </div>
                                    </div>
                                    <div v-if="payment_method.ssl_commerce_payment_method == 1" class="form-group">
                                        <label for="ssl_commerece_mode">SSL Commerz Payment Mode <small>[ sandbox / live ]</small></label>
                                        <select name="ssl_commerece_mode" id="ssl_commerece_mode" v-model="payment_method.ssl_commerece_mode" class="form-control form-select">
                                            <option value="">Select SSL Commerz Payment Mode</option>
                                            <option value="sandbox">Sandbox ( Testing )</option>
                                            <option value="production">Production ( Live )</option>
                                        </select>
                                    </div>
                                    <div v-if="payment_method.ssl_commerce_payment_method == 1" class="form-group">
                                        <label for="ssl_commerece_store_id">Store ID</label>
                                        <input type="text" class="form-control" name="ssl_commerece_store_id" id="ssl_commerece_store_id" v-model="payment_method.ssl_commerece_store_id" placeholder="SSL Commerece Store ID">
                                    </div>
                                    <div v-if="payment_method.ssl_commerce_payment_method == 1" class="form-group">
                                        <label for="ssl_commerece_secret_key">Store Password (API/Secret Key)</label>
                                        <input type="text" class="form-control" name="ssl_commerece_secret_key" id="ssl_commerece_secret_key" v-model="payment_method.ssl_commerece_secret_key" placeholder="SSL Commerece Secret Key">
                                    </div>
                                </div>
                            </div>
                        </div>-->
<!--                        <div class="col-6 mb-4">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h4 class="card-title">Direct Bank Transfer</h4>
                                </div>
                                <div class="card-body">
                                    <div class="form-group">
                                        <label for="direct_bank_transfer">Direct Bank Transfer <small>[ Enable / Disable ] </small></label><br>
                                        <div class='form-check form-switch'>
                                            <input class='form-check-input' id="direct_bank_transfer" type='checkbox' true-value="1" false-value="0" v-model="payment_method.direct_bank_transfer" :checked="payment_method.direct_bank_transfer">
                                        </div>
                                    </div>
                                    <div v-if="payment_method.direct_bank_transfer == 1" class="form-group">
                                        <label for="account_name">Account Name</label>
                                        <input type="text" class="form-control" name="account_name" id="account_name" v-model="payment_method.account_name" placeholder="Account Name">
                                    </div>
                                    <div v-if="payment_method.direct_bank_transfer == 1" class="form-group">
                                        <label for="account_number">Account Number</label>
                                        <input type="text" class="form-control" name="account_number" id="account_number" v-model="payment_method.account_number" placeholder="Account Number">
                                    </div>
                                    <div v-if="payment_method.direct_bank_transfer == 1" class="form-group">
                                        <label for="bank_name">Bank Name</label>
                                        <input type="text" class="form-control" name="bank_name" id="bank_name" v-model="payment_method.bank_name" placeholder="Bank Name">
                                    </div>
                                    <div v-if="payment_method.direct_bank_transfer == 1" class="form-group">
                                        <label for="bank_code">Bank Code</label>
                                        <input type="text" class="form-control" name="bank_code" id="bank_code" v-model="payment_method.bank_code" placeholder="Bank Code">
                                    </div>
                                    <div v-if="payment_method.direct_bank_transfer == 1" class="form-group">
                                        <label for="notes">Extra Notes</label>
                                        <textarea rows="10" cols="10 " class="form-control" name="notes" id="notes" v-model="payment_method.notes"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>-->
                        <div class="form-group">
                            <b-button type="submit" id="btn_update" variant="primary" :disabled="isLoading" v-if="$can('manage_payment_methods')"> {{ __('update') }}
                                <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
                            </b-button>
                        </div>
<!--                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h4 class="card-title">Payment Gateways & Methods Settings</h4>
                                </div>
                                <div class="card-body">

                                </div>
                                <div class="card-footer">
                                    <div class="form-group">
                                        <input type="submit" id="btn_update" class="btn btn-primary" :value="__('update')" name="btn_update" v-if="$can('manage_payment_methods')">
                                    </div>
                                </div>
                            </div>
                        </div>-->
                    </div>
                </form>
            </section>
        </div>
    </div>
</template>

<script>
import axios from "axios";

export default {
    data: function () {
        return {
            isLoading:false,
            payment_method: {
                payment_method_settings: 0,
                cod_payment_method: 0,
                cod_mode:"",

                paypal_payment_method: 0,
                paypal_mode:"",
                paypal_currency_code:"",
                paypal_business_email:"",
                paypal_notification_url: this.$baseUrl+"/customer/ipn",

                payumoney_payment_method: 0,
                payumoney_mode:"",
                payumoney_merchant_key: "",
                payumoney_merchant_id: "",
                payumoney_salt: "",
                razorpay_payment_method: 0,
                razorpay_key: "",
                razorpay_secret_key: "",
                paystack_payment_method: 0,
                paystack_public_key: "",
                paystack_secret_key: "",
                paystack_currency_code:"",
                flutterwave_payment_method: 0,
                flutterwave_public_key: "",
                flutterwave_secret_key: "",
                flutterwave_encryption_key: "",
                flutterwave_currency_code:"",
                midtrans_payment_method: 0,
                is_production: 0,
                midtrans_merchant_id: "",
                midtrans_client_key: "",
                midtrans_server_key: "",

                stripe_payment_method: 0,
                stripe_publishable_key: "",
                stripe_secret_key: "",

                stripe_webhook_secret_key: "",
                stripe_webhook_url: this.$baseUrl+"/webhook/stripe",
                stripe_currency_code: "",
                stripe_mode: "",

                paytm_payment_method: 0,
                paytm_mode: "",
                paytm_merchant_key: "",
                paytm_merchant_id: "",
                ssl_commerce_payment_method: 0,
                ssl_commerece_mode: "",
                ssl_commerece_store_id: "",
                ssl_commerece_secret_key: "",
                direct_bank_transfer: 0,
                account_name: "",
                account_number: "",
                bank_name: "",
                bank_code: "",
                notes: ""
            },
            record: null
        }
    },
    created: function () {
        this.getPaymentMethods()
    },
    methods: {
        getPaymentMethods() {
            axios.get(this.$apiUrl + '/payment_methods').then((response) => {
                //let data = response.data;
                if(response.data.data) {
                    this.record = response.data.data;

                    this.payment_method.payment_method_settings = this.record.payment_method_settings ?? 0;
                    this.payment_method.cod_payment_method = this.record.cod_payment_method??0;
                    this.payment_method.cod_mode = this.record.cod_mode??"";
                    this.payment_method.paypal_payment_method = this.record.paypal_payment_method;
                    this.payment_method.paypal_mode = this.record.paypal_mode??"";
                    this.payment_method.paypal_currency_code = this.record.paypal_currency_code??"";
                    this.payment_method.paypal_business_email = this.record.paypal_business_email;
                    this.payment_method.paypal_notification_url = this.record.paypal_notification_url??"";

                    this.payment_method.payumoney_payment_method = this.record.payumoney_payment_method;
                    this.payment_method.payumoney_mode = this.record.payumoney_mode??"";
                    this.payment_method.payumoney_merchant_key = this.record.payumoney_merchant_key;
                    this.payment_method.payumoney_merchant_id = this.record.payumoney_merchant_id;
                    this.payment_method.payumoney_salt = this.record.payumoney_salt;
                    this.payment_method.razorpay_payment_method = this.record.razorpay_payment_method;
                    this.payment_method.razorpay_key = this.record.razorpay_key;
                    this.payment_method.razorpay_secret_key = this.record.razorpay_secret_key;
                    this.payment_method.paystack_payment_method = this.record.paystack_payment_method;
                    this.payment_method.paystack_public_key = this.record.paystack_public_key;
                    this.payment_method.paystack_secret_key = this.record.paystack_secret_key;
                    this.payment_method.paystack_currency_code = this.record.paystack_currency_code??"";

                    this.payment_method.flutterwave_payment_method = this.record.flutterwave_payment_method;
                    this.payment_method.flutterwave_public_key = this.record.flutterwave_public_key;
                    this.payment_method.flutterwave_secret_key = this.record.flutterwave_secret_key;
                    this.payment_method.flutterwave_encryption_key = this.record.flutterwave_encryption_key;
                    this.payment_method.flutterwave_currency_code = this.record.flutterwave_currency_code??"";
                    this.payment_method.midtrans_payment_method = this.record.midtrans_payment_method;
                    this.payment_method.is_production = this.record.is_production??"";
                    this.payment_method.midtrans_merchant_id = this.record.midtrans_merchant_id;
                    this.payment_method.midtrans_client_key = this.record.midtrans_client_key;
                    this.payment_method.midtrans_server_key = this.record.midtrans_server_key;
                    this.payment_method.stripe_payment_method = this.record.stripe_payment_method;
                    this.payment_method.stripe_publishable_key = this.record.stripe_publishable_key;
                    this.payment_method.stripe_secret_key = this.record.stripe_secret_key;
                    this.payment_method.stripe_webhook_secret_key = this.record.stripe_webhook_secret_key;
                    this.payment_method.stripe_webhook_url = this.record.stripe_webhook_url ?? "";
                    this.payment_method.stripe_currency_code = this.record.stripe_currency_code;
                    this.payment_method.stripe_mode = this.record.stripe_mode;


                    this.payment_method.paytm_payment_method = this.record.paytm_payment_method;
                    this.payment_method.paytm_mode = this.record.paytm_mode ?? "";
                    this.payment_method.paytm_merchant_key = this.record.paytm_merchant_key;
                    this.payment_method.paytm_merchant_id = this.record.paytm_merchant_id;

                    this.payment_method.ssl_commerce_payment_method = this.record.ssl_commerce_payment_method;
                    this.payment_method.ssl_commerece_mode = this.record.ssl_commerece_mode??"";
                    this.payment_method.ssl_commerece_store_id = this.record.ssl_commerece_store_id;
                    this.payment_method.ssl_commerece_secret_key = this.record.ssl_commerece_secret_key;
                    this.payment_method.direct_bank_transfer = this.record.direct_bank_transfer;
                    this.payment_method.account_name = this.record.account_name;
                    this.payment_method.account_number = this.record.account_number;
                    this.payment_method.bank_name = this.record.bank_name;
                    this.payment_method.bank_code = this.record.bank_code;
                    this.payment_method.notes = this.record.notes;
                }
            });
        },
        saveRecord: function(){
            this.isLoading = true;
            let payment_methodObject = this.payment_method;
            let formData = new FormData();
            for (let key in payment_methodObject) {
                if(payment_methodObject[key] == false){
                    formData.append(key, 0);
                }else if(payment_methodObject[key] == true){
                    formData.append(key, 1);
                }else{
                    formData.append(key, payment_methodObject[key]);
                }
            }

            let url = this.$apiUrl + '/payment_methods/save';
            let vm = this;
            axios.post(url, formData).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    //this.showSuccess(data.message);
                    this.showMessage("success", data.message);
                    setTimeout(
                        function() {
                            vm.$swal.close();
                            vm.getPaymentMethods();
                            vm.$router.push({path:'/payment_methods'});
                            vm.isLoading = false;
                        }, 100);
                }else{
                    vm.showError(data.message);
                    vm.isLoading = false;
                }
            }).catch(error => {
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError(__('something_went_wrong'));
                }
                vm.isLoading = false;
            });
        }
    }
}
</script>
