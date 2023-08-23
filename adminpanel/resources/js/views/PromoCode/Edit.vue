<template>
  <b-modal ref="my-modal" :title="modal_title" @hidden="$emit('modalClose')" size="lg" scrollable no-close-on-backdrop no-fade static>
    <div slot="modal-footer">
      <b-button variant="primary" @click="$refs['dummy_submit'].click()" :disabled="isLoading || (Number(this.minimum_order_amount) < Number(this.discount))">
        Save
        <b-spinner v-if="isLoading" small label="Spinning"></b-spinner>
      </b-button>
      <b-button variant="secondary" @click="hideModal">Cancel</b-button>
    </div>
    <form ref="my-form" @submit.prevent="saveRecord">

        <div v-if="Number(this.minimum_order_amount) < Number(this.discount)" class="alert alert-light-danger color-danger alert-dismissible fade show" role="alert">
            <strong><i class="bi bi-exclamation-triangle"></i> Error!</strong>
            Discount is grater than minimum order amount.
            <button
                type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close"
            ></button>
        </div>





      <div class="row">
        <label><span class="text-danger text-xs">*</span> {{__('required_fields')}}</label>
        <div class="divider mt-0"><div class="divider-text">Promo Code Form</div></div>
        <div class="form-group col-md-6">
          <label>Promo Code <i class="text-danger">*</i></label>
          <input type="text" class="form-control" v-model="promo_code" placeholder="Enter promo code." />
        </div>
        <div class="form-group col-md-6">
          <label>Message <i class="text-danger">*</i></label>
          <input type="text" class="form-control" v-model="message" placeholder="Enter message." />
        </div>

        <div class="form-group col-md-6">
          <label>Start Date <i class="text-danger">*</i></label>
          <input type="date" class="form-control" v-model="start_date" placeholder="Enter start date." />
        </div>
        <div class="form-group col-md-6">
          <label>End Date <i class="text-danger">*</i></label>
          <input type="date" class="form-control" v-model="end_date" placeholder="Enter end date." />
        </div>

        <div class="form-group col-md-6">
          <label>No. of Users <i class="text-danger">*</i></label>
          <input type="number" step="1" class="form-control" v-model="no_of_users" placeholder="Enter no. of users" />
        </div>
        <div class="form-group col-md-6">
          <label>Minimum Order Amount <i class="text-danger">*</i></label>
          <input type="number" min="0" step="0.01" class="form-control" v-model="minimum_order_amount" placeholder="Enter minimum order amount." />
        </div>


        <div class="form-group col-md-6">
          <label>Discount Type <i class="text-danger">*</i></label>
          <select class="form-control form-select" v-model="discount_type">
            <option value="">Select discount type</option>
            <option value="percentage">Percentage</option>
            <option value="amount">Amount</option>
          </select>
        </div>

          <div class="form-group col-md-6" v-if="discount_type != '' ">
              <label>Discount <i class="text-danger">*</i></label>
              <input type="number" required min="0.01" max="100" step="0.01" class="form-control" v-if="discount_type == 'percentage'" v-model="discount" placeholder="Enter discount percentage." />
              <input type="number" required min="0" step="0.01" class="form-control" v-if="discount_type == 'amount'" v-model="discount" placeholder="Enter discount amount." />
          </div>

        <div class="form-group col-md-6">
          <label>Max Discount Amount <i class="text-danger">*</i></label>
          <input type="number" class="form-control" v-model="max_discount_amount" placeholder="Enter max discount amount." />
        </div>
        <div class="form-group col-md-6">
          <label>Repeat Usage <i class="text-danger">*</i></label>
          <select class="form-control form-select" v-model="repeat_usage">
            <option value="">Select </option>
            <option value="1">Allowed</option>
            <option value="0">Not Allowed</option>
          </select>
        </div>

        <div class="form-group col-md-6" v-if="repeat_usage === 1 || repeat_usage === '1'">
          <label>No. Of Repeat Usage <i class="text-danger">*</i></label>
          <input type="number" min="0" step="1" class="form-control" required v-model="no_of_repeat_usage" placeholder="Enter no. of repeat user" />
          <span class="text text-primary font-size-13">Set 0 if you want to remove limit.</span>
        </div>
          <div class="form-group">
              <label>Image</label>
              <p class="text-muted">Please choose square image of larger than 350px*350px &amp; smaller than 550px*550px.</p>
              <input type="file" accept="image/*" name="image" v-on:change="handleFileUpload" ref="file_image" class="file-input">
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
                  <div class="col-md-4">
                      <img class="custom-image" :src="image_url" title='Promo code image' alt='Promo code image'/>
                  </div>
              </div>
          </div>
        <div class="form-group col-md-12" v-if="id">
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
import axios from "axios";

export default {
  props: ["record"],
  data: function () {
    return {
      isLoading: false,
      id: this.record ? this.record.id : "",
      promo_code: this.record ? this.record.promo_code : "",
      message: this.record ? this.record.message : "",
      start_date: this.record ? this.record.start_date : "",
      end_date: this.record ? this.record.end_date : "",
      no_of_users: this.record ? this.record.no_of_users : "",
      minimum_order_amount: this.record ? this.record.minimum_order_amount : "",
      discount_type: (this.record && this.record.length !== 0) ? this.record.discount_type:"",
      discount: this.record ? this.record.discount : "",
      max_discount_amount: this.record ? this.record.max_discount_amount : "",
      repeat_usage: this.record ? this.record.repeat_usage:"",
      no_of_repeat_usage: this.record ? this.record.no_of_repeat_usage : 0,
      status: this.record ? this.record.status : 1,
      image: this.record ? this.record.image_url : "",
      image_url: this.record ? this.record.image_url : "",
    };
  },
  computed: {
    modal_title: function () {
      let title = this.id ? "Edit" : "Add";
      title += " Promo Code";
      return title;
    },
      isInvalidDiscount() {
          return this.minimum_order_amount < this.discount;
      }


  },
  methods: {
    showModal() {
      this.$refs["my-modal"].show();
    },
    hideModal() {
      console.log("hideModal");
      this.$refs["my-modal"].hide();
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
        formData.append("id", this.id);
      }
      formData.append("promo_code", this.promo_code);
      formData.append("message", this.message);
      formData.append("start_date", this.start_date);
      formData.append("end_date", this.end_date);
      formData.append("no_of_users", this.no_of_users);
      formData.append("minimum_order_amount", this.minimum_order_amount);
      formData.append("discount", this.discount);
      formData.append("discount_type", this.discount_type);
      formData.append("max_discount_amount", this.max_discount_amount);
      formData.append("repeat_usage", this.repeat_usage);
      formData.append("no_of_repeat_usage", this.no_of_repeat_usage);
      formData.append("status", this.status);
      formData.append("image", this.image);

      let url = this.$apiUrl + "/promo_code/save";
      if (this.id) {
        url = this.$apiUrl + "/promo_code/update";
      }

      axios.post(url, formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        })
        .then((res) => {
          let data = res.data;
          console.log("Response:");
          console.log(data);
          if (data.status === 1) {
            console.log("Response : Success");
            /*vm.$eventBus.$emit('categorySaved', data.message);
                    vm.hideModal();*/
            this.$eventBus.$emit("PromoCodeSaved", data.message);
            vm.$router.push({path: '/promo_code'});
            this.hideModal();
            /*if(this.id) {
                        vm.$eventBus.$emit('categorySaved', data.message, data.plan);
                    }else{
                        vm.$eventBus.$emit('planCreated', data.message, data.plan);
                    }*/
          } else {
            vm.showError(data.message);
            vm.isLoading = false;
          }
        }).catch((error) => {
          vm.isLoading = false;
          if (error.request.statusText) {
              this.showError(error.request.statusText);
          }else if (error.message) {
              this.showError(error.message);
          } else {
              this.showError(__('something_went_wrong'));
          }
        });
    },
  },
  mounted() {
    this.showModal();
  },
};
</script>

<style scoped>

</style>
