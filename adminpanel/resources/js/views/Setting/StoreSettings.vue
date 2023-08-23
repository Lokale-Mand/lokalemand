<template>
    <div>
        <div class="page-heading">
            <div class="page-title">
                <div class="row">
                    <div class="col-12 col-md-6 order-md-1 order-last">
                        <h3>Store Settings</h3>
                    </div>
                    <div class="col-12 col-md-6 order-md-2 order-first">
                        <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <router-link to="/dashboard">{{ __('dashboard') }}</router-link>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Store Settings</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
            <section class="section">
                <form method="post" enctype="multipart/form-data" @submit.prevent="saveRecord">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Update System Settings</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <input type="hidden" id="system_configurations" name="system_configurations"
                                       v-model="store_settings.system_configurations" required="" aria-required="true">
                                <input type="hidden" id="system_timezone_gmt" name="system_timezone_gmt"
                                       v-model="store_settings.system_timezone_gmt" aria-required="true">
                                <input type="hidden" id="system_configurations_id" name="system_configurations_id"
                                       v-model="store_settings.system_configurations_id" aria-required="true">

                                <div class="form-group col-md-4">
                                    <label for="app_name">App Name:</label>
                                    <input type="text" class="form-control" required name="app_name" id="app_name"
                                           v-model="store_settings.app_name"
                                           placeholder="Name of the App - used in whole system"/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="support_number">Support Number:</label>
                                    <input type="number" class="form-control" required name="support_number"
                                           id="support_number" v-model="store_settings.support_number"
                                           placeholder="Customer support mobile number - used in whole system +91 9876543210"/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="support_email">Support Email:</label>
                                    <input type="text" class="form-control" required name="support_email"
                                           id="support_email" v-model="store_settings.support_email"
                                           placeholder="Customer support email - used in whole system"/>
                                </div>




                                <div class="list-group-item">
                                    <div class="row">
                                        <div class="form-group col-md-4">
                                            <label for="is_version_system_on">Version System Status</label><br>
                                            <div class="form-check form-switch">
                                                <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="is_version_system_on"
                                                       id="is_version_system_on" v-model="store_settings.is_version_system_on">
                                            </div>
                                        </div>

                                        <div class="form-group col-md-4" v-if="store_settings.is_version_system_on == 1">
                                            <label for="required_force_update">Required Force Update</label><br>
                                            <div class="form-check form-switch">
                                                <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="required_force_update"
                                                       id="required_force_update" v-model="store_settings.required_force_update">
                                            </div>
                                        </div>

                                        <div class="form-group col-md-4" v-if="store_settings.is_version_system_on == 1">
                                            <label for="current_version">Current Version Of App</label>
                                            <input type="text" class="form-control" required name="current_version"
                                                   id="current_version" v-model="store_settings.current_version"
                                                   placeholder='Current Version'/>
                                        </div>
                                    </div>
                                </div>

<!--                                <div class="form-group col-md-4" v-if="store_settings.is_version_system_on == 1">
                                    <label for="minimum_version_required">Minimum Version Required: </label>
                                    <input type="text" class="form-control" required name="minimum_version_required"
                                           id="minimum_version_required"
                                           v-model="store_settings.minimum_version_required"
                                           placeholder='Minimum Required Version'/>
                                </div>-->
                                <div class="list-group-item mb-3">
                                    <div class="row">
                                        <div class="form-group col-md-4">
                                            <label for="ios_is_version_system_on">IOS Version System Status</label><br>
                                            <div class="form-check form-switch">
                                                <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="ios_is_version_system_on"
                                                       id="ios_is_version_system_on" v-model="store_settings.ios_is_version_system_on">
                                            </div>
                                        </div>

                                        <div class="form-group col-md-4" v-if="store_settings.ios_is_version_system_on == 1">
                                            <label for="ios_required_force_update">IOS Required Force Update</label><br>
                                            <div class="form-check form-switch">
                                                <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="ios_required_force_update"
                                                       id="ios_required_force_update" v-model="store_settings.ios_required_force_update">
                                            </div>
                                        </div>

                                        <div class="form-group col-md-4" v-if="store_settings.ios_is_version_system_on == 1">
                                            <label for="ios_current_version">IOS Current Version Of App</label>
                                            <input type="text" class="form-control" required name="ios_current_version"
                                                   id="ios_current_version" v-model="store_settings.ios_current_version"
                                                   placeholder='IOS Current Version'/>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group col-md-8">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label for="logo">Logo</label>
                                            <input type='file' name='logo' id='logo' v-on:change="handleLogoUpload" ref="logo" accept="image/*" class="file-input"/>
                                            <div class="file-input-div" @click="$refs.logo.click()" @drop="dropFile" @dragover="$dragoverFile" @dragleave="$dragleaveFile">

                                                <!--                                        <label><i class="fa fa-cloud-upload fa-2x"></i></label>
                                                                                        <label>{{ __('drop_files_here_or_click_to_upload') }}</label>-->

                                                <template v-if="logo_name && logo_name !== ''">
                                                    <label>Selected file name:- {{ logo_name }}</label>
                                                </template>
                                                <template v-else>
                                                    <label><i class="fa fa-cloud-upload fa-2x"></i></label>
                                                    <label>{{ __('drop_files_here_or_click_to_upload') }}</label>
                                                </template>
                                            </div>
                                        </div>
                                        <div class="col-md-6" v-if="logo_url" >
                                            <img class="custom-row-image" :src="logo_url" title='Store Logo' alt='Store Logo'/>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="copyright_details">{{ __('copyright_details') }}</label>
                                    <i class="text-danger">*</i>

                                    <textarea name="copyright_details" id="copyright_details" v-model="store_settings.copyright_details" rows="4" cols="70" class="form-control"
                                              :placeholder="__('enter_copyright_details_here')"></textarea>

                                    <!--                                    <div class="form-floating mb-3">
                                                                        <textarea name="copyright_details" id="copyright_details" v-model="store_settings.copyright_details" rows="4" cols="70" class="form-control"
                                                                                  :placeholder="__('enter_copyright_details_here')"></textarea>
                                                                            <label for="copyright_details">{{ __('enter_copyright_details') }}</label>
                                                                        </div>-->

                                </div>



                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Store Address Settings</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label for="store_address">Address </label>
                                    <textarea class="form-control" required name="store_address" id="store_address"
                                              rows="2" v-model="store_settings.store_address"></textarea>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="map_latitude">Latitude </label>
                                    <input type="text" class="form-control" required name="map_latitude"
                                           id="map_latitude" v-model="store_settings.map_latitude"
                                           placeholder='Minimum Required Version'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="map_longitude">Longitude </label>
                                    <input type="text" class="form-control" required name="map_longitude"
                                           id="map_longitude" v-model="store_settings.map_longitude"
                                           placeholder='Minimum Required Version'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="currency">Store Currency (Symbol or Code - $ or USD):</label>
                                    <input type="text" class="form-control" required name="currency" id="currency"
                                           v-model="store_settings.currency"
                                           placeholder="Either Symbol or Code - For Example $ or USD"/>
                                </div>

                                <div class="form-group col-md-4">
                                    <label for="currency_code">Currency Code </label>
                                    <select class="form-control form-select" required name="currency_code" id="currency_code" v-model="store_settings.currency_code">
                                        <option value="">Select Country Currency Code</option>
                                        <option v-for="code in currency_codes" v-if="code.currencyCode !== '' " :value='code.currencyCode'>
                                            {{ code.currencyCode+' - '+code.countryName }}
                                        </option>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label for="currency_code">Decimal Point</label>
                                    <select class="form-control form-select" required name="decimal_point" id="decimal_point" v-model="store_settings.decimal_point">
                                        <option value="">Select Currency Decimal Point</option>
                                        <option value="0">0</option>
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="system_timezone" for="system_timezone">System Timezone</label>
                                    <select class="form-control form-select col-md-12" name="system_timezone"
                                            id="system_timezone" v-model="store_settings.system_timezone">
                                        <option v-for="timezone_option in timezone_options" :value="timezone_option[2]"
                                                :data-gmt="timezone_option[1]">
                                            {{ timezone_option[2] }} - GMT {{ timezone_option[1] }} -
                                            {{ timezone_option[0] }}
                                        </option>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="system_timezone" for="system_timezone">Default City</label>

                                    <multiselect v-model="city"
                                                 :options="cities"
                                                 @close="setCityId"
                                                 placeholder="Select & Search City"
                                                 label="name"
                                                 track-by="name" id="city_name" required>
                                        <template slot="singleLabel" slot-scope="props">
                                                        <span class="option__desc">
                                                            <span class="option__title">{{ props.option.name }}</span>
                                                        </span>
                                        </template>
                                        <template slot="option" slot-scope="props">
                                            <div class="option__desc">
                                                            <span class="option__title">{{
                                                                    props.option.formatted_address
                                                                }}</span>
                                            </div>
                                        </template>
                                    </multiselect>

                                    <p v-if="cities.length === 0" class="text-muted">
                                        City not found. <router-link target="_blank" class="text-muted" to="/cities/create" v-if="$can('city_create')">Add new city here.</router-link>
                                    </p>
                                </div>


                            </div>
                        </div>
                    </div>


                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Other Settings</h4>
                        </div>
                        <div class="card-body">

                            <div class="row">

                                <div class="form-group col-md-4">
                                    <label for="max_cart_items_count">Maximum Items Allowed In Cart </label>
                                    <input type="number" required class="form-control" name="max_cart_items_count"
                                           id="max_cart_items_count" v-model="store_settings.max_cart_items_count"
                                           placeholder='Maximum Items Allowed In Cart' min='1' required/>
                                    <span class="text text-primary font-size-13">( Maximum items user can add to cart at once )</span>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="min_order_amount">Minimum Order Amount</label>
                                    <input type="number" required class="form-control" name="min_order_amount"
                                           id="min_order_amount" v-model="store_settings.min_order_amount"
                                           placeholder='Minimum total amount to place order' min='1'/>
                                    <span class="text text-primary font-size-13"> ( Below this user will not allowed to place order )</span>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="low_stock_limit">Low stock limit</label>
                                    <input type="number" class="form-control" required name="low_stock_limit"
                                           id="low_stock_limit" v-model="store_settings.low_stock_limit"
                                           placeholder='Product low stock limit'/>
                                    <span class="text text-primary font-size-13"> ( Product will be considered as low stock if stock goes below this limit ) </span>
                                </div>

                                <!--                                    <div class="form-group col-md-4">
                                                                    <label for="area_wise_delivery_charge">Area wise delivery charge <span
                                                                        class="text text-primary font-size-13">(
                                                                        Enable/Disable )</span></label><br>
                                                                    <div class="form-check form-switch">
                                                                        <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="area_wise_delivery_charge"
                                                                               id="area_wise_delivery_charge"
                                                                               v-model="store_settings.area_wise_delivery_charge">
                                                                    </div>
                                                                </div>

                                                                <div class="form-group col-md-4">
                                                                    <label for="min_amount">Minimum Amount for Free Delivery () </label>
                                                                    <input type="number" class="form-control" name="min_amount" id="min_amount"
                                                                           v-model="store_settings.min_amount"
                                                                           placeholder='Minimum Order Amount for Free Delivery' min='0'/>
                                                                    <span class="text text-primary font-size-13">( Below this user
                                                                        will be charged based on Delivery Charge )</span>
                                                                </div>
                                                                <div class="form-group col-md-4">
                                                                    <label for="delivery_charge">Delivery Charge Amount ()</label>
                                                                    <input type="number" class="form-control" name="delivery_charge"
                                                                           id="delivery_charge" v-model="store_settings.delivery_charge"
                                                                           placeholder='Delivery Charge on Shopping' min='0'/>
                                                                </div>-->
<!--                                <div class="form-group col-md-4">
                                    <label for="minimum_withdrawal_amount">Maximum Withdrawal Amount</label>
                                    <input type="number" class="form-control" required name="minimum_withdrawal_amount"
                                           id="minimum_withdrawal_amount"
                                           v-model="store_settings.minimum_withdrawal_amount"
                                           placeholder='Minimum Withdrawal Amount'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="max_product_return_days">Max days to return item</label>
                                    <input type="number" class="form-control" required name="max_product_return_days"
                                           id="max_product_return_days" v-model="store_settings.max_product_return_days"
                                           placeholder='Max days to return item'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="delivery_boy_bonus_percentage">Delivery Boy Bonus (%)</label>
                                    <input type="number" class="form-control" required
                                           name="delivery_boy_bonus_percentage" id="delivery_boy_bonus_percentage"
                                           v-model="store_settings.delivery_boy_bonus_percentage"
                                           placeholder='Delivery Boy Bonus'/>
                                </div>

                                <div class="form-group col-md-4">
                                    <label for="user_wallet_refill_limit">User Wallet Refill Limit </label>
                                    <input type="number" class="form-control" required name="user_wallet_refill_limit"
                                           id="user_wallet_refill_limit"
                                           v-model="store_settings.user_wallet_refill_limit"
                                           placeholder='User Wallet Refill Limit'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="tax_name">Tax Name</label>
                                    <input type="text" class="form-control" required name="tax_name" id="tax_name"
                                           v-model="store_settings.tax_name" placeholder='Tax Name'/>
                                    <span class="text text-primary font-size-13">( This will be visible on your invoice )</span>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="tax_number">Tax Number</label>
                                    <input type="text" class="form-control" required name="tax_number" id="tax_number"
                                           v-model="store_settings.tax_number" placeholder='Tax Number'/>
                                </div>-->

                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Delivery Boy Common Bonus Settings</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">

                                <div class="form-group col-md-4">
                                    <label for="delivery_boy_bonus_settings">Bonus Settings</label><br>
                                    <div class="form-check form-switch">
                                        <input type="checkbox" true-value="1" false-value="0" class="form-check-input"
                                               name="delivery_boy_bonus_settings" id="delivery_boy_bonus_settings"
                                               v-model="store_settings.delivery_boy_bonus_settings">
                                    </div>
                                </div>
                                <div v-if="store_settings.delivery_boy_bonus_settings == 1" class="form-group col-md-4">
                                    <label for="delivery_boy_bonus_type">Bonus Type</label>
                                    <select name="delivery_boy_bonus_type" id="delivery_boy_bonus_type"
                                            v-model="store_settings.delivery_boy_bonus_type" class="form-control form-select">
                                        <option value="">Select</option>
                                        <option value="1">Commission</option>
                                        <option value="0">Fixed/Salaried</option>
                                    </select>
                                </div>
                                <div v-if="store_settings.delivery_boy_bonus_settings == 1 && store_settings.delivery_boy_bonus_type == 1" class="form-group col-md-4">
                                    <label for="delivery_boy_bonus_percentage">Delivery Boy Bonus Percentage(%)</label>
                                    <input type="number"
                                           min="0.1" max="100" step="0.1"
                                           class="form-control"
                                           name="delivery_boy_bonus_percentage" id="delivery_boy_bonus_percentage"
                                           v-model="store_settings.delivery_boy_bonus_percentage"
                                           placeholder='Delivery Boy Bonus'/>
                                </div>

                                <div v-if="store_settings.delivery_boy_bonus_settings == 1 && store_settings.delivery_boy_bonus_type == 1" class="form-group col-md-4">
                                    <label for="delivery_boy_bonus_min_amount">Minimum bonus amount</label>
                                    <input type="number" min="0" step="0.1" required class="form-control" name="delivery_boy_bonus_min_amount"
                                           id="delivery_boy_bonus_min_amount" v-model="store_settings.delivery_boy_bonus_min_amount"
                                           placeholder='Minimum bonus amount'/>
                                    <span class="text text-primary font-size-13">Set 0 if you want to remove limit.</span>
                                </div>

                                <div v-if="store_settings.delivery_boy_bonus_settings == 1 && store_settings.delivery_boy_bonus_type == 1" class="form-group col-md-4">
                                    <label for="delivery_boy_bonus_max_amount">Maximum bonus amount</label>
                                    <input type="number" min="0" step="0.1" required class="form-control" name="delivery_boy_bonus_max_amount"
                                           id="delivery_boy_bonus_max_amount" v-model="store_settings.delivery_boy_bonus_max_amount"
                                           placeholder='Maximum bonus amount'/>
                                    <span class="text text-primary font-size-13">Set 0 if you want to remove limit.</span>
                                </div>

                            </div>
                        </div>
                    </div>

<!--                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Refer & Earn System</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">

                                <div class="form-group col-md-4">
                                    <label for="min_refer_earn_order_amount">Minimum Refer & Earn Order Amount
                                        ()</label>
                                    <input type="number" required class="form-control"
                                           name="min_refer_earn_order_amount" id="min_refer_earn_order_amount"
                                           v-model="store_settings.min_refer_earn_order_amount"
                                           placeholder='Minimum Order Amount'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="refer_earn_bonus">Refer & Earn Bonus ( OR %)</label>
                                    <input type="number" required class="form-control" name="refer_earn_bonus"
                                           id="refer_earn_bonus" v-model="store_settings.refer_earn_bonus"
                                           placeholder='Bonus'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="refer_earn_method">Refer & Earn Method</label>
                                    <select name="refer_earn_method" id="refer_earn_method"
                                            v-model="store_settings.refer_earn_method" class="form-control form-select">
                                        <option value="">Select</option>
                                        <option value="percentage">Percentage</option>
                                        <option value="rupees">Rupees</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="max_refer_earn_amount">Maximum Refer & Earn Amount ()</label>
                                    <input type="number" required class="form-control" name="max_refer_earn_amount"
                                           id="max_refer_earn_amount" v-model="store_settings.max_refer_earn_amount"
                                           placeholder='Maximum Refer & Earn Amount'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="is_refer_earn_on">Status</label><br>
                                    <div class="form-check form-switch">
                                        <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="is_refer_earn_on"
                                               id="is_refer_earn_on" v-model="store_settings.is_refer_earn_on">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>-->
<!--                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Mail Settings</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label for="from_mail">From eMail ID: </label>
                                    <input type="email" class="form-control" required name="from_mail" id="from_mail"
                                           v-model="store_settings.from_mail" placeholder='From Email ID'/>
                                    <span class="text text-primary font-size-13"> ( This email ID will be used in Mail System ) </span>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="reply_to">Reply To eMail ID: </label>
                                    <input type="email" class="form-control" required name="reply_to" id="reply_to"
                                           v-model="store_settings.reply_to" placeholder='From Email ID'/>
                                    <span class="text text-primary font-size-13"> ( This email ID will be used in Mail System ) </span>
                                </div>
                            </div>
                        </div>
                    </div>-->
<!--                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">OTP Settings</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="form-group col-md-6">
                                    <label for="generate_otp">Order Delivery OTP System <span
                                        class="text text-primary font-size-13">( Enable/Disable
                                        )</span></label><br>
                                    <div class="form-check form-switch">
                                        <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="generate_otp" id="generate_otp" v-model="store_settings.generate_otp">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>-->
                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Maintenance Mode</h4>
                        </div>
                        <div class="card-body">
                            <span class=" text text-primary font-size-13">In this mode you can set your app in Maintenance and that Appilication will not work till not disabled from here</span>
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label for="app_mode_customer">Customer APP <span
                                        class="text text-primary font-size-13">( Enable/Disable
                                        )</span></label><br>
                                    <div class="form-check form-switch">
                                        <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="app_mode_customer"
                                               id="app_mode_customer" v-model="store_settings.app_mode_customer">
                                    </div>

                                    <div class="form-floating mb-3" v-if="store_settings.app_mode_customer == 1" >
                                        <textarea name="message" id="app_mode_customer_remark" :required="store_settings.app_mode_customer == 1"  v-model="store_settings.app_mode_customer_remark" class="form-control" placeholder="Enter Notification Message Here!"></textarea>
                                        <label for="app_mode_customer_remark">Customer APP Remark</label>
                                    </div>


                                </div>
                                <div class="form-group col-md-4">
                                    <label for="app_mode_seller">Seller APP <span
                                        class="text text-primary font-size-13">( Enable/Disable
                                        )</span></label><br>
                                    <div class="form-check form-switch">
                                        <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="app_mode_seller"
                                               id="app_mode_seller" v-model="store_settings.app_mode_seller">
                                    </div>
                                    <div class="form-floating mb-3" v-if="store_settings.app_mode_seller == 1">
                                        <textarea name="message" id="app_mode_seller_remark" :required="store_settings.app_mode_seller == 1"  v-model="store_settings.app_mode_seller_remark" class="form-control" placeholder="Enter Notification Message Here!"></textarea>
                                        <label for="app_mode_seller_remark">Seller APP Remark</label>
                                    </div>

                                </div>
                                <div class="form-group col-md-4">
                                    <label for="app_mode_delivery_boy">Delivery Boy APP<span
                                        class="text text-primary font-size-13">( Enable/Disable
                                        )</span></label><br>
                                    <div class="form-check form-switch">
                                        <input type="checkbox" true-value="1" false-value="0" class="form-check-input" name="app_mode_delivery_boy"
                                               id="app_mode_delivery_boy"
                                               v-model="store_settings.app_mode_delivery_boy">
                                    </div>

                                    <div class="form-floating mb-3" v-if="store_settings.app_mode_delivery_boy == 1">
                                        <textarea name="message" id="app_mode_delivery_boy_remark" :required="store_settings.app_mode_delivery_boy == 1" v-model="store_settings.app_mode_delivery_boy_remark" class="form-control" placeholder="Enter Notification Message Here!"></textarea>
                                        <label for="app_mode_delivery_boy_remark">Delivery Boy APP Remark</label>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">SMTP Mail Settings</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label for="smtp_from_mail">From Email ID:</label>
                                    <input type="text" class="form-control" required name="smtp_from_mail"
                                           id="smtp_from_mail" v-model="store_settings.smtp_from_mail"
                                           placeholder='From SMTP Email ID'/>
                                    <span class="text text-primary font-size-13">( This email ID will be used in
                                        SMTP Mail System )</span>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="smtp_reply_to">Reply To Email ID:</label>
                                    <input type="email" class="form-control" required name="smtp_reply_to"
                                           id="smtp_reply_to" v-model="store_settings.smtp_reply_to"
                                           placeholder='From SMTP Email ID'/>
                                    <span class="text text-primary font-size-13">( This email ID will be used in
                                        SMTP Mail System )</span>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="smtp_email_password">SMTP Email Password: </label>
                                    <input type="text" class="form-control" required name="smtp_email_password"
                                           id="smtp_email_password" v-model="store_settings.smtp_email_password"
                                           placeholder='Enter your SMTP email password'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="smtp_host">SMTP Host: </label>
                                    <input type="text" class="form-control" required name="smtp_host" id="smtp_host"
                                           v-model="store_settings.smtp_host" placeholder='SMTP Host address'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="smtp_port">SMTP Port:
                                    </label>
                                    <input type="text" class="form-control" required name="smtp_port" id="smtp_port"
                                           v-model="store_settings.smtp_port" placeholder='SMTP Port'/>
                                    <span class="text text-primary font-size-13">( <b>TLS: </b>587 <b>SSL: </b>465 )</span>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="smtp_content_type">SMTP Email Content Type: </label>
                                    <select name="smtp_content_type" id="smtp_content_type"
                                            v-model="store_settings.smtp_content_type" class="form-control form-select">
                                        <option value="">Select SMTP eMail Content Type</option>
                                        <option value="html">HTML</option>
                                        <option value="text">Text</option>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="smtp_encryption_type">SMTP Encryption: </label>
                                    <select name="smtp_encryption_type" id="smtp_encryption_type"
                                            v-model="store_settings.smtp_encryption_type"
                                            class="form-control form-select">
                                        <option value="">Select SMTP Encryption Type</option>
                                        <option value="tls">TLS</option>
                                        <option value="ssl">SSL</option>
                                    </select>
                                </div>
                            </div>

                            <hr>
                            <div class="row">
                                <h6>Email Test</h6>
                                <div class="form-group col-md-4">
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="test_email" v-model="store_settings.test_email" placeholder='Enter Email Address for Test'>
                                        <b-button type="button" variant="primary" @click="testMail" :disabled="isSendingTestEmail">
                                            Test Mail
                                            <b-spinner v-if="isSendingTestEmail" small label="Spinning"></b-spinner>
                                        </b-button>
                                    </div>
                                    <p>Enter Email Address and press send Test Mail for Test Your SMTP Configuration</p>
                                </div>

<!--                                <div class="form-group col-md-4">
                                    <input type="email" class="form-control" name="test_email" v-model="store_settings.test_email" placeholder='Enter Email Address for Test'/>
                                </div>
                                <div class="form-group col-md-4">
                                    <b-button type="button" variant="primary" @click="testMail" :disabled="isSendingTestEmail">
                                        Test Mail
                                        <b-spinner v-if="isSendingTestEmail" small label="Spinning"></b-spinner>
                                    </b-button>
                                </div>-->
                            </div>

                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header" v-if="$isDemo != 1">
                            <h4 class="card-title">Google Place Apis</h4>
                        </div>
                        <div class="card-body" v-if="$isDemo != 1">
                            <div class=" row align-items-center"  >
                                <div class="form-group col-md-4">
                                    <label for="google_place_api_key">Place Api Key</label>
                                    <input type="text" class="form-control" name="google_place_api_key" id="google_place_api_key" v-model="store_settings.google_place_api_key" placeholder="Google Place Api Key">
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
<!--                            <input type="submit" id="btn_update" class="btn-primary btn" :value="__('update')" name="btn_update"
                                   v-if="$can('manage_store_settings')"/>-->

                            <b-button type="submit" variant="primary" :disabled="isLoading" v-if="$can('manage_store_settings')">{{ __('update') }}
                                <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
                            </b-button>
                        </div>
                    </div>

<!--                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Cron Job URL for Seller commission</h4>
                        </div>
                        <div class="card-body">
                            <div class=" row align-items-center"  >
                                <div class="form-group col-md-4">
                                    <label for="midtrans_notification_url">Cron Job URL </label>
                                    <input type="text" class="form-control" name="midtrans_notification_url"
                                           id="midtrans_notification_url"
                                           value="http://localhost/client/ecart/ecart_php/update-seller-commission.php"
                                           placeholder="Cron Job URL" disabled="">
                                    <span class="text text-primary font-size-13">(Set this URL at your
                                        server cron job list for "once a day")</span>
                                </div>
                                <div class="form-group col-md-4">
                                    <label>&nbsp;</label>
                                    <a class='btn btn-sm btn-primary'
                                       data-toggle='modal'
                                       data-target='#howItWorksModal'
                                       title='How it works'>How seller commission
                                        works?</a>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <input type="submit" id="btn_update" class="btn-primary btn" :value="__('update')" name="btn_update" v-if="$can('manage_store_settings')"/>
                        </div>
                    </div>-->

                </form>
            </section>
        </div>
    </div>
</template>
<script>
import axios from "axios";

import Multiselect from 'vue-multiselect';
import {VuejsDatatableFactory} from "vuejs-datatable";
import Select2 from "v-select2-component";

export default {
    components: {
        Multiselect,
    },
    data: function () {
        return {
            isLoading: false,
            city: "",
            cities: [],

            store_settings: {},
            record: null,
            timezone_options: null,
            currency_codes: null,
            logo_url:"",
            logo_name:"",
            isSendingTestEmail : false
        }
    },
    created: function () {
        this.getCities();
        this.getStoreSetting()
    },
    methods: {
        dropFile(event) {
            event.preventDefault();
            this.$refs.logo.files = event.dataTransfer.files;
            this.handleLogoUpload(); // Trigger the onChange event manually
            // Clean up
            event.currentTarget.classList.add('bg-gray-100');
            event.currentTarget.classList.remove('bg-green-300');
        },
        handleLogoUpload: function () {
            this.store_settings.logo = this.$refs.logo.files[0];
            this.logo_url = URL.createObjectURL(this.store_settings.logo);
            this.logo_name = this.store_settings.logo.name;
        },

        getCities() {
            this.isLoading = true
            axios.get(this.$apiUrl + '/cities')
            .then((response) => {
                this.isLoading = false
                let data = response.data;
                this.cities = data.data

                if(this.deliveryBoys.id){
                    this.city = this.cities.filter((item) => {
                        return item.id === this.record.city_id;
                    });
                }
            }).catch(error => {
                this.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError("Something went wrong!");
                }
            })
        },
        setCityId() {
            this.store_settings.default_city_id = this.city.id;
        },

        getStoreSetting() {
            let url = this.$apiUrl + '/store_settings';
            let vm = this;
            axios.get(url).then((response) => {
                this.store_settings = response.data.data.store_settingsObject;
                this.timezone_options = response.data.data.timezone_options;
                this.currency_codes = response.data.data.currency_code.country;

                this.record = response.data.data.store_settings;
                this.record.map((item, index) => {

                    if (item.value === '0' || item.value === '1') {
                        this.store_settings[item.variable] = (item.value === '0') ? 0 : 1;
                    } else {
                        this.store_settings[item.variable] = item.value;
                    }

                    //this.store_settings[item.variable] = item.value;
                });

                this.city = this.cities.filter((item) => {
                    return item.id === parseInt(this.store_settings.default_city_id);
                });

                if(this.store_settings.logo != ""){
                    this.logo_url = this.$storageUrl + this.store_settings.logo;
                }else{
                    this.logo_url = this.$baseUrl + '/images/logo.png';
                }
            });
        },

        saveRecord: function () {
            this.isLoading = true;
            //console.log("formdata=>", this.store_settings);
            //let formData = this.store_settings;

            let store_settingsObject = this.store_settings;
            let formData = new FormData();
            for (let key in store_settingsObject) {
                formData.append(key, store_settingsObject[key]);
            }

            let url = this.$apiUrl + '/store_settings/save';
            let vm = this;
            axios.post(url, formData).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    //this.showSuccess(data.message);
                    this.showMessage("success", data.message);
                    this.getStoreSetting();
                    setTimeout(
                        function () {
                            vm.$swal.close();
                            vm.isLoading = false;
                            window.location.reload();
                            vm.$router.push({path: '/store_settings'});
                        }, 2000);
                } else {
                    vm.showError(data.message);
                    vm.isLoading = false;
                }
            }).catch(error => {
                this.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError("Something went wrong!");
                }
                vm.isLoading = false;
            });
        },

        testMail: function () {

            let data = {
                'email' : this.store_settings.test_email,
                'host' : this.store_settings.smtp_host,
                'username' : this.store_settings.smtp_from_mail,
                'password' : this.store_settings.smtp_email_password,
                'port' : this.store_settings.smtp_port,
                'encryption' : this.store_settings.smtp_encryption_type,
                'support_email' : this.store_settings.support_email,
            };

            let url = this.$apiUrl + '/store_settings/test_mail';
            let vm = this;
            vm.isSendingTestEmail = true;
            axios.post(url, data).then(res => {
                vm.isSendingTestEmail = false;
                let data = res.data;
                if (data.status === 1) {
                    this.showMessage("success", data.message);
                } else {
                    vm.showError(data.message);
                    vm.isLoading = false;
                }
            }).catch(error => {
                vm.isSendingTestEmail = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError("Something went wrong!");
                }
            })
        }
    }
}
</script>
<style scoped>
@import "../../../../node_modules/vue-multiselect/dist/vue-multiselect.min.css";
</style>
