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
                    <multiselect v-model="transactions.deliveryBoy"
                                 :options="deliveryBoys"
                                 :custom-label="customLabelOption"
                                 @close="checkAmount"
                                 placeholder="Select or search Delivery Boy"
                                 label="name"
                                 track-by="name" required>
                    </multiselect>
                    <div class="border border-grey rounded p-2 mt-2" v-if="transactions.deliveryBoy">
                        <div class="d-flex justify-content-between align-items-center text-left">
                            <span>Name:-</span><span> {{ transactions.deliveryBoy.name }}</span>
                            <span>Mobile:-</span><span> {{ transactions.deliveryBoy.mobile }}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center text-left">
                            <span>Id:-</span><span> {{ transactions.deliveryBoy.id }}</span>
                            <span>Cash:-</span><span> {{ transactions.deliveryBoy.cash_received }}</span>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="amount">Transfer Amount</label>
                    <input type="number" name="amount" id="amount" v-model="transactions.amount" v-on:keyup="checkAmount" required class="form-control" placeholder="Enter Transfer Amount">
                    <span class="text-danger" v-if="graterAmount === true">You Can not enter amount greater than balance.</span>
                </div>
                <div class="form-group">
                    <label for="transaction_date">Date & Time</label>
                    <input type="datetime-local" name="transaction_date" id="transaction_date" v-model="transactions.transaction_date" required class="form-control" placeholder="Select Date & Time.">
                </div>
                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea name="message" id="message" v-model="transactions.message" class="form-control" rows="3" placeholder="Enter Message." ></textarea>
                </div>
            </div>
            <button ref="dummy_submit" style="display:none;"></button>
        </form>
    </b-modal>
</template>

<script>
import axios from 'axios';
import Multiselect from 'vue-multiselect'
import moment from "moment";
export default {
    props: ['record','deliveryBoys'],
    components: {
        Multiselect
    },
    data : function(){
        return {
            isLoading: false,
            graterAmount:false,
            transactions:{
                id: this.record ? this.record.id : null ,
                deliveryBoy:null,
                amount: this.record ? this.record.amount : "" ,
                transaction_date: this.record ? this.record.transaction_date : moment(new Date()).format('YYYY-MM-DDThh:mm'),
                message: this.record ? this.record.message : "" ,
            },
        };
    },
    computed: {
        modal_title: function(){
            let title = this.id ? "Edit" : "Add" ;
            title += " Cash Collection";
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
        customLabelOption({id, name, mobile, cash_received}){
            return `Name:- ${name}  Cash:- ${cash_received}`
        },
        checkAmount(){
          if(parseInt(this.transactions.amount) > parseInt(this.transactions.deliveryBoy.cash_received)){
              this.graterAmount = true;
          }else{
              this.graterAmount = false;
          }
        },

        saveRecord: function(){
            let vm = this;
            this.isLoading = true;
            let formObject = this.transactions;
            let formData = new FormData();
            for(let key in formObject){
                if (key === 'deliveryBoy'){
                    formData.append(key, JSON.stringify(formObject[key]));
                }
                else{
                    formData.append(key, formObject[key]);
                }
            }
            let url = this.$apiUrl + '/cash_collection/save';
            if(this.transactions.id){
                url = this.$apiUrl + '/cash_collection/update';
            }
            axios.post(url, formData).then(res => {
                let data = res.data;
                if (data.status === 1) {
                    this.$eventBus.$emit('transactionsSaved', data.message);
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
@import "../../../../../node_modules/vue-multiselect/dist/vue-multiselect.min.css";
</style>
