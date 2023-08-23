<template>
    <b-modal ref="my-modal" :title="modal_title" @hidden="$emit('modalClose')" scrollable no-close-on-backdrop no-fade static>
        <div slot="modal-footer">
            <b-button variant="primary" @click="$refs['dummy_submit'].click()" :disabled="isLoading">Save
                <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
            </b-button>
            <b-button variant="secondary" @click="hideModal">Cancel</b-button>
        </div>
        <form ref="my-form" @submit.prevent="saveRecord">
            <div class="row">
                <div class="form-group">
                    <label>Type</label>
                    <select class="form-control form-select" v-model="type">
                        <option value="default">Default</option>
                        <option value="category">Category</option>
                        <option value="product">Product</option>
                        <option value="slider_url">Slider Url</option>
                    </select>
                </div>
                <div class="form-group" v-if="type=='category'">
                    <label>Category</label>
                    <select class="form-control form-select" v-model="type_id" >
                        <option value="">Select Category</option>
                        <option v-for="category in categories" :value="category.id">{{ category.name }}</option>
                    </select>
                </div>
                <div class="form-group" v-if="type=='product'">
                    <label>Products</label>
                    <select class="form-control form-select" v-model="type_id">
                        <option value="">Select Procduct</option>
                        <option v-for="product in products" :value="product.id">{{ product.name }}</option>
                    </select>
                </div>
                <div class="form-group" v-if="type=='slider_url'">
                    <label>Link</label>
                    <input type="url" class="form-control" v-model="slider_url" placeholder="Enter Link">
                </div>
                <div class="form-group">
                    <label>Image</label>
                    <p class="text-muted">Please choose square image of larger than 670px*370px & smaller than 1340px*740px.</p>
<!--                    <input type="file" name="slider_image" accept="image/*" v-on:change="handleFileUpload" ref="file_image" class="file-input" :required="!id">-->
                    <input type="file" name="slider_image" accept="image/*" v-on:change="handleFileUpload" ref="file_image" class="file-input">
                    <div class="file-input-div bg-gray-100" @click="$refs.file_image.click()" @drop="dropFile" @dragover="$dragoverFile" @dragleave="$dragleaveFile">

                        <template v-if="image && image.name !== ''">
                            <label>Selected file name:- {{ image.name }}</label>
                        </template>
                        <template v-else>
                            <label><i class="fa fa-cloud-upload fa-2x"></i></label>
                            <label>{{ __('drop_files_here_or_click_to_upload') }}</label>
                        </template>

                    </div>
                    <div class="row" v-if="image_url">
                        <div class="col-md-6">
                            <img class="custom-slider-image" :src="image_url" title='Store Logo' alt='Store Logo'/>
                        </div>
                    </div>
                </div>
                <div class="form-group" v-if="id">
                    <label>Status</label>
                    <div class="col-md-9 text-left mt-1">
                        <b-form-radio-group
                            v-model="status"
                            :options="[
                                { text: ' Deactivated', 'value': 0 },
                                { text: ' Activated', 'value': 1 },
                            ]"
                            buttons
                            button-variant="outline-primary"
                            required
                        ></b-form-radio-group>
                    </div>
                </div>
            </div>
            <button ref="dummy_submit" style="display:none;"></button>
        </form>
    </b-modal>
</template>

<script>
import axios from 'axios';

export default {
    props: ['record', 'categories', 'products'],
    data: function () {
        return {
            isLoading: false,
            image: null,
            id: this.record ? this.record.id : null,
            type: this.record ? this.record.type : 'default',
            type_id: this.record ? this.record.type_id : "",
            image_url: this.record ? this.record.image_url : null,
            slider_url: this.record ? this.record.slider_url : "",
            status: this.record ? this.record.status : 1,
        };
    },
    computed: {
        modal_title: function () {
            let title = this.id ? "Edit" : "Add";
            title += " Home Slider Image";
            return title;
        },
    },
    methods: {
        showModal() {
            this.$refs['my-modal'].show()
        },
        hideModal() {
            // console.log('hideModal');
            this.$refs['my-modal'].hide()

        },
        dropFile(event) {
            event.preventDefault();
            this.$refs.file_image.files = event.dataTransfer.files;
            this.handleFileUpload(); // Trigger the onChange event manually
            // Clean up
            event.currentTarget.classList.add('bg-gray-100');
            event.currentTarget.classList.remove('bg-green-300');
        },
        handleFileUpload() {
            this.image = this.$refs.file_image.files[0];
            this.image_url = URL.createObjectURL(this.image);
        },
        saveRecord: function () {
            let vm = this;
            this.isLoading = true;
            let formData = new FormData();
            if (this.id) {
                formData.append('id', this.id);
            }
            formData.append('type', this.type);
            formData.append('type_id', this.type_id);
            formData.append('image', this.image);
            formData.append('slider_url', this.slider_url);
            formData.append('status', this.status);
            let url = this.$apiUrl + '/home_slider_images/save';
            if (this.id) {
                url = this.$apiUrl + '/home_slider_images/update';
            }
            axios.post(url, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    this.$eventBus.$emit('SliderSaved', data.message);
                    vm.$router.push({path: '/home_sliders'});
                    this.hideModal();
                } else {
                    vm.showError(data.message);
                    vm.isLoading = false;
                }
            }).catch(error => {
                vm.isLoading = false;
                if (error.request.statusText) {
                    this.showError(error.request.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError(__('something_went_wrong'));
                }
            });
        }
    },
    mounted() {
        this.showModal();
    }
}
</script>

<style scoped>

</style>
