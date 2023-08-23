<template>
    <b-modal ref="my-modal" :title="modal_title" @hidden="$emit('modalClose')" no-fade static>
        <div slot="modal-footer">
            <b-button variant="primary" @click="$refs['dummy_submit'].click()" :disabled="isLoading">Save
                <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
            </b-button>
            <b-button variant="secondary" @click="hideModal">Cancel</b-button>
        </div>
        <form ref="my-form" @submit.prevent="saveRecord">
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label for="status" >Status</label><br>
                        <div id="status" class="btn-group">
                            <label class="btn btn-warning" data-toggle-class="btn-warning" data-toggle-passive-class="btn-default">
                                <input type="radio" v-model="returnRequest.status" value="0" class="form-check-input" > Pending
                            </label>
                            <label class="btn btn-success" data-toggle-class="btn-success" data-toggle-passive-class="btn-default">
                                <input type="radio" v-model="returnRequest.status" value="1" class="form-check-input"> Approved
                            </label>
                            <label class="btn btn-danger" data-toggle-class="btn-danger" data-toggle-passive-class="btn-default">
                                <input type="radio" v-model="returnRequest.status" value="2" class="form-check-input"> Cancelled
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="remark">Remark</label>
                        <textarea name="remark" id="remark" v-model="returnRequest.remark" required class="form-control" placeholder="Enter Remark">
                        </textarea>
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
    props: ['record'],
    data : function(){
        return {
            isLoading: false,
            returnRequest:{
                id: this.record ? this.record.id : null ,
                status: this.record ? this.record.status : "" ,
                remark: this.record ? this.record.remarks : "" ,
            },
        };
    },
    computed: {
        modal_title: function(){
            let title = this.returnRequest.id ? "Edit" : "Add" ;
            title += " Return Request";
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

        saveRecord: function(){
            let vm = this;
            this.isLoading = true;
            let formObject = this.returnRequest;
            let formData = new FormData();
            for(let key in formObject){
                formData.append(key, formObject[key]);
            }
            let url = this.$apiUrl + '/return_requests/save';
            if(this.returnRequest.id){
                url = this.$apiUrl + '/return_requests/update';
            }
            axios.post(url, formData).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    this.$eventBus.$emit('returnRequestSaved', data.message);
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
                    this.showError("Something went wrong!");
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
