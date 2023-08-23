<template>
    <div class="auth">
        <div class="login-wrapper">
            <div class="auth-section">
                <div class="auth-back">
                    <router-link to="/delivery_boy/login"><span class="fa fa-arrow-left"></span></router-link>
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
                    <h4>Delivery Boy Register</h4>
                    <p class="auth-subtitle text-primary">Input your data to register to our website.</p>
                    <form ref="my-form" @submit.prevent="registerDeliveryBoy">

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input type="text" class="form-control form-control-xl" placeholder="Username"
                                   v-model.trim="$v.delivery_boy.username.$model">
                            <div class="form-control-icon">
                                <i class="bi bi-person"></i>
                            </div>
                            <template v-if="$v.delivery_boy.username.$error">
                                <span class="text-danger" v-if="!$v.delivery_boy.username.required">Username is required</span>
                            </template>
                        </div>

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input type="email" class="form-control form-control-xl" placeholder="Email"
                                   v-model.trim="$v.delivery_boy.email.$model">
                            <div class="form-control-icon">
                                <i class="bi bi-envelope"></i>
                            </div>
                            <template v-if="$v.delivery_boy.email.$error">
                                <span class="text-danger" v-if="!$v.delivery_boy.email.required">Email is required</span>
                                <span class="text-danger" v-if="!$v.delivery_boy.email.email">Email is invalid</span>
                            </template>
                        </div>

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input type="number" class="form-control form-control-xl" placeholder="Mobile"
                                   v-model.trim="$v.delivery_boy.mobile.$model">
                            <div class="form-control-icon">
                                <i class="bi bi-phone"></i>
                            </div>

                            <template v-if="$v.delivery_boy.mobile.$error">

                                <span class="text-danger" v-if="!$v.delivery_boy.mobile.numeric">Please enter a valid number.</span>
                                <span class="text-danger" v-if="!$v.delivery_boy.mobile.onlyDigits">Enter only digits</span>
                                <span class="text-danger" v-if="!$v.delivery_boy.mobile.required">Mobile number is required</span>
                                <span class="text-danger" v-if="!$v.delivery_boy.mobile.minLength">Mobile number must have at least {{ $v.delivery_boy.mobile.$params.minLength.min }} digits.</span>
                            </template>
                        </div>

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input :type="showPassword ? 'text' : 'password'" class="form-control form-control-xl" placeholder="Password"
                                   v-model.trim="$v.delivery_boy.password.$model">
                            <div class="form-control-icon">
                                <i class="bi bi-shield-lock"></i>
                            </div>
                            <button type="button" v-on:click="showPassword = !showPassword"
                                    class="btn btn-sm btn-outline-light font-bold text-primary"
                                    style="margin-top: -45px;position: absolute; right: 10px;" >
                                {{ showPassword ? 'Hide' : 'Show' }}
                            </button>
                            <template v-if="$v.delivery_boy.password.$error">
                                <span class="text-danger" v-if="!$v.delivery_boy.password.required">Password is required</span>
                                <span class="text-danger" v-if="!$v.delivery_boy.password.minLength">Password must have at least {{ $v.delivery_boy.password.$params.minLength.min }} letters.</span>
                            </template>
                        </div>

                        <div class="form-group position-relative has-icon-left mb-4">
                            <input :type="showConfirmPassword ? 'text' : 'password'" class="form-control has-icon-left form-control-xl"
                                   placeholder="Confirm Password"
                                   v-model.trim="$v.delivery_boy.password_confirmation.$model">
                            <div class="form-control-icon">
                                <i class="bi bi-lock"></i>
                            </div>
                            <button type="button" v-on:click="showConfirmPassword = !showConfirmPassword"
                                    class="btn btn-sm btn-outline-light font-bold text-primary"
                                    style="margin-top: -45px;position: absolute; right: 10px;" >
                                {{ showConfirmPassword ? 'Hide' : 'Show' }}
                            </button>
                            <template v-if="$v.delivery_boy.password_confirmation.$error">
                                <span class="text-danger" v-if="!$v.delivery_boy.password_confirmation.sameAsPassword">Passwords must be identical.</span>
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
import { required, numeric, email, sameAs, minLength, helpers } from 'vuelidate/lib/validators';
const onlyDigits = helpers.regex('onlyDigits', /^\d+$/);

export default {
    data: function () {
        return {
            isLoading: false,
            showPassword: false,
            showConfirmPassword:false,
            delivery_boy: {
                username: '',
                email: '',
                mobile: '',
                password: '',
                password_confirmation: '',
            },
            submitStatus: null,
            loggedUser: Auth.user
        };
    },
    validations: {

        delivery_boy: {
            username: { required },
            email: { required, email },
            mobile: { required, numeric, minLength: minLength(8), onlyDigits },
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
        registerDeliveryBoy: function () {
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

                    let url = this.$apiUrl + '/delivery_boy/register';
                    axios.post(url, this.delivery_boy).then(res => {
                        vm.isLoading = false;
                        let data = res.data;
                        if (data.status === 1) {
                            this.submitStatus = 'SUCCESS'
                            this.showMessage("success", data.message);
                            setTimeout(() => {
                                this.$router.push('/delivery_boy/login');
                            }, 1000);

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
                            this.showError(__('something_went_wrong'));
                        }
                    });

                }, 500)
            }
        }
    }
}
</script>

