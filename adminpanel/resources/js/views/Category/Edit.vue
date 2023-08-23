<template>
    <b-modal ref="my-modal" :title="modal_title" @hidden="$emit('modalClose')" scrollable no-close-on-backdrop no-fade static>
        <div slot="modal-footer">
            <b-button variant="primary" @click="$refs['dummy_submit'].click()" :disabled="isLoading">{{ __('save') }}
                <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
            </b-button>
            <b-button variant="secondary" @click="hideModal">{{ __('cancel') }}</b-button>
        </div>
        <form ref="my-form" @submit.prevent="saveRecord">
            <div class="row">
                <div class="form-group">
                    <label>{{ __("parent_category") }}</label>
                    <select class="form-control form-select" v-model="parent_id" required>
                        <option value="0">{{ __('main_category') }}</option>
                        <option v-for="category in categories" :value="category.id">{{ category.name }}</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>{{ __('category_name') }}</label>
                    <input type="text" class="form-control" required v-model="name" :placeholder="__('enter_category_name')">
                </div>
                <div class="form-group">
                    <label>{{ __('category_subtitle') }}</label>
                    <input type="text" class="form-control" required v-model="subtitle" :placeholder="__('enter_category_subtitle')">
                </div>
                <div class="form-group">
                    <label>{{ __('image') }}</label>
                    <p class="text-muted">Please choose square image of larger than 350px*350px &amp; smaller than 550px*550px.</p>



<!--                    <input type="file" name="category_image" accept="image/*" v-on:change="handleFileUpload" ref="file_image" required v-if="!id" class="file-input">
                    <input type="file" name="category_image"  v-on:change="handleFileUpload" ref="file_image" v-if="id" class="file-input">-->
<!--                    <input type="file" name="category_image" v-on:change="handleFileUpload" ref="file_image" :required="!id" class="file-input">-->

                    <input type="file" name="category_image" accept="image/*" v-on:change="handleFileUpload" ref="file_image" class="file-input">
                    <div class="file-input-div bg-gray-100" @click="$refs.file_image.click()" @drop="dropFile" @dragover="$dragoverFile" @dragleave="$dragleaveFile">

<!--                        <label><i class="fa fa-cloud-upload fa-2x"></i></label>
                        <label>{{ __('drop_files_here_or_click_to_upload') }}</label>-->
<!--                        <label>Drop Files here or click to upload</label>-->


                        <template v-if="image && image.name !== ''">
                            <label>Selected file name:- {{ image.name }}</label>
                        </template>
                        <template v-else>
                            <label><i class="fa fa-cloud-upload fa-2x"></i></label>
                            <label>{{ __('drop_files_here_or_click_to_upload') }}</label>
                        </template>

                    </div>
                    <div class="row" v-if="image_url">
                        <div class="col-md-4">
                            <img class="custom-image" :src="image_url" title='Category Image' alt='Category Image'/>
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
    props: ['record', 'categories'],
    data: function () {
        return {
            isLoading: false,
            image: null,

            id: this.record ? this.record.id : null,
            name: this.record ? this.record.name : null,
            subtitle: this.record ? this.record.subtitle : null,
            image_url: this.record ? this.record.image_url : null,
            status: this.record ? this.record.status : 1,
            parent_id: this.record ? this.record.parent_id : 0,
        };
    },
    computed: {
        modal_title: function () {
            let title = this.id ? __('edit_category') : __('add_category');
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
        // this function is add in app.js for gloable.
        /*dragoverFile(event) {
            event.preventDefault();
            // Add some visual fluff to show the user can drop its files
            if (!event.currentTarget.classList.contains('bg-green-300')) {
                event.currentTarget.classList.remove('bg-gray-100');
                event.currentTarget.classList.add('bg-green-300');
            }
        },
        dragleaveFile(event) {
            // Clean up
            event.currentTarget.classList.add('bg-gray-100');
            event.currentTarget.classList.remove('bg-green-300');
        },*/
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
            /*let postData = {
                id: this.id,
                name: this.name,
                subtitle: this.subtitle,
                image: this.image,
            };*/

            let formData = new FormData();
            if (this.id) {
                formData.append('id', this.id);
            }
            formData.append('name', this.name);
            formData.append('subtitle', this.subtitle);
            formData.append('image', this.image);
            formData.append('status', this.status);
            formData.append('parent_id', this.parent_id);
            let url = this.$apiUrl + '/categories/save';

            if (this.id) {
                url = this.$apiUrl + '/categories/update';
            }

            axios.post(url, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(res => {
                let data = res.data;
                console.log("Response:");
                console.log(data);
                if (data.status === 1) {
                    console.log('Response : Success');
                    /*vm.$eventBus.$emit('categorySaved', data.message);
                    vm.hideModal();*/
                    vm.$eventBus.$emit('categorySaved', data.message);
                    vm.hideModal();
                    vm.$router.push({path: '/manage_categories'});
                    /*if(this.id) {
                        vm.$eventBus.$emit('categorySaved', data.message, data.plan);
                    }else{
                        vm.$eventBus.$emit('planCreated', data.message, data.plan);
                    }*/

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

.image_preview {
    margin-top: 5px;
}
</style>
