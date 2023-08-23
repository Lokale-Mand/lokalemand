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

                        <!--<b-form-radio-group
                            v-model="withdrawalRequest.status"
                            :options="[
                                { text: ' Pending', 'value': 0 },
                                { text: ' Approved', 'value': 1 },
                                { text: ' Cancelled', 'value': 2 },
                            ]"
                            buttons
                            button-variant="outline-primary"
                            required
                        ></b-form-radio-group>-->

                        <div id="status" class="btn-group">
                            <label class="btn btn-warning" data-toggle-class="btn-warning" data-toggle-passive-class="btn-default">
                                <input type="radio" v-model="withdrawalRequest.status" value="0" class="form-check-input" > Pending
                            </label>
                            <label class="btn btn-success" data-toggle-class="btn-success" data-toggle-passive-class="btn-default">
                                <input type="radio" v-model="withdrawalRequest.status" value="1" class="form-check-input"> Approved
                            </label>
                            <label class="btn btn-danger" data-toggle-class="btn-danger" data-toggle-passive-class="btn-default">
                                <input type="radio" v-model="withdrawalRequest.status" value="2" class="form-check-input"> Rejected
                            </label>
                        </div>
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
            withdrawalRequest:{
                id: this.record ? this.record.id : null ,
                status: this.record ? this.record.status : "" ,
            },
        };
    },
    computed: {
        modal_title: function(){
            let title = this.withdrawalRequest.id ? "Edit" : "Add" ;
            title += " Withdrawal Request";
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
            let formObject = this.withdrawalRequest;
            let formData = new FormData();
            for(let key in formObject){
                formData.append(key, formObject[key]);
            }
            let url = this.$apiUrl + '/withdrawal_requests/save';
            if(this.withdrawalRequest.id){
                url = this.$apiUrl + '/withdrawal_requests/update';
            }
            axios.post(url, formData).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    this.$eventBus.$emit('withdrawalRequestSaved', data.message);
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
