<template>

    <div>

        <div class="page-heading">
            <div class="row">
                <div class="col-12 col-md-6 order-md-1 order-last">
                    <h3>Manage City's Center Points (Latitude & Longitude)</h3>
                </div>
                <div class="col-12 col-md-6 order-md-2 order-first">
                    <nav aria-label="breadcrumb" class="breadcrumb-header float-start float-lg-end">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <router-link to="/dashboard">{{ __('dashboard') }}</router-link>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Manage Cities</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <div class="row">
                <div class="col-12 col-md-12 order-md-1 order-last">
                    <div class="card">
                        <div class="card-header">
                            <h4>Manage Cities</h4>
                            <span class="pull-right">
                                <router-link to="/cities/create" class="btn btn-primary" v-if="$can('city_create')">Add New City</router-link>
                            </span>
                        </div>
                        <div class="card-body">
                            <b-row class="mb-2">
                                <b-col md="3" offset-md="8">
                                    <h6 class="box-title">{{ __('search') }}</h6>
                                    <b-form-input
                                        id="filter-input"
                                        v-model="filter"
                                        type="search"
                                        :placeholder="__('search')"
                                        @keyup="addFilter"
                                    ></b-form-input>

                                </b-col>
                                <b-col md="1" class="text-center">
                                    <button class="btn btn-primary btn_refresh" v-b-tooltip.hover :title="__('refresh')" @click="getRecords()">
                                        <i class="fa fa-refresh" aria-hidden="true"></i>
                                    </button>
                                </b-col>
                            </b-row>
                            <div class="table-responsive">



                                <b-table
                                    id="my-table"
                                    ref="table"

                                    head-variant="unset"

                                    :items="cities"
                                    :fields="fields"
                                    :current-page="currentPage"
                                    :per-page="perPage"

                                    :filter="filter"
                                    :filter-included-fields="filterOn"
                                    :sort-by.sync="sortBy"
                                    :sort-desc.sync="sortDesc"
                                    :sort-direction="sortDirection"
                                    @sort-changed="getRecords"
                                    :bordered="true"
                                    :busy="isLoading"

                                    stacked="md"
                                    show-empty
                                    small
                                    empty-text="There are no cities to show"
                                    :key="cities.length"
                                >
                                    <template #table-busy>
                                        <div class="text-center text-black my-2">
                                            <b-spinner class="align-middle"></b-spinner>
                                            <strong>{{ __('loading') }}...</strong>
                                        </div>
                                    </template>
<!--
                                    <template v-slot:head()="data">
                                        <TableHeader :data="data" :filters="filters" />
                                    </template>
-->
                                    <template #cell(actions)="row">
                                        <div style="width: 120px">
                                            <router-link
                                                :to="{ name: 'EditCity',params: { id: row.item.id, record : row.item }}"
                                                v-b-tooltip.hover :title="__('edit')" class="btn btn-sm btn-primary"
                                                v-if="$can('city_update')">
                                                <i class="fa fa-pencil"></i>
                                            </router-link>
                                            <button class="btn btn-sm btn-danger" v-b-tooltip.hover :title="__('delete')"
                                                    @click="deleteRecord(row.index,row.item.id)"
                                                    v-if="$can('city_delete')">
                                                <i class="fa fa-trash"></i>
                                            </button>
                                        </div>
                                    </template>
                                </b-table>
                            </div>
                            <b-row>
                                <b-col md="2" class="my-1">
                                    <label>
                                        <b-form-group
                                            :label="__('per_page')"
                                            label-for="per-page-select"
                                            label-align-sm="right"
                                            label-size="sm"
                                            class="mb-0">
                                            <b-form-select
                                                id="per-page-select"
                                                v-model="perPage"
                                                @change = "addFilter"
                                                :options="pageOptions"
                                                size="sm"
                                                class="form-control form-select"
                                            ></b-form-select>
                                        </b-form-group>
                                    </label>
                                </b-col>
<!--                                @page-click="getRecords"-->
                                <b-col md="4" class="my-1" offset-md="6">
                                    <label>Total Records:- {{ totalRows }}</label>,
<!--                                    <label>Current Page: {{ currentPage }}</label>,
                                    <label>Limit(Per Page): {{ perPage }}</label>,
                                    <label>Offset: {{ offset }}</label>-->
                                    <b-pagination
                                        v-if="totalRows > 0"
                                        @input = "getRecords"

                                        v-model="currentPage"
                                        :total-rows="totalRows"
                                        :per-page="perPage"

                                        aria-controls="my-table"
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

</template>
<script>
import {VuejsDatatableFactory} from 'vuejs-datatable';
import axios from "axios";
import moment from "moment";

export default {
    components: {
        VuejsDatatableFactory,
    },
    data: function () {
        return {
            isLoading: false,

            fields: [
                {key: 'id', label: 'ID', sortable: true, sortDirection: 'desc'},
                {key: 'name', label: 'Name', sortable: true, sortDirection: 'desc'},
                {key: 'state', label: 'State', sortable: true, sortDirection: 'desc'},
                {key: 'latitude', label: 'Latitude', sortable: true, sortDirection: 'desc'},
                {key: 'longitude', label: 'Longitude', sortable: true, sortDirection: 'desc'},
                {key: 'max_deliverable_distance', label: 'Max Deliverable Distance (km)', sortable: true, sortDirection: 'desc'},
                {key: 'actions', label: __('actions')}
            ],

            totalRows: 1,

            currentPage: 1,
            perPage: this.$perPage,
            pageOptions: this.$pageOptions,
            offset: 0,

            sortBy: 'id',
            sortDesc: true,
            sortDirection: 'desc',

            filter: null,
            filterOn: [],

            cities: [],

        }
    },
    mounted() {
        // Set the initial number of items

    },
    created: function () {
        this.getRecords();
    },
    /*watch: {
        currentPage: {
            handler: function(value) {
                this.getRecords().catch(error => {
                    console.error("watch error ", error)
                });
            }
        }
    },*/
    methods: {

        addFilter(){
            this.cities = [];
            this.totalRows = 1;
            this.currentPage = 1;
            this.offset = 0;
            this.getRecords();
        },

        getRecords() {
            this.isLoading = true
            // this.cities = [];
            let vm = this;

            // this.offset = 0;
            this.offset = this.perPage * (this.currentPage-1);

            let param = {
                search: this.filter,
                sort_by: this.sortBy,
                sort_dir: this.sortDirection,

                limit : this.perPage,
                offset : this.offset,
            }


            axios.get(this.$apiUrl + '/cities', {
                params: param
            }).then((response) => {
                    this.isLoading = false
                    let data = response.data;

                    // this.cities = data.data.cities;
                    // this.cities = [...data.data.cities];

                    if(data.data.cities.length>0) {

                        /*data.data.cities.map((item) => {
                            this.cities.push(item);
                        });*/


                        //this.cities = [...data.data.cities];
                        const uniqueCities = new Set([...this.cities, ...data.data.cities]);
                        this.cities = Array.from(uniqueCities);

                        this.cities = [...new Set(this.cities.map(JSON.stringify))].map(JSON.parse);





                        // Function to remove duplicate objects
                        /*function removeDuplicateObjects(array) {
                            return array.filter((obj, index) => {
                                const firstIndex = array.findIndex(
                                    (innerObj) =>
                                        innerObj.id === obj.id && innerObj.name === obj.name
                                );
                                return index === firstIndex;
                            });
                        }*/

                        /*this code is remove duplicate element*/

                        /*this.cities = this.cities.filter((obj, index) => {
                            const firstIndex = this.cities.findIndex(
                                (innerObj) =>
                                    innerObj.id === obj.id
                            );
                            return index === firstIndex;
                        });*/

                    }

                    this.totalRows = data.data.total;

                    // this.$refs.table.$forceUpdate();
                    // this.$refs.table.refresh();
                    // this.$root.$emit('bv::refresh::table', 'my-table')
                    // this.$eventBus.$emit('bv::refresh::table', 'my-table')
                    // this.$eventBus.$emit('input', 'my-table')



                    console.log("this.cities -----=>", this.cities);
                    console.log("this.cities length =>", this.cities.length);

                    /*console.log("this.cities typeof =>", typeof this.cities);
                    console.log("param =>", param);
                    console.log("totalRows =>", this.totalRows);*/

                   // this.totalRows = this.cities.length

                }).catch(error => {
                vm.isLoading = false;
                if (error?.request?.statusText) {
                    this.showError(error?.request?.statusText);
                }else if (error.message) {
                    this.showError(error.message);
                } else {
                    this.showError(__('something_went_wrong'));
                }
            });
        },

        deleteRecord(index, id) {
            this.$swal.fire({
                title: "Are you Sure?",
                text: "You want be able to revert this",
                confirmButtonText: "Yes, Sure",
                cancelButtonText: "Cancel",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#37a279',
                cancelButtonColor: '#d33',
            }).then(result => {
                if (result.value) {
                    this.isLoading = true
                    let postData = {
                        id: id
                    }
                    axios.post(this.$apiUrl + '/cities/delete', postData)
                        .then((response) => {
                            this.isLoading = false
                            let data = response.data;
                            this.cities.splice(index, 1)
                            this.showSuccess(data.message)
                        });
                }
            });
        },
    }
};
</script>
