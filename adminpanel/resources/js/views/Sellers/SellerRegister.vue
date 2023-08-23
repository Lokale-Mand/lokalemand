<template>
    <div class="auth">
        <div class="login-wrapper">
            <div class="auth-section">
                <div class="auth-back">
                    <router-link to="/seller/login"><span class="fa fa-arrow-left"></span></router-link>
                </div>
                <div class="auth-card">
                    <div class="auth-logo">
                        <a href="javascript:void(0)"
                           style="display: flex; align-items: center; justify-content: flex-start;">
                            <img v-if="$appLogo != ''" :src="$storageUrl+$appLogo" style="height: 70px; width: 70px;"
                                 alt='Logo'/>
                            <img v-else :src="$baseUrl + '/images/logo.png'" style="height: 70px; width: 70px;"
                                 alt='Logo'/>
                            <h2 style="margin: 10px;">{{ $appName }}</h2>
                        </a>
                    </div>
                    <h4>Seller Register</h4>
                    <p class="auth-subtitle text-primary">Input your data to register to our website.</p>
                    <form ref="my-form" @submit.prevent="registerSeller">

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input type="text" class="form-control form-control-xl" placeholder="Username"
                                    v-model.trim="$v.seller.username.$model">
                            <div class="form-control-icon">
                                <i class="bi bi-person"></i>
                            </div>

                            <template v-if="$v.seller.username.$error">
                                <span class="text-danger" v-if="!$v.seller.username.required">Username is required</span>
                            </template>

                        </div>

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input type="text" class="form-control form-control-xl" placeholder="Store Name"
                                   v-model.trim="$v.seller.store_name.$model">
                            <div class="form-control-icon">
                                <i class="bi bi-shop-window"></i>
                            </div>
                            <template v-if="$v.seller.store_name.$error">
                                <span class="text-danger" v-if="!$v.seller.store_name.required">Store Name is required</span>
                            </template>
                        </div>

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input type="email" class="form-control form-control-xl" placeholder="Email"
                                   v-model="seller.email">
                            <div class="form-control-icon">
                                <i class="bi bi-envelope"></i>
                            </div>
                            <template v-if="$v.seller.email.$error">
                                <span class="text-danger" v-if="!$v.seller.email.required">Email is required</span>
                                <span class="text-danger" v-if="!$v.seller.email.email">Email is invalid</span>
                            </template>
                        </div>

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input type="text" class="form-control form-control-xl" placeholder="Mobile"
                                   v-model.trim="$v.seller.mobile.$model">
                            <div class="form-control-icon">
                                <i class="bi bi-phone"></i>
                            </div>
                            <template v-if="$v.seller.mobile.$error">
                                <span class="text-danger" v-if="!$v.seller.mobile.required">Mobile number is required</span>
                                <span class="text-danger" v-if="!$v.seller.mobile.numeric">Please enter a valid number</span>
                            </template>
<!--                            <span v-if="!$v.seller.mobile.$dirty && !$v.seller.mobile.required">*</span>
                            <span v-if="!$v.seller.mobile.numeric">Please enter a valid number</span>-->


                        </div>

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input :type="showPassword ? 'text' : 'password'" class="form-control form-control-xl" placeholder="Password"
                                   v-model.trim="$v.seller.password.$model">
                            <div class="form-control-icon">
                                <i class="fa bi-shield-lock"></i>
                            </div>
                            <button type="button" v-on:click="showPassword = !showPassword"
                                    class="btn btn-sm btn-outline-light font-bold text-primary"
                                    style="margin-top: -45px;position: absolute; right: 10px;" >
                                {{ showPassword ? 'Hide' : 'Show' }}
                            </button>

                            <template v-if="$v.seller.password.$error">
                                <span class="text-danger" v-if="!$v.seller.password.required">Password is required</span>
                                <span class="text-danger" v-if="!$v.seller.password.minLength">Password must have at least {{ $v.seller.password.$params.minLength.min }} letters.</span>
                            </template>
                        </div>

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input :type="showConfirmPassword ? 'text' : 'password'" class="form-control form-control-xl" placeholder="Confirm Password"
                                   v-model.trim="$v.seller.password_confirmation.$model">
                            <div class="form-control-icon">
                                <i class="bi bi-lock"></i>
                            </div>
                            <button type="button" v-on:click="showConfirmPassword = !showConfirmPassword"
                                    class="btn btn-sm btn-outline-light font-bold text-primary"
                                    style="margin-top: -45px;position: absolute; right: 10px;" >
                                {{ showConfirmPassword ? 'Hide' : 'Show' }}
                            </button>

                            <template v-if="$v.seller.password_confirmation.$error">
                                <span class="text-danger" v-if="!$v.seller.password_confirmation.sameAsPassword">Passwords must be identical.</span>
                            </template>
                        </div>

                        <button class="btn btn-primary btn-block btn-lg shadow-lg mt-3 mb-2"
                                :disabled="submitStatus === 'PENDING'">
                            Sign Up
                            <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
                        </button>

                        <div class="alert alert-light-danger color-danger text-danger" v-if="submitStatus === 'ERROR'">
                            <h6 class="alert-heading"><i class="fa fa-exclamation-circle"></i> {{ submitStatus }}</h6>
                            <p> Please fill the form correctly.</p>
                        </div>

                        <div class="alert alert-light-warning color-warning text-warning" v-if="submitStatus === 'PENDING'">
                            <h6 class="alert-heading"><i class="fa fa-exclamation-triangle"></i> {{ submitStatus }}</h6>
                            <p><b-spinner small label="Spinning"></b-spinner> Sending...</p>
                        </div>

                        <div class="alert alert-light-success color-success text-success" v-if="submitStatus === 'SUCCESS'">
                            <h6 class="alert-heading"><i class="fa fa-check-circle"></i> {{ submitStatus }}</h6>
                            <p>Thanks for your submission!</p>
                        </div>

                    </form>
                    <div class="auth-copyright">
<!--                        <a href="javascript:void(0)" class="text-primary font-weight-normal"> @ 2022 eGrocer. All Right
                            Reserved</a>-->
                        <a href="javascript:void(0)" class="text-primary font-weight-normal"> {{ $copyrightDetails }}</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import axios from 'axios';
import Auth from '../../Auth.js';
import { required, numeric, email, sameAs, minLength } from 'vuelidate/lib/validators';

export default {
    data: function () {
        return {
            isLoading: false,
            showPassword: false,
            showConfirmPassword:false,
            seller: {
                username: '',
                email: '',
                mobile: '',
                store_name: '',
                password: '',
                password_confirmation: '',
            },
            submitStatus: null,
            loggedUser: Auth.user
        };
    },

    validations: {
        seller: {
            username: { required },
            store_name: { required },
            email: { required, email },
            mobile: { required, numeric },
            password: { required, minLength: minLength(6) },
            password_confirmation: { sameAsPassword: sameAs('password') }
        }
    },

    mounted() {
        if (this.loggedUser) {
            this.$router.push('/dashboard');
        }
    },
    methods: {
        registerSeller: function () {
            let vm = this;
            this.isLoading = true;

            console.log('submit!');
            this.$v.$touch();
            if (this.$v.$invalid) {
                this.submitStatus = 'ERROR'
                vm.isLoading = false;
            } else {
                // do your submit logic here
                this.submitStatus = 'PENDING'
                setTimeout(() => {


                    let url = this.$apiUrl + '/seller/register';
                    axios.post(url, this.seller).then(res => {
                        vm.isLoading = false;
                        let data = res.data;
                        if (data.status === 1) {

                            this.submitStatus = 'SUCCESS'

                            this.showMessage("success", data.message);
                            setTimeout(() => {
                                this.$router.push('/seller/login');
                            }, 2000);


                        } else {
                            this.submitStatus = null;
                            vm.showError(data.message);
                        }

                    }).catch(error => {
                        console.log(error)
                        this.submitStatus = null;
                        vm.isLoading = false;
                        if (error.request.statusText) {
                            this.showError(error.request.statusText);
                        } else if (error.message) {
                            this.showError(error.message);
                        } else {
                            this.showError("Something went wrong!");
                        }
                    });


                }, 500)
            }

        }
    }
}
</script>

