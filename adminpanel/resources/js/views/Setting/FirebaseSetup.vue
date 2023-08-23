<template>
    <div>
        <div class="page-heading">
            <div class="page-title">
                <div class="row">
                    <div class="col-12 col-md-6 order-md-1 order-last">
                        <h3>Firebase Settings</h3>
                    </div>
                    <div class="col-12 col-md-6 order-md-2 order-first">
                        <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><router-link to="/dashboard">{{ __('dashboard') }}</router-link></li>
                                <li class="breadcrumb-item active" aria-current="page">Firebase Settings</li>
                            </ol>
                        </nav>
                    </div>
                </div>
            </div>
            <section class="section">
                <form id="api_key_form" method="post" enctype="multipart/form-data" @submit.prevent="saveRecord">
                    <div class="card">
                        <div class="card-header">
                            <h4 class="card-title">Firebase Setup & Keys</h4>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <label><span class="text-danger text-xs">*</span> Required fields.</label>
                                <div class="divider"><div class="divider-text">Firebase Setup & Keys Form</div></div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="apiKey">apiKey<span class="text-danger text-xs">*</span></label>
                                        <input type="text" class="form-control" name="apiKey" id="apiKey" v-model="firebase.apiKey" placeholder="Enter api key.">
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="authDomain">authDomain<span class="text-danger text-xs">*</span></label>
                                        <input type="text" class="form-control" name="authDomain" id="authDomain" v-model="firebase.authDomain" placeholder="Enter aith domain.">
                                    </div>
                                </div>

<!--                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="databaseURL">databaseURL</label>
                                        <input type="text" class="form-control" name="databaseURL" id="databaseURL" v-model="firebase.databaseURL" placeholder="Enter database URL.">
                                    </div>
                                </div>-->

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="projectId">projectId <span class="text-danger text-xs">*</span></label>
                                        <input type="text" class="form-control" name="projectId" id="projectId" v-model="firebase.projectId" placeholder="Enter project id.">
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="storageBucket">storageBucket<span class="text-danger text-xs">*</span></label>
                                        <input type="text" class="form-control" name="storageBucket" id="storageBucket" v-model="firebase.storageBucket" placeholder="Enter storage bucket.">
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="messagingSenderId">messagingSenderId <span class="text-danger text-xs">*</span></label>
                                        <input type="text" class="form-control" name="messagingSenderId" id="messagingSenderId" v-model="firebase.messagingSenderId" placeholder="Enter messaging sender id.">
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="appId">appId <span class="text-danger text-xs">*</span></label>
                                        <input type="text" class="form-control" name="appId" id="appId" v-model="firebase.appId" placeholder="Enter app id.">
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="measurementId">measurementId<span class="text-danger text-xs">*</span></label>
                                        <input type="text" class="form-control" name="measurementId" id="measurementId" v-model="firebase.measurementId" placeholder="Enter measurement id.">
                                    </div>
                                </div>



                                <div class="divider">
                                    <div class="divider-text">Firebase Json file upload</div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="jsonFile">Firebase Json file</label>
                                        <input type="file" name="jsonFile" id="jsonFile" ref="jsonFile" v-on:change="handleFileUpload" class="form-control" accept=".json"/>
                                    </div>
                                </div>

                            </div>

                        </div>
                        <div class="card-footer">
                            <b-button type="submit" variant="primary" :disabled="isLoading">Update
                                <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
                            </b-button>
                        </div>
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
            isLoading: false,

            editorConfig: {},
            firebase: {
                apiKey:"",
                authDomain:"",
                databaseURL:"",
                projectId:"",
                storageBucket:"",
                messagingSenderId:"",
                appId:"",
                measurementId:"",
                jsonFile:""
            },
            record: null
        }
    },
    created: function () {
        if(this.$isDemo != 1) {
            this.getFirebaseData();
        }
    },
    methods: {
        getFirebaseData() {
            axios.get(this.$apiUrl + '/firebase').then((response) => {
                if(response.data.data) {
                    this.record = response.data.data;
                    this.record.map((item, index) => {
                        if (item.value === '0' || item.value === '1') {
                            this.firebase[item.variable] = (item.value === '0') ? 0 : 1;
                        } else {
                            this.firebase[item.variable] = item.value;
                        }
                    });
                }
            }).catch(error => {
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError(__('something_went_wrong'));
                }
            });
        },

        handleFileUpload() {
            this.firebase.jsonFile = this.$refs.jsonFile.files[0];
            this.image_url = URL.createObjectURL(this.image);
        },

        saveRecord: function(){
            this.isLoading = true;

            let object = this.firebase;
            let formData = new FormData();
            for (let key in object) {
                formData.append(key, object[key]);
            }
            //console.log('formData => ',Object.fromEntries(formData));

            let url = this.$apiUrl + '/firebase/save';
            let vm = this;

            axios.post(url, formData).then(res => {

                let data = res.data;
                if (data.status === 1) {
                    //this.showSuccess(data.message);
                    this.showMessage("success", data.message);
                    setTimeout(
                        function() {
                            vm.$swal.close();
                            // vm.$router.push({path:'/firebase'}).catch(err => {});
                            vm.$router.push({path:'/firebase'});
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
                vm.isLoading = true;
            });

        }
    }
}
</script>
