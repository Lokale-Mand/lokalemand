<template>
    <div>
        <div class="page-heading">

            <div class="row">
                <div class="col-12 col-md-6 order-md-1 order-last">
                    <h3 v-if="this.$roleSeller === this.login_user.role.name" >
                        My Profile
                    </h3>
                    <h3 v-else>
                        <template v-if="id">Edit</template>
                        <template v-else>Create</template>
                        Seller
                    </h3>
                </div>
                <div class="col-12 col-md-6 order-md-2 order-first">
                    <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <router-link to="/seller" v-if="this.$roleSeller === this.login_user.role.name" >Dashboard</router-link>
                                <router-link to="/dashboard" v-else>Dashboard</router-link>
                            </li>
                            <template v-if="this.$roleSeller === this.login_user.role.name" >
                                <li class="breadcrumb-item" aria-current="page">My Profile</li>
                            </template>
                            <template v-else>

                                <li class="breadcrumb-item" aria-current="page">
                                    <router-link to="/sellers">Manage Sellers</router-link>
                                </li>

                                <li class="breadcrumb-item active" aria-current="page">
                                    <template v-if="id">Edit</template>
                                    <template v-else>Create</template>
                                    Seller
                                </li>
                            </template>
                        </ol>
                    </nav>
                </div>
            </div>

            <div class="row">
                <div class="col-12 col-md-12 order-md-1 order-last">
                    <form ref="my-form" @submit.prevent="saveRecord">
                        <div class="card">
                            <div class="card-header">
                                <h4>Seller Information</h4>
                                <span class="pull-right"  v-if="this.$roleSeller !== this.login_user.role.name">
                                    <router-link to="/sellers" class="btn btn-primary" v-b-tooltip.hover title="Manage Seller">Manage Seller</router-link>
                                </span>
                            </div>
                            <div class="card-body">
                                <label><span class="text-danger text-xs">*</span> Required fields.</label>
                                <div class="divider" v-if="this.$roleSeller !== this.login_user.role.name"><div class="divider-text">New Seller Register Form</div></div>
                                <div class="row">
                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Name <i class="text-danger">*</i></label>
                                            <input type="text" class="form-control" v-model="name"
                                                   placeholder="Enter name.">
                                        </div>
                                    </div>
                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Email <i class="text-danger">*</i></label>
                                            <input type="email" class="form-control" v-model="email"
                                                   placeholder="Enter email.">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Mobile <i class="text-danger">*</i></label>
                                            <input type="number" class="form-control" v-model="mobile"
                                                   placeholder="Enter mobile number">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-4" v-if="this.$roleSeller !== this.login_user.role.name">
                                        <div class="form-group">
                                            <label>Password <i v-if="!id" class="text-danger">*</i></label>
                                            <div class="input-group">
                                                <input :type="showPassword ? 'text' : 'password'"  class="form-control" v-model="password" placeholder="Enter password.">
                                                <button type="button" v-on:click="showPassword = !showPassword" class="btn btn-primary font-bold">
                                                    <i v-if="showPassword" class="fa fa-eye-slash" aria-hidden="true"></i>
                                                    <i v-else class="fa fa-eye" aria-hidden="true"></i>
                                                </button>
                                            </div>

                                        </div>
                                    </div>

                                    <div class="form-group col-md-4" v-if="this.$roleSeller !== this.login_user.role.name">
                                        <div class="form-group">
                                            <label>Confirm Password <i v-if="!id" class="text-danger">*</i></label>
                                            <div class="input-group">
                                                <input :type="showConfirmPassword ? 'text' : 'password'" class="form-control" v-model="confirm_password" placeholder="Enter confirm password.">
                                                <button type="button" v-on:click="showConfirmPassword = !showConfirmPassword" class="btn btn-primary font-bold">
                                                    <i v-if="showConfirmPassword" class="fa fa-eye-slash" aria-hidden="true"></i>
                                                    <i v-else class="fa fa-eye" aria-hidden="true"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <h4>Store Information</h4>
                            </div>
                            <div class="card-body">
                                <div class="row">

                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Store Name <i class="text-danger">*</i></label>
                                            <input type="text" class="form-control" v-model="store_name"
                                                   placeholder="Enter store name.">
                                        </div>
                                    </div>
                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Store URL</label>
                                            <input type="text" class="form-control" v-model="store_url"
                                                   placeholder="Enter store URL.">
                                        </div>
                                    </div>
                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Category IDs <i class="text-danger">*</i> <small>( Ex : 100,205, 360 )
<!--                                                <comma separated="">)</comma>-->
                                            </small></label>
                                            <Select2 v-model="categories_ids"
                                                     placeholder="Select Categories"
                                                     :options="categories_options"
                                                     :settings="{ multiple: 'multiple'}"/>
<!--                                                                                        settingOption: value, settingOption: value-->
                                        </div>
                                    </div>

                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Tax Name</label>
                                            <input type="text" class="form-control" v-model="tax_name"
                                                   placeholder="Enter tax name.">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Tax Number</label>
                                            <input type="text" class="form-control" v-model="tax_number"
                                                   placeholder="Enter tax number.">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>PAN Number <i class="text-danger">*</i></label>
                                            <input type="text" class="form-control" v-model="pan_number"
                                                   placeholder="Enter PAN number.">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-4">
                                        <label>Commission (%) <i class="text-danger">*</i></label>
                                        <input type="number" class="form-control" v-model="commission"
                                               placeholder="Enter commission (%)">
                                        <span class="text text-primary font-size-13"> Will be used if category wise commission not set)
                                            <a href="javascript:void(0)" @click="commissionRule = true"
                                               title="How it works">How seller commission works?</a>
                                        </span>
                                    </div>
                                    <br>
                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>National Identity Card <i v-if="!id" class="text-danger">*</i></label>
                                            <!--                                            <input type="file" class="file-input" ref="file_national_id_card"
                                                                                               v-on:change="handleFileNationalIdCard" required v-if="!id">
                                                                                        <input type="file" class="file-input" ref="file_national_id_card"
                                                                                               v-on:change="handleFileNationalIdCard" v-if="id">-->
                                            <input type="file" class="file-input" accept="image/*,application/pdf,.doc,.docx" ref="file_national_id_card" v-if="this.$roleSeller !== this.login_user.role.name" v-on:change="handleFileNationalIdCard">
                                            <div class="file-input-div bg-gray-100" v-if="this.$roleSeller !== this.login_user.role.name" @click="$refs.file_national_id_card.click()" @drop="dropFileNationalIdCard" @dragover="$dragoverFile" @dragleave="$dragleaveFile">
                                                <template v-if="national_id_card && national_id_card.name !== ''">
                                                    <label>Selected file name:- {{ national_id_card.name }}</label>
                                                </template>
                                                <template v-else>
                                                    <label><i class="fa fa-cloud-upload fa-2x"></i></label>
                                                    <label>{{ __('drop_files_here_or_click_to_upload') }}</label>
                                                </template>
                                            </div>
                                            <div class="row" v-if="national_id_card_url">
                                                <div v-if="isImage(national_id_card_url)" class="col-md-2">
                                                    <img class="custom-image" :src="national_id_card_url" title='Identity Card' alt='Identity Card'/>
                                                </div>
                                                <div v-else class="col-md-2 mt-2">
                                                    <a target="_blank" :href="national_id_card_url" class="badge bg-success"> <i class="fa fa-eye"></i> Identity Card</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Address Proof <i v-if="!id" class="text-danger">*</i></label>
                                            <!--                                            <input type="file" class="file-input" ref="file_address_proof"
                                                                                               v-on:change="handleFileAddressProof" required v-if="!id">
                                                                                        <input type="file" class="file-input" ref="file_address_proof"
                                                                                               v-on:change="handleFileAddressProof" v-if="id">-->
<!--                                            <input type="file" class="file-input" ref="file_address_proof" v-if="this.$roleSeller !== this.login_user.role.name" v-on:change="handleFileAddressProof" :required="!id">-->
                                            <input type="file" class="file-input" accept="image/*,application/pdf,.doc,.docx"  ref="file_address_proof" v-if="this.$roleSeller !== this.login_user.role.name" v-on:change="handleFileAddressProof">
                                            <div class="file-input-div bg-gray-100" v-if="this.$roleSeller !== this.login_user.role.name" @click="$refs.file_address_proof.click()" @drop="dropFileAddressProof" @dragover="$dragoverFile" @dragleave="$dragleaveFile">
                                                <template v-if="address_proof_name == '' ">
                                                    <label><i class="fa fa-cloud-upload fa-2x"></i></label>
                                                    <label>{{ __('drop_files_here_or_click_to_upload') }}</label>
                                                </template>
                                                <template v-else>
                                                    <label>Selected file name:- {{ address_proof_name }}</label>
                                                </template>
                                            </div>
                                            <div class="row" v-if="address_proof_url">
                                                <div  v-if="isImage(address_proof_url)"  class="col-md-2">
                                                    <img class="custom-image" :src="address_proof_url" title='Address Proof' alt='Address Proof'/>
                                                </div>
                                                <div v-else class="col-md-2 mt-2">
                                                    <a target="_blank" :href="address_proof_url" class="badge bg-success"> <i class="fa fa-eye"></i> Address Proof</a>
                                                </div>
                                            </div>

                                        </div>
                                    </div>

                                    <div class="form-group col-md-12">

                                        <label for="logo">Logo <i v-if="!id" class="text-danger">*</i></label>
<!--                                        <input type="file" id="logo" class="file-input" ref="file_store_logo" v-on:change="handleFileStoreLogo" :required="!id">-->
                                        <input type="file" accept="image/*" id="logo" class="file-input" ref="file_store_logo" v-on:change="handleFileStoreLogo">
                                        <div class="file-input-div bg-gray-100" @click="$refs.file_store_logo.click()" @drop="dropFileStoreLogo" @dragover="$dragoverFile" @dragleave="$dragleaveFile">
                                            <template v-if="store_logo && store_logo.name !== ''">
                                                <label>Selected file name:- {{ store_logo.name }}</label>
                                            </template>
                                            <template v-else>
                                                <label><i class="fa fa-cloud-upload fa-2x"></i></label>
                                                <label>{{ __('drop_files_here_or_click_to_upload') }}</label>
                                            </template>
                                        </div>

                                        <div class="row" v-if="store_logo_url">
                                            <div class="col-md-2">
                                                <img class="custom-image" :src="store_logo_url" title='Store Logo' alt='Store Logo'/>
                                            </div>
                                        </div>


                                    </div>

                                    <div class="col-md-12" v-if="id && this.$roleSeller !== this.login_user.role.name">
                                        <div class="row">
                                            <div class="form-group col-md-5">
                                                <label class="control-label">Status <i class="text-danger">*</i></label><br>
                                                <b-form-radio-group
                                                    v-model="status"
                                                    :options="[
                                                    { text: ' Registered', 'value': 0 },
                                                    { text: ' Approved', 'value': 1 },
                                                    { text: ' Not-Approved', 'value': 2 },
                                                    { text: ' Deactive', 'value': 3 },
                                                ]"
                                                    buttons
                                                    button-variant="outline-primary"
                                                    required
                                                ></b-form-radio-group>
                                            </div>
                                            <div v-if="[2,3].includes(status)" class="form-group col-md-4">

                                                <label for="remark">Remark <i class="text-danger">*</i></label>
                                                <div class="form-floating">
                                                    <textarea class="form-control" name="remark" id="remark" required v-model="remark" placeholder="Add a remark of this status..." spellcheck="true"></textarea>
                                                    <label for="remark">Add a remark of this status...</label>
                                                </div>

                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group col-md-12">

                                        <label>Store Description </label>
                                        <editor
                                            placeholder="Enter store description"
                                            v-model="store_description"
                                            :api-key="this.$editorKey"
                                            :init="{
                                                            height:400,
                                                            plugins: this.$editorPlugins ,
                                                            toolbar: this.$editorToolbar,
                                                            font_size_formats: this.$editorFont_size_formats,
                                                        }"
                                        />

                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <h4>Store Location Information</h4>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="form-group col-md-4">
                                        <label for="city_name">Select or Search City <i class="text-danger">*</i></label>
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
                                    </div>
                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>State</label>
                                            <input type="text" class="form-control" v-model="state" readonly placeholder="Enter state">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Street</label>
                                            <input type="text" class="form-control" v-model="street"
                                                   readonly placeholder="Enter street.">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-4">
                                        <label for="location">Search Location</label>



                                        <div class="input-group">
                                            <GmapAutocomplete type="search" class="form-control" placeholder="Search you location on map."
                                                              @place_changed="setPlace"
                                                              :options="{ fields: ['formatted_address', 'geometry', 'name'], strictBounds: false}"
                                                              id="location">
                                            </GmapAutocomplete>

                                            <b-button type="button" variant="primary" v-b-tooltip.hover  title="Add current location" @click="getCurrentLocation">
                                                <svg xmlns="http://www.w3.org/2000/svg" height="48px" viewBox="0 0 24 24" width="48px" fill="#FFFFFF">
                                                    <title>current-location</title>
                                                    <path d="M0 0h24v24H0V0z" fill="none"/><path d="M12 8c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4zm8.94 3c-.46-4.17-3.77-7.48-7.94-7.94V1h-2v2.06C6.83 3.52 3.52 6.83 3.06 11H1v2h2.06c.46 4.17 3.77 7.48 7.94 7.94V23h2v-2.06c4.17-.46 7.48-3.77 7.94-7.94H23v-2h-2.06zM12 19c-3.87 0-7-3.13-7-7s3.13-7 7-7 7 3.13 7 7-3.13 7-7 7z"/>
                                                </svg>



                                            </b-button>
                                        </div>

                                        <span class="text-danger d-block font-size-13">*Only Search Location, When Update is necessary</span>
                                        <span class="text text-primary font-size-13">Search your seller name and you will get the location points(Latitude & Longitude) below.</span>
                                    </div>

                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Latitude <i class="text-danger">*</i></label>
                                            <input type="text" class="form-control" v-model="latitude" readonly placeholder="Enter latitude.">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-4">
                                        <div class="form-group">
                                            <label>Longitude <i class="text-danger">*</i></label>
                                            <input type="text" class="form-control" v-model="longitude" readonly placeholder="Enter longitude.">
                                        </div>
                                    </div>

                                    <div class="col-md-12 mb-3">
                                        <div v-if="formatted_address" class="text-danger">*Drag and click marker to your shop proper location (This will affect into delivery charge calculation)</div>
                                        <div id="map" style="position: relative; overflow: hidden;">
                                            <GmapMap
                                                :center="center"
                                                :zoom="13"
                                                :mapTypeControl=true
                                                style="width: 100%; height: 400px; margin-top: 20px"
                                                ref="mapRef"
                                                @click="handleMapClick"
                                            >
                                                <GmapMarker
                                                    :key="index"
                                                    v-for="(m, index) in markers"
                                                    :position="m.position"
                                                    :clickable="true"
                                                    :draggable="true"
                                                    @drag="updateCoordinates"
                                                    @click="updateCoordinates"
                                                />
                                                <!--                                                    @click="center = m.position"-->
                                                <gmap-info-window
                                                    :options="{
                                                                  maxWidth: 300,
                                                                  pixelOffset: { width: 0, height: -35 }
                                                                }"
                                                    :position="infoWindow.position"
                                                    :opened="infoWindow.open"
                                                    @closeclick="infoWindow.open=false">
                                                    <div v-html="infoWindow.template"></div>
                                                </gmap-info-window>
                                            </GmapMap>
                                        </div>
                                        <div v-if="formatted_address">
                                            <span class="title font-weight-bolder"><b>{{
                                                    place_name
                                                }}</b> - {{ formatted_address }}</span>
                                        </div>
                                    </div>



                                </div>
                            </div>
                            <div class="card-footer" v-if="id && this.$roleSeller === this.login_user.role.name">
                                <b-button type="submit" variant="primary" :disabled="isLoading">Save
                                    <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
                                </b-button>
                                <button type="button" class="btn btn-danger" @click="$router.go(-1)">Back</button>
                            </div>
                        </div>

                        <div class="card" v-if="this.$roleSeller !== this.login_user.role.name">
                            <div class="card-header">
                                <h4>Seller Bank Information</h4>
                            </div>
                            <div class="card-body">
                                <div class="row">

                                    <div class="form-group col-md-3">
                                        <div class="form-group">
                                            <label>Bank Name <i class="text-danger">*</i></label>
                                            <input type="text" class="form-control" v-model="bank_name"
                                                   placeholder="Enter bank name.">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-3">
                                        <div class="form-group">
                                            <label>Account Number <i class="text-danger">*</i></label>
                                            <input type="number" class="form-control" v-model="account_number"
                                                   placeholder="Enter account number.">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-3">
                                        <div class="form-group">
                                            <label>Bank's IFSC Code <i class="text-danger">*</i></label>
                                            <input type="text" class="form-control" v-model="ifsc_code"
                                                   placeholder="Enter bank's IFSC code.">
                                        </div>
                                    </div>

                                    <div class="form-group col-md-3">
                                        <div class="form-group">
                                            <label>Bank Account Name <i class="text-danger">*</i></label>
                                            <input type="text" class="form-control valid" v-model="account_name"
                                                   placeholder="Enter bank account name.">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card" v-if="this.$roleSeller !== this.login_user.role.name" >
                            <div class="card-header">
                                <h4>Other Setting</h4>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="form-group col-md-3">
                                        <div class="form-group">
                                            <label class="control-label">Require Product's Approval</label><br>
                                            <b-form-radio-group
                                                v-model="require_products_approval"
                                                :options="[
                                                                { text: ' Yes', 'value': 0 },
                                                                { text: ' No', 'value': 1 },
                                                            ]"
                                                buttons
                                                button-variant="outline-primary"
                                                required
                                            ></b-form-radio-group>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-3">
                                        <div class="form-group">
                                            <label class="control-label">View Customer's Details? </label><br>
                                            <b-form-radio-group
                                                v-model="customer_privacy"
                                                :options="[
                                                                { text: ' Yes', 'value': 1 },
                                                                { text: ' No', 'value': 0 },
                                                            ]"
                                                buttons
                                                button-variant="outline-primary"
                                                required
                                            ></b-form-radio-group>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-3">
                                        <div class="form-group">
                                            <label class="control-label">View Order's OTP? </label><br>
                                            <b-form-radio-group
                                                v-model="view_order_otp"
                                                :options="[
                                                                { text: ' Yes', 'value': 1 },
                                                                { text: ' No', 'value': 0 },
                                                            ]"
                                                buttons
                                                button-variant="outline-primary"
                                                required
                                            ></b-form-radio-group>
                                        </div>
                                    </div>
                                    <div class="form-group col-md-3">
                                        <div class="form-group">
                                            <label class="control-label">Can assign delivery boy? </label><br>
                                            <b-form-radio-group
                                                v-model="assign_delivery_boy"
                                                :options="[
                                                                { text: ' Yes', 'value': 1 },
                                                                { text: ' No', 'value': 0 },
                                                            ]"
                                                buttons
                                                button-variant="outline-primary"
                                                required
                                            ></b-form-radio-group>
                                        </div>
                                    </div>

                                    <div class="form-group col-md-3">
                                        <div class="form-group">
                                            <label class="control-label">Can change order status to Delivered? </label><br>
                                            <b-form-radio-group
                                                v-model="change_order_status_delivered"
                                                :options="[
                                                                { text: ' Yes', 'value': 1 },
                                                                { text: ' No', 'value': 0 },
                                                            ]"
                                                buttons
                                                button-variant="outline-primary"
                                                required
                                            ></b-form-radio-group>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <template v-if="id">
                                    <b-button type="submit" variant="primary" :disabled="isLoading"> Update
                                        <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
                                    </b-button>
                                </template>
                                <template v-else>
                                    <b-button type="submit" variant="primary" :disabled="isLoading">Save
                                        <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
                                    </b-button>
                                    <button type="reset" class="btn btn-danger">Clear</button>
                                </template>
                            </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
        <!-- Commission Rule Modal-->
        <b-modal v-model="commissionRule" size="lg" title="How seller commission will get credited?">
            <b-container fluid>
                <ol>
                    <li>
                        Cron job must be set (For once in a day) on your server for seller commission to be work.
                    </li>
                    <li>
                        Cron job will run every mid night at 12:00 AM.
                    </li>
                    <li>
                        Formula for seller commision is <b>Sub total (Excluding delivery charge) / 100 * seller
                        commission percentage</b>
                    </li>
                    <li>
                        For example sub total is 1378 and seller commission is 20% then 1378 / 100 X 20 = 275.6 so 1378
                        - 275.6 = 1102.4 will get credited into seller's wallet.
                    </li>
                    <li>
                        If Order status is delivered then only seller will get commisison.
                    </li>
                    <li>
                        Ex - 1. Order placed on 11-Aug-21 and product return days are set to 0 so 11-Aug + 0 days =
                        11-Aug seller commission will get credited on 12-Aug-21 at 12:00 AM (Mid night)
                    </li>
                    <li>
                        Ex - 2. Order placed on 11-Aug-21 and product return days are set to 7 so 11-Aug + 7 days =
                        18-Aug seller commission will get credited on 19-Aug-21 at 12:00 AM (Mid night)
                    </li>
                    <li>
                        If seller commission doesn't works make sure cron job is set properly and it is working. If you
                        don't know how to set cron job for once in a day please take help of server support or do search
                        for it.
                    </li>
                </ol>
            </b-container>
            <template #modal-footer>
                <b-button variant="secondary" size="sm" class="float-right" @click="commissionRule=false">Close
                </b-button>
            </template>
        </b-modal>
    </div>
</template>
<script>
import {VuejsDatatableFactory} from 'vuejs-datatable';
import axios from "axios";
import Select2 from 'v-select2-component';

import Multiselect from 'vue-multiselect';
import {gmapApi} from 'vue2-google-maps';
import Editor from '@tinymce/tinymce-vue';

import Auth from '../../Auth.js';

export default {
    components: {
        VuejsDatatableFactory,
        Select2,
        Multiselect,
        'editor': Editor
    },
    data: function () {
        return {
            login_user: Auth.user,

            isLoading: false,
            center: {lat: 0, lng: 0},
            map:"",
            drawingManager:"",

            currentPlace: null,
            markers: [],
            place_name: "",
            formatted_address: "",
            infoWindow: {
                position: {lat: 0, lng: 0},
                open: false,
                template: ''
            },
            city: "",
            cities: [],

            name: "",
            email: "",
            mobile: "",
            store_url: "",

            password: "",
            showPassword: false,
            confirm_password: "",
            showConfirmPassword:false,

            store_name: "",
            street: "",
            pincode_id: "",
            city_id: "",
            categories_ids: [],
            state: "",
            remark:"",
            account_number: "",
            ifsc_code: "",
            bank_name: "",
            account_name: "",
            commission: "",
            tax_name: "",
            tax_number: "",
            pan_number: "",
            latitude: "",
            longitude: "",
            store_description: "",
            require_products_approval: 0,
            customer_privacy: 0,
            view_order_otp: 0,
            assign_delivery_boy: 0,
            change_order_status_delivered: 0,
            status: 0,
            store_logo: "",
            store_logo_url: "",
            national_id_card: "",
            national_id_card_url: "",
            national_id_card_name: "",

            address_proof: "",
            address_proof_url: "",
            address_proof_name: "",

            categories: [],
            id: null,
            admin_id: null,
            record: null,
            id_card: "",
            proof: "",

            commissionRule: false
        }
    },
    created: function () {
        this.getCategories();
        this.getCities();

        this.id = this.$route.params.id;
        if(this.$roleSeller === this.login_user.role.name){
            this.id = this.login_user.seller.id;
        }

        if (this.id) {
            this.getSeller();
        }
    },
    computed: {
        categories_options: function () {
            var temp = [];
            if(this.categories.length !== 0 ) {
                this.categories.forEach(category => {
                    //Only Main Categories
                    if (category.parent_id == 0) {
                        temp.push({id: category.id, text: category.name})
                    }
                });
            }
            return temp;
        },
        google: gmapApi
    },
    methods: {
        getCities() {
            this.isLoading = true
            axios.get(this.$apiUrl + '/cities')
                .then((response) => {
                    this.isLoading = false
                    let data = response.data;
                    this.cities = data.data
                }).catch(error => {
                this.isLoading = false;
                if (error?.request?.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError(__('something_went_wrong'));
                }
            });
        },
        getCategories() {

            this.isLoading = true
            axios.get(this.$apiUrl + '/categories/main')
                .then((response) => {
                    this.isLoading = false
                    let data = response.data;
                    this.categories = data.data;
                }).catch(error => {
                this.isLoading = false;
                if (error?.request?.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError(__('something_went_wrong'));
                }
            });
        },

        setPlace(place) {
            this.currentPlace = place;
            this.addMarker()
        },
        addMarker() {
            if (this.currentPlace) {
                const marker = {
                    lat: this.currentPlace.geometry.location.lat(),
                    lng: this.currentPlace.geometry.location.lng(),
                    draggable:true,
                };
                this.markers.push({position: marker});
                this.center = marker;

                this.latitude = this.currentPlace.geometry.location.lat();
                this.longitude = this.currentPlace.geometry.location.lng();

                let addressArr = this.currentPlace.formatted_address.split(",");
                this.street = addressArr[0]+" "+addressArr[1];

                this.place_name = this.currentPlace.name;
                this.formatted_address = this.currentPlace.formatted_address;

                this.infoWindow.position = {lat: this.latitude, lng: this.longitude}
                this.infoWindow.template = `<b>${this.place_name}</b><br>${this.formatted_address}`
                this.infoWindow.open = true;
                this.currentPlace = null;
            }
        },

        getCurrentLocation(){
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition((position) => {
                    this.latitude = position.coords.latitude;
                    this.longitude = position.coords.longitude;
                    let latlng = new google.maps.LatLng(this.latitude, this.longitude);
                    this.mapConfig(latlng);
                });
            } else {
                this.showError("Geolocation is not supported by this browser.");
            }
        },
        handleMapClick(place){
            this.latitude = place.latLng.lat();
            this.longitude = place.latLng.lng();
            let latlng = place.latLng;
            this.mapConfig(latlng);
        },
        mapConfig(latlng){
            let vm = this;
            let geocoder = new google.maps.Geocoder;
            geocoder.geocode({'location': latlng}, function(results, status) {
                if (status === 'OK') {
                    if (results[1]) {
                        let clikedPlace = results[1];

                        let addressArr = clikedPlace.formatted_address.split(",");
                        vm.street = addressArr[0]+" "+addressArr[1];
                        vm.place_name = addressArr[1];
                        vm.formatted_address = clikedPlace.formatted_address;
                        vm.infoWindow.position = {lat: vm.latitude, lng: vm.longitude}
                        vm.infoWindow.template = `<b>${vm.place_name}</b><br>${vm.formatted_address}`
                        vm.infoWindow.open = true;
                        vm.currentPlace = null;

                        vm.markers = [];
                        const marker = {
                            lat: parseFloat(vm.latitude),
                            lng: parseFloat(vm.longitude),
                            draggable:true,
                        }
                        vm.markers.push({position: marker});
                        vm.center = marker;

                    } else {
                        console.warn('No results found');
                    }
                }
            });
        },

        updateCoordinates(location) {
            this.handleMapClick(location);
        },
        setCityId() {
            this.state = this.city.state;
            this.city_id = this.city.id;
        },
        handleFileStoreLogo() {
            this.store_logo = this.$refs.file_store_logo.files[0];
            this.store_logo_url = URL.createObjectURL(this.store_logo);
        },
        dropFileStoreLogo(event) {
            event.preventDefault();
            this.$refs.file_store_logo.files = event.dataTransfer.files;
            this.handleFileStoreLogo(); // Trigger the onChange event manually
            // Clean up
            event.currentTarget.classList.add('bg-gray-100');
            event.currentTarget.classList.remove('bg-green-300');
        },

        handleFileNationalIdCard() {
            this.national_id_card = this.$refs.file_national_id_card.files[0];
            this.national_id_card_url = URL.createObjectURL(this.national_id_card);
        },

        dropFileNationalIdCard(event) {
            event.preventDefault();
            this.$refs.file_national_id_card.files = event.dataTransfer.files;
            this.handleFileNationalIdCard(); // Trigger the onChange event manually
            // Clean up
            event.currentTarget.classList.add('bg-gray-100');
            event.currentTarget.classList.remove('bg-green-300');
        },

        handleFileAddressProof() {
            this.address_proof = this.$refs.file_address_proof.files[0];
            this.address_proof_url = URL.createObjectURL(this.address_proof);
            this.address_proof_name = this.address_proof.name;
        },
        dropFileAddressProof(event) {
            event.preventDefault();
            this.$refs.file_address_proof.files = event.dataTransfer.files;
            this.handleFileAddressProof(); // Trigger the onChange event manually
            // Clean up
            event.currentTarget.classList.add('bg-gray-100');
            event.currentTarget.classList.remove('bg-green-300');
        },

        getSeller() {
            axios.get(this.$apiUrl + '/sellers/edit/' + this.id)
                .then((response) => {
                    this.isLoading = false
                    let data = response.data;
                    if (data.status === 1) {

                        this.record = data.data
                        this.admin_id = this.record.admin.id ?? this.record.admin_id;
                        this.name = this.record.admin.username ?? this.record.name;
                        this.email = this.record.admin.email ?? this.record.email;

                        this.mobile = this.record.mobile;
                        this.store_url = this.record.store_url;

                        this.password = "";
                        this.confirm_password = "";

                        this.store_name = this.record.store_name;
                        this.street = this.record.street;
                        //this.pincode_id = (this.record.pincode_id == '' || this.record.pincode_id == 'NULL' )?"":this.record.pincode_id;
                        this.pincode_id = "";

                        this.city = this.cities.filter((item) => {
                            return item.id === this.record.city_id;
                        });
                        //console.log("this.city=>",this.city);

                        this.city_id = this.record.city_id;
                        this.categories_ids = this.record.categories?.split(",");
                        this.state = this.record.state;
                        this.remark = this.record.remark;
                        this.account_number = this.record.account_number;
                        this.ifsc_code = this.record.bank_ifsc_code;
                        this.bank_name = this.record.bank_name;
                        this.account_name = this.record.account_name;
                        this.commission = this.record.commission;
                        this.tax_name = this.record.tax_name;
                        this.tax_number = this.record.tax_number;
                        this.pan_number = this.record.pan_number;
                        this.latitude = this.record.latitude;
                        this.longitude = this.record.longitude;

                        this.place_name = this.record.place_name;
                        this.formatted_address = this.record.formatted_address;

                        this.store_description = this.record.store_description;
                        this.require_products_approval = this.record.require_products_approval;
                        this.customer_privacy = this.record.customer_privacy;
                        this.view_order_otp = this.record.view_order_otp;
                        this.assign_delivery_boy = this.record.assign_delivery_boy;
                        this.change_order_status_delivered = this.record.change_order_status_delivered;
                        this.status = this.record.status;
                        this.store_logo = this.record.store_logo;
                        /*this.national_id_card = this.record.national_id_card;
                        this.address_proof = this.record.address_proof;*/

                        this.store_logo_url = this.$storageUrl + this.record.logo;
                        this.national_id_card_url = this.$storageUrl + this.record.national_identity_card;
                        this.address_proof_url = this.$storageUrl + this.record.address_proof;


                        const marker = {
                            lat: parseFloat(this.latitude),
                            lng: parseFloat(this.longitude),
                            draggable:true,
                        }
                        this.markers.push({position: marker});
                        this.center = marker;

                        this.infoWindow.position = {lat: parseFloat(this.latitude), lng: parseFloat(this.longitude)}
                        this.infoWindow.template = `<b>${this.place_name}</b><br>${this.formatted_address}`
                        this.infoWindow.open = true;

                    } else {
                        this.showError(data.message);
                        setTimeout(() => {
                            this.$router.back();
                        }, 1000);
                    }
                }).catch(error => {
                    this.isLoading = false;
                    if (error?.request?.statusText) {
                        this.showError(error.request.statusText);
                    }else if (error.message) {
                        this.showError(error.message);
                    } else {
                        this.showError(__('something_went_wrong'));
                    }
                });
        },
        saveRecord: function () {
            this.isLoading = true;
            let vm = this;
            let formData = new FormData();
            if (this.id) {
                formData.append('id', this.id);
                formData.append('admin_id', this.admin_id);
            }
            formData.append('name', this.name);
            formData.append('email', this.email);
            formData.append('mobile', this.mobile);
            formData.append('store_url', this.store_url);
            formData.append('password', this.password);
            formData.append('confirm_password', this.confirm_password);
            formData.append('store_name', this.store_name);
            formData.append('street', this.street);
            formData.append('pincode_id', this.pincode_id);
            formData.append('city_id', this.city_id);
            formData.append('categories_ids', this.categories_ids);
            formData.append('state', this.state);
            formData.append('remark', this.remark);
            formData.append('account_number', this.account_number);
            formData.append('ifsc_code', this.ifsc_code);
            formData.append('bank_name', this.bank_name);
            formData.append('account_name', this.account_name);
            formData.append('commission', this.commission);
            formData.append('tax_name', this.tax_name);
            formData.append('tax_number', this.tax_number);
            formData.append('pan_number', this.pan_number);
            formData.append('latitude', this.latitude);
            formData.append('longitude', this.longitude);

            formData.append('place_name', this.place_name);
            formData.append('formatted_address', this.formatted_address);


            formData.append('store_description', this.store_description);
            formData.append('require_products_approval', this.require_products_approval);
            formData.append('customer_privacy', this.customer_privacy);
            formData.append('view_order_otp', this.view_order_otp);
            formData.append('assign_delivery_boy', this.assign_delivery_boy);
            formData.append('change_order_status_delivered', this.change_order_status_delivered);
            formData.append('status', this.status);
            formData.append('store_logo', this.store_logo);
            formData.append('national_id_card', this.national_id_card);
            formData.append('address_proof', this.address_proof);

            let url = this.$apiUrl + '/sellers/save';
            if (this.id) {
                url = this.$apiUrl + '/sellers/update';
            }
            axios.post(url, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(res => {
                let data = res.data;
                /*console.log("Response:");
                console.log(data);*/
                if (data.status === 1) {
                    setTimeout(
                        function () {
                            vm.$swal.close();
                            if(vm.$roleSeller === vm.login_user.role.name){
                                vm.$router.push({path: '/seller/profile'})
                            }else{
                                vm.$router.push({path: '/sellers'})
                            }
                            vm.isLoading = false;
                            //vm.showSuccess(data.message);
                            vm.showMessage("success", data.message);
                        }, 2000);
                } else {
                    vm.showError(data.message);
                    vm.isLoading = false;
                }
            }).catch(error => {
                if (error?.request?.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError(__('something_went_wrong'));
                }
                vm.isLoading = false;
            });
        }
    },
    mounted() {
        //this.geolocate();
        /*let vm = this;
        this.$refs.mapRef.$mapPromise.then((map) => {
            vm.map =  map;
            vm.drawingManager = new google.maps.drawing.DrawingManager({
                drawingMode: google.maps.drawing.OverlayType.POLYGON,
                drawingControl: true,
                drawingControlOptions: {
                    position: google.maps.ControlPosition.TOP_CENTER,
                    drawingModes: [google.maps.drawing.OverlayType.POLYGON,
                        google.maps.drawing.OverlayType.CIRCLE,]
                },

                polygonOptions: {
                    editable: true,
                },

                circleOptions: {
                    fillColor: '#666666',
                    fillOpacity: 0.5,
                    strokeWeight: 1,
                    clickable: true,
                    editable: true,
                    draggable: true,
                    zIndex: 1
                }
            });
            vm.drawingManager.setMap(vm.map);

            vm.markers = new google.maps.Marker({
                position: myLatLng,
                map: map,
                title: 'Google Maps',
                draggable: true
            });

            console.log("this =>",vm.markers);

            google.maps.event.addListener(vm.markers, "dragend", function (event) {
                var latLng = event.latLng;
                console.log("markers =>",latLng);
            });
        });*/
    }
};
</script>
<style scoped>
@import "../../../../node_modules/vue-multiselect/dist/vue-multiselect.min.css";
</style>
