<template>
  <div>
    <div class="page-heading">
      <div class="row">
        <div class="col-12 col-md-6 order-md-1 order-last">
          <h3>Manage Time Slots</h3>
        </div>
        <div class="col-12 col-md-6 order-md-2 order-first">
          <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                  <router-link to="/dashboard">{{ __('dashboard') }}</router-link>
              </li>
              <li class="breadcrumb-item active" aria-current="page">Manage Time Slots</li>
            </ol>
          </nav>
        </div>
      </div>

      <div class="row">
        <div class="col-12 col-md-12 order-md-1 order-last">
          <div class="card">
            <div class="card-header">
              <h4>Time Slot Config</h4>
              <span class="pull-right">
                <button class="btn btn-primary" @click="edit_record=true" v-if="$can('time_slot_create')">Add New Time Slot</button>
              </span>
            </div>

            <div class="card-body">
              <div class="row">
                <div class="col-md-4">
                  <div class="box-body">
                    <div class="form-group">
                      <label for="time_slots_is_enabled">Enable / Disable Time Slots</label>
                      <input type="checkbox" required id="time_slots_is_enabled" v-model="timeSlot_settingsObject.time_slots_is_enabled" class="form-check-input" :value="0">
                    </div>
                    <div class="form-group">
                      <label>Delivery Starts From?</label>
                      <select class="form-control form-select" v-model="timeSlot_settingsObject.time_slots_delivery_starts_from">
                        <option value="">Select starts from day</option>
                        <option value="1">Today</option>
                        <option value="2">Tomorrow</option>
                        <option value="3">Third Day</option>
                        <option value="4">Fourth Day</option>
                        <option value="5">Fifth Day</option>
                        <option value="6">Sixth Day</option>
                        <option value="7">Seventh Day</option>
                      </select>
                      <br />
                    </div>
                    <div class="form-group">
                      <label>How many Days you want to allow?</label>
                      <select class="form-control form-select" v-model="timeSlot_settingsObject.time_slots_allowed_days">
                        <option value="">Select allowed days</option>
                        <option value="1">1</option>
                        <option value="7" selected>7</option>
                        <option value="15">15</option>
                        <option value="30">30</option>
                      </select>
                      <br />
                    </div>

                    <div class="box-footer">
                      <button
                        type="submit"
                        class="btn btn-primary"
                        @click="addTimeSlotsSettings"
                        :disabled="isLoading"
                      >Add <b-spinner v-if="isLoading" small label="Spinning"></b-spinner></button>
                    </div>
                  </div>
                </div>
                <div class="col-md-8">
                  <b-row class="mb-2">
                    <b-col md="3" offset-md="8">
                        <h6 class="box-title">Search</h6>
                      <b-form-input
                        id="filter-input"
                        v-model="filter"
                        type="search"
                        placeholder="Search"
                      ></b-form-input>
                    </b-col>
                      <b-col md="1" class="text-center">
                          <button class="btn btn-primary btn_refresh" v-b-tooltip.hover :title="__('refresh')" @click="getTimeSlots()">
                              <i class="fa fa-refresh" aria-hidden="true"></i>
                          </button>
                      </b-col>


                  </b-row>

                  <b-table
                    :items="time_slots"
                    :fields="fields"
                    :current-page="currentPage"
                    :per-page="perPage"
                    :filter="filter"
                    :filter-included-fields="filterOn"
                    :sort-by.sync="sortBy"
                    :sort-desc.sync="sortDesc"
                    :sort-direction="sortDirection"
                    :bordered="true"
                    :busy="isLoading"
                    stacked="md"
                    show-empty
                    small
                  >
                      <template #table-busy>
                          <div class="text-center text-black my-2">
                              <b-spinner class="align-middle"></b-spinner>
                              <strong>{{ __('loading') }}...</strong>
                          </div>
                      </template>

                      <template #cell(status)="row">
                          <span class='badge bg-success' v-if="row.item.status == 1">Active</span>
                          <span class='badge bg-danger' v-if="row.item.status == 0">Deactive</span>
                      </template>

                    <template #cell(actions)="row">
                      <button class="btn btn-sm btn-primary" @click="edit_record = row.item" v-if="$can('time_slot_update')" v-b-tooltip.hover :title="__('edit')"><i class="fa fa-pencil"></i></button>
                      <button class="btn btn-sm btn-danger" @click="deleteTimeSlots(row.index,row.item.id)" v-if="$can('time_slot_delete')" v-b-tooltip.hover :title="__('delete')"><i class="fa fa-trash"></i></button>
                    </template>
                  </b-table>

                  <b-row>
                    <b-col md="2" class="my-1">
                      <b-form-group
                        :label="__('per_page')"
                        label-for="per-page-select"
                        label-align-sm="right"
                        label-size="sm"
                        class="mb-0"
                      >
                        <b-form-select
                          id="per-page-select"
                          v-model="perPage"
                          :options="pageOptions"
                          size="sm"
                          class="form-control form-select"
                        ></b-form-select>
                      </b-form-group>
                    </b-col>
                    <b-col md="4" class="my-1" offset-md="6">
                      <b-pagination
                        v-model="currentPage"
                        :total-rows="totalRows"
                        :per-page="perPage"
                        align="fill"
                        size="sm"
                        class="my-0"
                      ></b-pagination>
                    </b-col>
                  </b-row>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Add / Edit -->
    <app-edit-record v-if="edit_record" :record="edit_record" @modalClose="edit_record = null"></app-edit-record>
  </div>
</template>
<script>
import { VuejsDatatableFactory } from "vuejs-datatable";
import EditRecord from "./Edit.vue";

export default {
  components: {
    VuejsDatatableFactory,
    "app-edit-record": EditRecord,
  },
  data: function () {
    return {
      fields: [
        { key: "id", label: "ID", sortable: true, sortDirection: "desc" },
        { key: "title", label: "Title", sortable: true, sortDirection: "desc", class: "text-center" },
        { key: "from_time", label: "From Time", sortable: true, sortDirection: "desc", class: "text-center"},
        { key: "to_time", label: "To Time", sortable: true, sortDirection: "desc", class: "text-center" },
        { key: "last_order_time", label: "Last Order Time", sortable: true, sortDirection: "desc", class: "text-center" },
        { key: "status", label: "Status", sortable: true, sortDirection: "desc", class: "text-center" },
        { key: "actions", label: "Actions" },
      ],
      totalRows: 1,
      currentPage: 1,
      perPage: this.$perPage,
      pageOptions: this.$pageOptions,
      sortBy: "",
      sortDesc: false,
      sortDirection: "asc",
      filter: null,
      filterOn: [],
      page: 1,

      time_slots: [],
      isLoading: false,
      sectionStyle: "style_1",
      max_visible_categories: 12,
      max_col_in_single_row: 3,
      edit_record: null,


      is_time_slots_enabled: false,
      delivery_starts_from: "",
      allowed_days: 1,

      timeSlot_settingsObject:{},
      timeSlot_settings:{}
    };
  },
  computed: {
    sortOptions() {
      // Create an options list from our fields
      return this.fields
        .filter((f) => f.sortable)
        .map((f) => {
          return { text: f.label, value: f.key };
        });
    },
  },
  mounted() {
    // Set the initial number of items
    this.totalRows = this.time_slots.length;
  },
  created: function () {
    this.$eventBus.$on("TimeSlotsSaved", (message) => {
      this.showMessage("success", message);
      this.getTimeSlots();
    });
    this.getTimeSlots();
    this.getTimeSlotsSettings();
  },
  methods: {
    getTimeSlots() {
      this.isLoading = true;
      axios.get(this.$apiUrl + "/time_slots").then((response) => {
        this.isLoading = false;
        let data = response.data;
        this.time_slots = data.data;

        console.log("time_slots =>", this.time_slots);

        this.totalRows = this.time_slots.length;
      });
    },
    deleteTimeSlots(index, id) {
      this.$swal
        .fire({
          title: "Are you Sure?",
          text: "You want be able to revert this",
          confirmButtonText: "Yes, Sure",
          cancelButtonText: "Cancel",
          icon: "warning",
          showCancelButton: true,
          confirmButtonColor: "#37a279",
          cancelButtonColor: "#d33",
        })
        .then((result) => {
          if (result.value) {
            this.isLoading = true;
            let postData = {
              id: id,
            };
            axios
              .post(this.$apiUrl + "/time_slots/delete", postData)
              .then((response) => {
                this.isLoading = false;
                let data = response.data;
                this.time_slots.splice(index, 1);
                //this.showSuccess(data.message);
                this.showMessage("success", data.message);
              });
          }
        });
    },
    getTimeSlotsSettings(){
        axios.get(this.$apiUrl + "/time_slots/getTimeSlotsSettings").then((response) => {
            let data = response.data.data;
            this.timeSlot_settingsObject = data.timeSlot_settingsObject;
            this.timeSlot_settings =  response.data.data.timeSlot_settings;
            this.timeSlot_settings.map((item, index)=>{
                if(item.value === 'false' || item.value === 'true'){
                    this.timeSlot_settingsObject[item.variable] = (item.value === 'false')?false:true;
                }else{
                    this.timeSlot_settingsObject[item.variable] = item.value;
                }
            });
        });
    },
    addTimeSlotsSettings() {
        this.isLoading = true;
        let timeSlot_settingsObject = this.timeSlot_settingsObject;
        let formData = new FormData();
        for(let key in timeSlot_settingsObject){
            formData.append(key, timeSlot_settingsObject[key]);
        }
        console.log("timeSlot_settingsObject",timeSlot_settingsObject);
        console.log("formData",formData);
        axios.post(this.$apiUrl + "/time_slots/saveTimeSlotsSettings", formData)
        .then((response) => {
            let data = response.data;
            if (data.status === 1) {
                this.getTimeSlotsSettings();
                this.isLoading = false;
                this.showMessage("success", data.message);
            }else{
                this.isLoading = false;
                //this.showMessage("error", data.message);
                this.showError(data.message);
            }
        });
    },
  },
};
</script>
