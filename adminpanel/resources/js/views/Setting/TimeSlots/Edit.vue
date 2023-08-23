<template>
   <b-modal ref="my-modal" :title="modal_title" @hidden="$emit('modalClose')" no-fade static>
      <div slot="modal-footer">
         <b-button variant="primary" @click="$refs['dummy_submit'].click()" :disabled="isLoading">
            Save
            <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
         </b-button>
         <b-button variant="secondary" @click="hideModal">Cancel</b-button>
      </div>
      <form ref="my-form" @submit.prevent="saveRecord">
         <div class="row">
            <div class="form-group">
               <label>Title</label>
               <input type="text" class="form-control" required v-model="title" placeholder="Morning 9AM to 12PM">
            </div>
            <div class="form-group">
               <label>From Time <small>(24 hrs format)</small></label>
               <input type="time" class="form-control" required v-model="from_time">
            </div>
            <div class="form-group">
               <label>To Time <small>(24 hrs format)</small></label>
               <input type="time" class="form-control" required v-model="to_time">
            </div>
            <div class="form-group">
               <label>Last Order Time <small>(24 hrs format)</small></label>
               <input type="time" class="form-control" required v-model="last_order_time">
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
       props: ['record'],
       data : function(){
           return {
               isLoading: false,
               id: this.record ? this.record.id : null ,
               title: this.record ? this.record.title : null ,
               from_time: this.record ? this.record.from_time : null ,
               to_time: this.record ? this.record.to_time : null ,
               last_order_time: this.record ? this.record.last_order_time : null ,
               status: this.record ? this.record.status : 1 ,
           };
       },
       computed: {
           modal_title: function(){
               let title = this.id ? "Edit" : "Add" ;
               title += " Time Slot";
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

           saveRecord: function(){
               let vm = this;
               this.isLoading = true;

               let formData = new FormData();
               if(this.id) {
                   formData.append('id', this.id);
               }
               formData.append('title', this.title);
               formData.append('from_time', this.from_time);
               formData.append('to_time', this.to_time);
               formData.append('to_time', this.to_time);
               formData.append('last_order_time', this.last_order_time);
               formData.append('status', this.status);
               let url = this.$apiUrl + '/time_slots/save';

               if(this.id){
                   url = this.$apiUrl + '/time_slots/update';
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
                       //console.log('Response : Success');
                       this.$eventBus.$emit('TimeSlotsSaved', data.message);
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
   .image_preview{
   margin-top: 5px;
   }
</style>
