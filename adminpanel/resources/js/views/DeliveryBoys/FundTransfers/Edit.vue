<template>
    <b-modal ref="my-modal" :title="modal_title" @hidden="$emit('modalClose')" scrollable no-close-on-backdrop no-fade static>
        <div slot="modal-footer">
            <b-button variant="primary" @click="$refs['dummy_submit'].click()" :disabled="isLoading || (graterAmount === true) ">Save
                <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
            </b-button>
            <b-button variant="secondary" @click="hideModal">Cancel</b-button>
        </div>
        <form ref="my-form" @submit.prevent="saveRecord">
            <div class="row">
                <div class="form-group">
                    <label>Delivery Boy</label>
                    <multiselect v-model="fundTransfers.deliveryBoy"
                                 :options="deliveryBoys"
                                 :custom-label="customLabelOption"
                                 @close="checkAmount"
                                 placeholder="Select & Search Delivery Boy"
                                 label="name"
                                 track-by="name" required>
                    </multiselect>
                    <div class="border border-grey rounded p-2 mt-2" v-if="fundTransfers.deliveryBoy">
                        <div class="d-flex justify-content-between align-items-center text-left">
                            <span>Name:-</span><span> {{ fundTransfers.deliveryBoy.name }}</span>
                            <span>Mobile:-</span><span> {{ fundTransfers.deliveryBoy.mobile }}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center text-left">
                            <span>Id:-</span><span> {{ fundTransfers.deliveryBoy.id }}</span>
                            <span>Balance:-</span><span> {{ fundTransfers.deliveryBoy.balance }}</span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="amount">Transfer Amount</label>
                    <input type="number" name="amount" id="amount" v-model="fundTransfers.amount" v-on:keyup="checkAmount" required class="form-control" placeholder="Enter Transfer Amount">
                    <span class="text-danger" v-if="graterAmount === true">You Can not enter amount greater than balance.</span>
                </div>
                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea name="message" id="message" v-model="fundTransfers.message" class="form-control" rows="3" placeholder="Enter Message." ></textarea>
                </div>
            </div>
            <button ref="dummy_submit" style="display:none;"></button>
        </form>
    </b-modal>
</template>

<script>
import axios from 'axios';
import Multiselect from 'vue-multiselect'
export default {
    props: ['record','deliveryBoys'],
    components: {
        Multiselect
    },
    data : function(){
        return {
            isLoading: false,
            graterAmount:false,
            fundTransfers:{
                id: this.record ? this.record.id : null ,
                deliveryBoy:null,
                amount: this.record ? this.record.amount : "" ,
                message: this.record ? this.record.message : "" ,
            },

        };
    },
    computed: {
        modal_title: function(){
            let title = this.id ? "Edit" : "Add" ;
            title += " Fund Transfer";
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
        customLabelOption({id, name, mobile, balance}){
            return `Name:-${name}  Balance:-${balance}`
        },
        checkAmount(){
          if(parseInt(this.fundTransfers.amount) > parseInt(this.fundTransfers.deliveryBoy.balance)){
              this.graterAmount = true;
          }else{
              this.graterAmount = false;
          }
        },

        saveRecord: function(){
            let vm = this;
            this.isLoading = true;
            let formObject = this.fundTransfers;
            let formData = new FormData();
            for(let key in formObject){
                if (key === 'deliveryBoy'){
                    formData.append(key, JSON.stringify(formObject[key]));
                }
                else{
                    formData.append(key, formObject[key]);
                }
            }
            let url = this.$apiUrl + '/fund_transfers/save';
            if(this.fundTransfers.id){
                url = this.$apiUrl + '/fund_transfers/update';
            }
            axios.post(url, formData).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    this.$eventBus.$emit('fundTransfersSaved', data.message);
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
/*@import url(../../../../node_modules/vue-multiselect/dist/vue-multiselect.min.css);*/
@import "../../../../../node_modules/vue-multiselect/dist/vue-multiselect.min.css";
</style>
