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
                    <label for="offer_image">Offer Image <i class="text-danger">*</i></label>
                    <input type="file" name="offer_image" accept="image/*" id="offer_image" v-on:change="handleFileUpload" ref="file_image" class="file-input">

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
                        <div class="col-md-2">
                            <img class="custom-image" :src="image_url" title='Offer Image' alt='Offer Image'/>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="position">Position <i class="text-danger">*</i></label>
                    <select name="position" id="position" v-model="position" class="form-control form-select">
                        <option value="top">Top</option>
                        <option value="below_slider">Below Slider</option>
                        <option value="below_category">Below Category</option>
                        <option value="below_section">Below Section</option>
                        <!-- <option value="below_seller">Below Seller</option> -->
                    </select>
                </div>

                <div class="form-group" v-if="position === 'below_section'">
                    <label for="section_id">Section Position <i class="text-danger">*</i></label>
                    <select name="section_id" id="section_id" v-model="section_id" class="form-control form-select">
                        <option value="">Select Section</option>
                        <option v-for="section in sections" :value="section.id">{{section.title}}</option>
                    </select>
                </div>
            </div>
            <button ref="dummy_submit" style="display:none;"></button>
        </form>
    </b-modal>
</template>

<script>
import axios from 'axios';

export default {
    props: ['record','sections'],
    data : function(){
        return {
            isLoading: false,
            id: this.record ? this.record.id : null ,
            image: this.record ? this.record.image : "" ,
            image_url: this.record ? this.record.image : "" ,
            position: this.record ? this.record.position : "top",
            section_id: this.record ? this.record.section_id : ""
        };
    },
    computed: {
        modal_title: function(){
            let title = this.id ? "Edit" : "Add" ;
            title += " New Offers Images here";
            return title;
        },
    },
    methods: {
        showModal() {
            this.$refs['my-modal'].show()
        },
        hideModal() {
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
        saveRecord: function(){
            let vm = this;
            this.isLoading = true;
            let formData = new FormData();
            if(this.id) {
                formData.append('id', this.id);
            }
            formData.append('image', this.image);
            formData.append('position', this.position);
            formData.append('section_id', this.section_id);
            let url = this.$apiUrl + '/offers/save';
            if(this.id){
                url = this.$apiUrl + '/offers/update';
            }
            axios.post(url, formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    this.$eventBus.$emit('offerSaved', data.message);
                    vm.$router.push({path: '/offers'});
                    this.hideModal();
                }else{
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
    mounted(){
        this.showModal();
    }
}
</script>

<style scoped>

/*.image_preview{
    margin-top: 5px;
}*/
</style>
